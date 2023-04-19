import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../presentation/di/locator.dart';

class Nav extends StatefulWidget {
  Nav({required this.routes});

  final List<MaterialPageRoute> routes;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NavState(routes: routes);
  }
}

class NavState extends State<Nav> {
  NavState({
    required this.routes,
  });

  List<MaterialPageRoute> routes;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    @override
    List<Route<dynamic>> defaultGenerateInitialRoutes(String initialRouteName) {
      return this.routes;
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: MaterialApp(
        title: getEnvironment(),
        theme: ThemeData(
          textTheme: GoogleFonts.sourceSansProTextTheme(),
          primarySwatch: Colors.blue,
        ),
        onGenerateInitialRoutes: defaultGenerateInitialRoutes,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) {
          return null;
        },
      ),
    );
  }
}
