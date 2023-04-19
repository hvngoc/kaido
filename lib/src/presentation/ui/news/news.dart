import 'package:flutter/material.dart';
import 'package:propzy_home/src/presentation/view/loading_view.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: LoadingView(
          width: 160,
          height: 160,
        ),
      ),
    );
  }
}
