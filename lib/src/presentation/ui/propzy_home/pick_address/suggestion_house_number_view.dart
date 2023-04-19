import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:propzy_home/src/domain/model/propzy_map_model.dart';
import 'package:propzy_home/src/domain/request/propzy_map_request.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/pick_address/pick_address_bloc.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/pick_address/pick_address_event.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/pick_address/pick_address_state.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/propzy_home_bloc.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:rxdart/rxdart.dart';

class SuggestionHouseNumberTextField extends StatefulWidget {
  final String? initialHouseNumber;
  final Subject<String> streamTextHouseNumberChange;
  final Function(SearchAddressWithStreet searchAddressWithStreet)? onClickItemSuggestion;
  final InputDecoration decoration;
  final EdgeInsetsGeometry? padding;
  final int? streetId;
  final TextEditingController? controller;

  const SuggestionHouseNumberTextField({
    Key? key,
    this.initialHouseNumber,
    required this.streamTextHouseNumberChange,
    this.onClickItemSuggestion,
    required this.decoration,
    this.padding = null,
    this.streetId,
    this.controller,
  }) : super(key: key);

  @override
  State<SuggestionHouseNumberTextField> createState() => _SuggestionHouseNumberTextFieldState();
}

class _SuggestionHouseNumberTextFieldState extends State<SuggestionHouseNumberTextField> {
  final FocusNode _houseNumberNode = FocusNode();
  late TextEditingController _controllerHouseNumber;

  @override
  void initState() {
    super.initState();
    _controllerHouseNumber =
        widget.controller ?? TextEditingController(text: widget.initialHouseNumber ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      child: KeyboardActions(
        disableScroll: true,
        config: getBuildConfig(),
        tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
        child: TextFormField(
          controller: _controllerHouseNumber,
          focusNode: _houseNumberNode,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColor.secondaryText,
          ),
          decoration: widget.decoration,
          onChanged: (value) {
            widget.streamTextHouseNumberChange.add(value);
          },
        ),
      ),
    );
  }

  KeyboardActionsConfig getBuildConfig() {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          displayActionBar: false,
          displayDoneButton: false,
          focusNode: _houseNumberNode,
          footerBuilder: (_) => PreferredSize(
            child: SizedBox(
              height: 48,
              child: Center(
                child: SuggestionHouseNumberListView(
                  focusNode: _houseNumberNode,
                  textController: _controllerHouseNumber,
                  streetId: widget.streetId,
                  onClickItemSuggestion: (searchAddressWithStreet) {
                    widget.onClickItemSuggestion?.call(searchAddressWithStreet);
                  },
                ),
              ),
            ),
            preferredSize: Size.fromHeight(48),
          ),
        )
      ],
    );
  }
}

class SuggestionHouseNumberListView extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController textController;
  final Function(SearchAddressWithStreet searchAddressWithStreet)? onClickItemSuggestion;
  final int? streetId;

  const SuggestionHouseNumberListView({
    Key? key,
    required this.focusNode,
    required this.textController,
    this.onClickItemSuggestion,
    required this.streetId,
  }) : super(key: key);

  @override
  State<SuggestionHouseNumberListView> createState() => _SuggestionHouseNumberListViewState();
}

class _SuggestionHouseNumberListViewState extends State<SuggestionHouseNumberListView> {
  final PickAddressBloc _bloc = GetIt.instance.get<PickAddressBloc>();

  String textHouseNumber = "";
  List<SearchAddressWithStreet> listSuggestion = [];
  Subject<dynamic> streamGetData = PublishSubject();

  @override
  void initState() {
    super.initState();
    widget.textController.addListener(() {
      if (this.mounted) {
        streamGetData.add(null);
      }
    });
    widget.focusNode.addListener(() {
      if (this.mounted && widget.focusNode.hasFocus) {
        streamGetData.add(null);
      }
    });

    streamGetData.stream.debounceTime(Duration(milliseconds: 500)).listen((value) {
      getSearchAddressWithStreet();
    });
  }

  void getSearchAddressWithStreet() {
    if (widget.textController.text.isNotEmpty && widget.streetId != null) {
      SearchAddressWithStreetRequest request = SearchAddressWithStreetRequest(
        streetId: widget.streetId,
        keyword: widget.textController.text,
      );
      _bloc.add(SearchAddressWithStreetEvent(0, 20, request));
    }
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider(create: (BuildContext context) => _bloc);
    return BlocConsumer<PickAddressBloc, PickAddressState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is SuccessSearchAddressWithStreetState) {
          if (state.listSearchAddressWithStreet != null) {
            listSuggestion = state.listSearchAddressWithStreet ?? [];
            setState(() {
              listSuggestion = listSuggestion;
            });
          }
        }
      },
      builder: (context, state) {
        return Container(
          height: 48,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: _renderItemSuggestion,
            itemCount: listSuggestion.length,
          ),
        );
      },
    );
  }

  Widget _renderItemSuggestion(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: 30,
      child: Center(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Color(0xFFE8EFF6),
            padding: const EdgeInsets.symmetric(horizontal: 2),
          ),
          child: Text(
            listSuggestion[index].house_number ?? "",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          onPressed: () {
            String houseNumber = listSuggestion[index].house_number ?? "";
            widget.textController.value = TextEditingValue(
              text: houseNumber,
              selection: TextSelection.fromPosition(
                TextPosition(offset: houseNumber.length),
              ),
            );

            widget.onClickItemSuggestion?.call(listSuggestion[index]);
          },
        ),
      ),
    );
  }
}
