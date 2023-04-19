import 'package:tiengviet/tiengviet.dart';

class ChooserData {
  final int? id;
  final String? name;
  bool? isAddMore;

  String get unsignedName => TiengViet.parse(this.name ?? '');

  ChooserData(this.id, this.name, {this.isAddMore = false});
}
