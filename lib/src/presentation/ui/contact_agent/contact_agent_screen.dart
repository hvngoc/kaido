import 'package:flutter/material.dart';
import 'package:propzy_home/src/presentation/view/contact_info_form.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/app_style.dart';
import 'package:propzy_home/src/util/util.dart';

class ContactAgentScreen extends StatefulWidget {
  const ContactAgentScreen({Key? key}) : super(key: key);

  @override
  State<ContactAgentScreen> createState() => _ContactAgentScreenState();
}

class _ContactAgentScreenState extends State<ContactAgentScreen> {
  bool isCheckNeedBuy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liên hệ chuyên viên tư vấn',
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          shrinkWrap: true,
          children: [
            AgentInfoView(),
            ContactInfoForm(),
            CustomCheckBoxView(
              value: isCheckNeedBuy,
              onTapCallback: () {
                setState(() {
                  isCheckNeedBuy = !isCheckNeedBuy;
                });
              },
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              margin: EdgeInsets.only(top: 12, bottom: 12),
              height: 64,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(AppColor.orangeDark),
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => AppColor.rippleLight),
                ),
                onPressed: () {},
                child: Text(
                  'Gửi',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCheckBoxView extends StatelessWidget {
  const CustomCheckBoxView({
    Key? key,
    required this.value,
    this.onTapCallback,
  }) : super(key: key);

  final bool value;
  final Function()? onTapCallback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: InkWell(
        onTap: onTapCallback,
        child: Row(
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: Util.checkboxFilter(value),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              'Tôi có nhu cầu vay mua nhà',
              style: BigRevampStyle.checkboxTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class AgentInfoView extends StatelessWidget {
  const AgentInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 70,
            child: Image(
              image: AssetImage('assets/images/no_avatar.png'),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8),
          Text('Nguyễn Thùy Thuý Anh',
              style: TextStyle(fontWeight: FontWeight.w700)),
          SizedBox(height: 8),
          Text('Chuyên viên tư vấn Propzy')
        ],
      ),
    );
  }
}
