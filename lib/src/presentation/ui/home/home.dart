import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:launch_review/launch_review.dart';
import 'package:propzy_home/src/data/local/pref/pref_helper.dart';
import 'package:propzy_home/src/data/model/force_update_info.dart';
import 'package:propzy_home/src/data/model/search_model.dart';
import 'package:propzy_home/src/presentation/ui/components/custom_line_indicator_bottom_navbar.dart';
import 'package:propzy_home/src/presentation/ui/force_update/force_update_detail_screen.dart';
import 'package:propzy_home/src/presentation/ui/force_update/force_update_dialog.dart';
import 'package:propzy_home/src/presentation/ui/home/home_bloc.dart';
import 'package:propzy_home/src/presentation/ui/home/home_event.dart';
import 'package:propzy_home/src/presentation/ui/home/home_state.dart';
import 'package:propzy_home/src/presentation/ui/ibuy_landing_page/ibuy_landing_page.dart';
import 'package:propzy_home/src/presentation/ui/profile/bloc/authentication_bloc.dart';
import 'package:propzy_home/src/presentation/ui/profile/profile_screen.dart';
import 'package:propzy_home/src/presentation/ui/search/result/search_result_screen.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PrefHelper prefHelper = GetIt.I.get<PrefHelper>();
  final HomeBloc _homeBloc = GetIt.I.get<HomeBloc>();
  final AuthenticationBloc _authenticationBloc = GetIt.I.get<AuthenticationBloc>();

  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;
  List<SearchHistory> listSearchSelected = [];
  late SearchResult searchResult;

  @override
  void initState() {
    super.initState();
    searchResult = SearchResult();
    _widgetOptions = <Widget>[
      searchResult,
      IBuyLandingPage(),
      Text('Yêu thích'),
      Text('Thông báo'),
      // Text('Thêm'),
      ProfileScreen(),
    ];

    _homeBloc.add(CheckUpdateVersionEvent());
  }

  void _onItemTapped(int index, {GoToSearchEvent? event = null}) {
    setState(() {
      _selectedIndex = index;
      searchResult = SearchResult(event: event);

      _widgetOptions = <Widget>[
        searchResult,
        IBuyLandingPage(),
        Text('Yêu thích'),
        Text('Thông báo'),
        // Text('Thêm'),
        ProfileScreen(),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _homeBloc,
      child: BlocConsumer<HomeBloc, HomeState>(
        bloc: _homeBloc,
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              if (_selectedIndex == 0) {
                return true;
              } else {
                _onItemTapped(0);
                return false;
              }
            },
            child: Scaffold(
              body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
              bottomNavigationBar: buildBotNav(),
            ),
          );
        },
        listener: (context, state) {
          if (state is ShowDialogForceUpdateState) {
            showDialogForceUpdate(forceUpdateInfo: state.forceUpdateInfo);
          }
          if (state is GetInfoStateSuccess) {
            _authenticationBloc.add(AuthenticationGetCurrentUser());
          }
          if (state is GoToSearchSuccess) {
            _onItemTapped(0, event: state.event);
          }
        },
      ),
    );
  }

  CustomLineIndicatorBottomNavbar buildBotNav() {
    return CustomLineIndicatorBottomNavbar(
      selectedColor: AppColor.orangeDark,
      unSelectedColor: AppColor.gray4A,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      enableLineIndicator: true,
      lineIndicatorWidth: 3,
      indicatorType: IndicatorType.Top,
      customBottomBarItems: [
        buildBotNavItem("assets/images/vector_ic_search.svg", "Tìm kiếm", false),
        buildBotNavItem("assets/images/vector_ic_sale.svg", "Bán BĐS", false),
        buildBotNavItem("assets/images/vector_ic_like.svg", "Yêu thích", false),
        buildBotNavItem("assets/images/vector_ic_notification_badge.svg", "Thông báo", true),
        buildBotNavItem("assets/images/vector_ic_more.svg", "Thêm", false),
      ],
    );
  }

  CustomBottomBarItems buildBotNavItem(String iconPath, String label, bool badge) {
    return CustomBottomBarItems(
      label: label,
      iconPath: iconPath,
      showBadge: badge,
    );
  }

  void showDialogForceUpdate({ForceUpdateInfo? forceUpdateInfo = null}) {
    showDialog(
      context: context,
      barrierDismissible: !(forceUpdateInfo?.required == true),
      // barrierDismissible is click out side ==> set = false ==> click out side ko dong dialog
      builder: (context) => WillPopScope(
        onWillPop: () async {
          // WillPopScope is click back on android ==> set = false ==> click back on android ko dong dialog
          return !(forceUpdateInfo?.required == true);
        },
        child: ForceUpdateDialog(
          forceUpdateInfo: forceUpdateInfo,
          onTapShowMore: () {
            goToForceUpdateDetail(forceUpdateInfo);
          },
          onTapUpdate: () {
            LaunchReview.launch(androidAppId: "vn.propzy.sam", iOSAppId: "1437366845");
          },
        ),
      ),
    );
  }

  void goToForceUpdateDetail(ForceUpdateInfo? forceUpdateInfo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ForceUpdateDetailScreen(forceUpdateInfo: forceUpdateInfo),
      ),
    );
  }
}
