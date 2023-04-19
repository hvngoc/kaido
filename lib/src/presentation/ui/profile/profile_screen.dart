import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:propzy_home/src/data/local/pref/pref_helper.dart';
import 'package:propzy_home/src/presentation/ui/profile/bloc/authentication_bloc.dart';
import 'package:propzy_home/src/util/util.dart';
import 'widgets/my_sliver_appbar.dart';
import 'widgets/profile_list_menu_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen> {
  final AuthenticationBloc _bloc = GetIt.I.get<AuthenticationBloc>();
  final PrefHelper prefHelper = GetIt.I.get<PrefHelper>();
  bool isLogin = false;
  String name = 'Chưa đăng nhập';
  String? avatar = null;

  @override
  void initState() {
    super.initState();
    _bloc.add(AuthenticationGetCurrentUser());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _bloc,
      listener: (context, state) {
        if (state is AuthenticationState) {
          if (state.status == AuthenticationStatus.loading) {
            Util.showLoading();
          } else {
            Util.hideLoading();
          }
          isLogin = state.status == AuthenticationStatus.authenticated;
          name = state.user?.name ?? 'Chưa đăng nhập';
          avatar = state.user?.photo;
        }
        setState(() {});
      },
      builder: (context, state) {
        if (state is AuthenticationState) {
          isLogin = state.status == AuthenticationStatus.authenticated;
          name = state.user?.name ?? 'Chưa đăng nhập';
          avatar = state.user?.photo;
        }
        return Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverPersistentHeader(
                      delegate: MySliverAppBar(
                        title: name,
                        avatar: avatar,
                      ),
                      pinned: true,
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, int i) => ProfileListMenuView(
                          isLogin: isLogin,
                        ),
                        childCount: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  bottom: 15,
                  top: 25,
                ),
                child: FutureBuilder<String>(
                  future: Util.versionApp(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return Text(
                      'Phiên bản v${snapshot.data}',
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
