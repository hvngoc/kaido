import 'package:flutter/material.dart';
import 'package:propzy_home/src/domain/model/propzy_home_process_model.dart';
import 'package:propzy_home/src/util/app_colors.dart';

class PropzyHomeProcessView extends StatelessWidget {
  const PropzyHomeProcessView({
    Key? key,
    required this.listProcess,
  }) : super(key: key);

  final List<PropzyHomeProcessModel> listProcess;

  List<Widget> _renderListTitles() {
    List<Widget> listTitleView = [];
    for (var i = 0; i < listProcess.length; i++) {
      TextAlign textAlign = TextAlign.center;
      if (i == 0) {
        textAlign = TextAlign.left;
      } else if (i == listProcess.length - 1) {
        textAlign = TextAlign.right;
      }
      listTitleView.add(TitleProcessStepView(
        title: listProcess[i].name ?? '',
        textAlign: textAlign,
      ));
    }
    return listTitleView;
  }

  List<Widget> _renderListIcons() {
    return listProcess
        .map((item) => ProcessStepView(processModel: item))
        .toList();
  }

  double calcTotalPercent() {
    if (listProcess.length == 0) {
      return 0;
    }
    final totalStage = listProcess.length - 1;
    double totalPercent = 0;
    for(PropzyHomeProcessModel step in listProcess) {
      final percent = step.percent ?? 0;
      if (percent != 0) {
        totalPercent += percent / totalStage;
      }
    }
    return totalPercent;
  }

  @override
  Widget build(BuildContext context) {
    final totalPercent = calcTotalPercent();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _renderListTitles(),
        ),
        SizedBox(height: 8),
        Container(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 13,
                ),
                child: LinearProgressIndicator(
                  minHeight: 4,
                  value: totalPercent / 100,
                  color: AppColor.orangeDark,
                  backgroundColor: AppColor.grayCC,
                ),
              ),
              Row(
                children: _renderListIcons(),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TitleProcessStepView extends StatelessWidget {
  const TitleProcessStepView({
    Key? key,
    required this.title,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  final String title;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final maxWidth = textAlign == TextAlign.center
        ? (MediaQuery.of(context).size.width - 60) / 4
        : (MediaQuery.of(context).size.width - 60) / 6;
    return Container(
      width: maxWidth,
      child: Text(
        title,
        maxLines: 2,
        textAlign: textAlign,
      ),
    );
  }
}

class ProcessStepView extends StatelessWidget {
  const ProcessStepView({
    Key? key,
    required this.processModel,
  }) : super(key: key);

  final PropzyHomeProcessModel processModel;

  @override
  Widget build(BuildContext context) {
    final active = processModel.active ?? false;
    final processIcon = processModel.processIcon ?? '';
    final completedIcon = processModel.completedIcon ?? '';
    final imageUrl = active ? completedIcon : processIcon;
    if (imageUrl.isNotEmpty) {
      return SizedBox(width: 30, height: 30, child: Image.network(imageUrl));
    } else {
      return Image(
        image: AssetImage(
          'assets/images/img_no_image.png',
        ),
        width: 30,
        height: 30,
      );
    }
  }
}
//
