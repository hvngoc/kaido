import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/components/orange_button.dart';
import 'package:propzy_home/src/util/navigation_controller.dart';

class CompleteRequest extends StatelessWidget {
  const CompleteRequest({
    Key? key,
    required this.offerId,
  }) : super(key: key);

  final int offerId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 192,
                        height: 192,
                        child:
                            Lottie.asset('assets/images/ae_congrat_star.json'),
                      ),
                      SizedBox(height: 36),
                      Text(
                        'Xin chúc mừng !',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 24),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Yêu cầu bán nhà của quý khách đã được Propzy ghi nhận thành công !',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      OrangeButton(
                        title: 'Xem đề nghị bán nhà của bạn',
                        onPressed: () {
                          NavigationController.navigateToDetailOffer(
                              context, offerId);
                        },
                      ),
                      SizedBox(height: 12),
                      ReturnHomeButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
