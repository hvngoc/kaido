import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:propzy_home/src/presentation/di/locator.dart';
import 'package:propzy_home/src/presentation/ui/profile/widgets/custom_webview_screen.dart';
import 'package:propzy_home/src/presentation/view/orange_appbar.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/constants.dart';

class SupportOnline extends StatelessWidget {
  const SupportOnline({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrangeAppBar(title: 'Propzy Hỗ trợ Online'),
      body: Column(
        children: [
          SupportCardItem(
            iconName: 'assets/images/ic_chat.png',
            title: 'Chat với CS',
            onPress: () {
              final _url = getChatWithCSURL();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomWebviewScreen(
                    url: _url,
                    title: 'Chat với CS',
                  ),
                ),
              );
            },
          ),
          SupportCardItem(
            iconName: 'assets/images/ic_send_email.png',
            title: 'Gửi email cho chúng tôi',
            onPress: () async {
              final Email email = Email(
                // body: 'Email body',
                // subject: 'Email subject',
                recipients: [Constants.PROPZY_CS_EMAIL],
                // cc: ['cc@example.com'],
                // bcc: ['bcc@example.com'],
                // attachmentPaths: ['/path/to/attachment.zip'],
                isHTML: false,
              );
              await FlutterEmailSender.send(email);
            },
          ),
        ],
      ),
    );
  }
}

class SupportCardItem extends StatelessWidget {
  const SupportCardItem({
    Key? key,
    required this.iconName,
    required this.title,
    required this.onPress,
  }) : super(key: key);

  final String iconName;
  final String title;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      child: Card(
        color: AppColor.grayF4,
        margin: EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            children: [
              Image(
                image: AssetImage(iconName),
                width: 50,
                height: 50,
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
