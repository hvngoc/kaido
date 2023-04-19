import 'package:flutter/material.dart';
import 'package:propzy_home/src/presentation/view/box_input_with_validation.dart';
import 'package:propzy_home/src/presentation/view/label_text.dart';

class ContactInfoForm extends StatelessWidget {
  const ContactInfoForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoxInputWithValidation(
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            title: 'Họ tên*',
            hint: 'Nhập họ và tên',
            isError: true,
            errorMessage: 'Vui lòng nhập Họ tên của bạn',
          ),
          SizedBox(height: 8),
          BoxInputWithValidation(
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            title: 'Số điện thoại*',
            hint: 'Nhập số điện thoại',
            isError: true,
            errorMessage: 'Vui lòng nhập số điện thoại hợp lệ.',
          ),
          SizedBox(height: 8),
          BoxInputWithValidation(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            title: 'Email',
            hint: 'Nhập email',
            isError: true,
            errorMessage: 'Vui lòng nhập địa chỉ email hợp lệ.',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: LabelText(label: 'Đặt câu hỏi hoặc để lại ghi chú'),
          ),
          SizedBox(
            height: 5 * 24,
            child: TextField(
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(8),
                hintText: 'Nhập ghi chú',
              ),
            ),
          ),
        ],
      ),
    );
  }
}