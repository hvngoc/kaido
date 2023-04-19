import 'package:propzy_home/src/presentation/ui/search/contact_form/drop/data/chooser_data.dart';

class AddressListWard {
  AddressChooser district;
  List<AddressChooser> listWard = [];

  AddressListWard(this.district, {this.listWard = const []});
}

class AddressChooser {
  ChooserData data;
  bool isFavorite;

  AddressChooser(this.data, this.isFavorite);
}
