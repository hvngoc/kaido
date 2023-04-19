import 'dart:io';

import 'package:chuck_interceptor/chuck.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:propzy_home/src/data/local/pref/pref_helper.dart';
import 'package:propzy_home/src/presentation/di/locator.dart';
import 'package:propzy_home/src/presentation/ui/home/home.dart';
import 'package:propzy_home/src/presentation/ui/home/home_bloc.dart';
import 'package:propzy_home/src/presentation/ui/home/home_event.dart';
import 'src/presentation/ui/intro/intro_screen.dart';
import 'package:flutter/services.dart';

Chuck chuck = Chuck(
  showNotification: true,
  showInspectorOnShake: true,
);

Future<Widget> initializeApp() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await setupLocator();

  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }

  return const App();
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // FocusScopeNode currentFocus = FocusScope.of(context);
        // if (!currentFocus.hasPrimaryFocus) {
        //   currentFocus.unfocus();
        // }
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        // only add chuck without release mode
        navigatorKey: kReleaseMode ? null : chuck.getNavigatorKey(),
        title: getEnvironment(),
        theme: ThemeData(
          textTheme: GoogleFonts.sourceSansProTextTheme(),
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
        builder: FlutterSmartDialog.init(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => MySplashScreenState();
}

class MySplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  final PrefHelper _prefHelper = GetIt.I.get<PrefHelper>();
  final HomeBloc _homeBloc = GetIt.I.get<HomeBloc>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addListener(() async {
      if (_controller.value == 1.0) {
        // animation ended
        bool onBoarding = await _prefHelper.getOnBoardingStatus() ?? false;
        if (onBoarding) {
          _homeBloc.add(ReloadAccessTokenEvent());
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const OnBoarding()));
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/bg_splash.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Lottie.asset(
            'assets/json/logo_splash_screen.json',
            controller: _controller,
            frameRate: FrameRate.max,
            onLoaded: (composition) => {
              _controller
                ..duration = composition.duration
                ..forward()
            },
          ),
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    // TODO: implement createHttpClient
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => const HomePage()));
