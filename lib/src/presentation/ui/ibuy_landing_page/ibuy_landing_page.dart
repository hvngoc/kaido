import 'package:flutter/material.dart';
import 'package:propzy_home/src/presentation/ui/ibuy_landing_page/ibuy_landing_card/landing_header_card.dart';
import 'package:propzy_home/src/presentation/ui/ibuy_landing_page/ibuy_landing_card/landing_ibuy_card.dart';
import 'package:propzy_home/src/presentation/ui/ibuy_landing_page/ibuy_landing_card/landing_sell_card.dart';

class IBuyLandingPage extends StatelessWidget {
  const IBuyLandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/images/landing_footer.png',
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                LandingHeaderCard(),
                LandingIBuyCard(),
                SizedBox(
                  height: 41,
                ),
                LandingSellCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}