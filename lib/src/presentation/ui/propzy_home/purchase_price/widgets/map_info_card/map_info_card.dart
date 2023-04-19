import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:propzy_home/src/domain/model/propzy_home_marker_model.dart';
import 'package:propzy_home/src/domain/model/propzy_home_offer_model.dart';
import 'package:propzy_home/src/presentation/ui/propzy_home/purchase_price/widgets/map_info_card/bloc/map_info_card_bloc.dart';
import 'package:propzy_home/src/util/app_colors.dart';
import 'package:propzy_home/src/util/constants.dart';
import 'package:propzy_home/src/util/log.dart';
import 'package:propzy_home/src/util/message_util.dart';
import 'package:propzy_home/src/util/util.dart';

class MapInfoCard extends StatefulWidget {
  final HomeOfferModel offerModel;

  const MapInfoCard({
    Key? key,
    required this.offerModel,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MapInfoCardState(offerModel: offerModel);
  }
}

class MapInfoCardState extends State<MapInfoCard> {
  HomeOfferModel offerModel;

  MapInfoCardState({required this.offerModel});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12.0,
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(
          16,
        ),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/images/ic_iBuyer_price_map.svg',
                  width: 21,
                  height: 21,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Tham khảo thị trường BĐS ở khu vực trên',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              color: HexColor('#F0F0F0'),
              padding: EdgeInsets.only(
                left: 8,
                right: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chọn khoảng cách:',
                  ),
                  Row(
                    children: [
                      DistanceButton(
                        title: '${Constants.DISTANCE_100} M',
                        tag: Constants.DISTANCE_100,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      DistanceButton(
                        title: '${Constants.DISTANCE_200} M',
                        tag: Constants.DISTANCE_200,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      DistanceButton(
                        title: '${Constants.DISTANCE_500} M',
                        tag: Constants.DISTANCE_500,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 375,
              child: PurchaseMap(
                offerModel: offerModel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PurchaseMap extends StatefulWidget {
  const PurchaseMap({required this.offerModel});

  final HomeOfferModel offerModel;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PurchaseMapState();
  }
}

class PurchaseMapState extends State<PurchaseMap> {
  static final double ZOOM_LEVEL_DISTRICT = 14;
  static final double ZOOM_LEVEL_WARD = 16;
  final MapInfoCardBloc _bloc = GetIt.I.get<MapInfoCardBloc>();

  CameraPosition _kGooglePlex = CameraPosition(
    target: PROPZY_POSITION,
    zoom: ZOOM_LEVEL_WARD,
  );

  Set<Circle> _circles = Set.from([
    Circle(
      circleId: CircleId(''),
      center: PROPZY_POSITION,
      radius: Constants.DISTANCE_200.toDouble(),
      strokeWidth: 2,
      strokeColor: AppColor.propzyOrange,
      fillColor: AppColor.propzyOrange.withOpacity(0.2),
    )
  ]);

  Set<Marker> _markers = new Set();

  @override
  void initState() {
    super.initState();
    _bloc.offerModel = widget.offerModel;
    _bloc.add(GetListingInDistanceEvent(tag: Constants.DISTANCE_200));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _bloc,
      listener: (context, state) {
        if (state is MapInfoCardGetListingInDistanceErrorState) {
          Log.e(state.message);
          Util.showMyDialog(
            context: context,
            message: state.message ?? MessageUtil.errorMessageDefault,
          );
        } else if (state is MapInfoCardGetListingInDistanceSuccessState) {
          setState(() {
            _kGooglePlex = CameraPosition(
              target: LatLng(
                widget.offerModel.latitude ?? PROPZY_LATITUDE,
                widget.offerModel.longitude ?? PROPZY_LONGITUDE,
              ),
              zoom: ZOOM_LEVEL_DISTRICT,
            );

            _circles = Set.from([
              Circle(
                circleId: CircleId(''),
                center: LatLng(
                  widget.offerModel.latitude ?? PROPZY_LATITUDE,
                  widget.offerModel.longitude ?? PROPZY_LONGITUDE,
                ),
                radius: _bloc.tag.toDouble(),
                strokeWidth: 2,
                strokeColor: AppColor.propzyOrange,
                fillColor: AppColor.propzyOrange.withOpacity(0.2),
              )
            ]);

            _markers.clear();
            for (PropzyHomeMarkerModel marker in state.makers) {
              _markers.add(Marker(
                //add first marker
                markerId: MarkerId(marker.listingId.toString()),
                position: LatLng(
                  marker.latitude ?? PROPZY_LATITUDE,
                  marker.longitude ?? PROPZY_LONGITUDE,
                ), //position of marker
                infoWindow: InfoWindow(
                  title: marker.formatPrice,
                ),
                icon: BitmapDescriptor.defaultMarker,
              ));
            }
          });
        }
      },
      builder: (context, state) {
        if (state is MapInfoCardGetListingInDistanceSuccessState) {
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            circles: _circles,
            markers: _markers,
            gestureRecognizers: Set()
              ..add(
                  Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
          );
        } else {
          return Container(
            color: HexColor('#F0F0F0'),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class DistanceButton extends StatefulWidget {
  final String title;
  final int tag;

  const DistanceButton({
    Key? key,
    required this.title,
    required this.tag,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DistanceButtonState();
  }
}

class DistanceButtonState extends State<DistanceButton> {
  final MapInfoCardBloc _bloc = GetIt.I.get<MapInfoCardBloc>();
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: () {
        print('onTap ${widget.title}');
        _bloc.add(GetListingInDistanceEvent(
          tag: widget.tag,
        ));
      },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: BlocConsumer(
        bloc: _bloc,
        listener: (context, state) {
          // TODO: implement listener
          if (state is MapInfoCardGetListingInDistanceSuccessState) {
            setState(() {
              isSelected = _bloc.tag == widget.tag;
            });
          }
        },
        builder: (context, state) {
          return Chip(
            label: Text(
              widget.title,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColor.gray400_ibuy,
              ),
            ),
            backgroundColor:
                isSelected ? AppColor.propzyOrange : Colors.transparent,
            shape: StadiumBorder(
              side: BorderSide(
                color: isSelected ? Colors.transparent : AppColor.gray400_ibuy,
                width: isSelected ? 0 : 0.25,
              ),
            ),
          );
        },
      ),
    );
  }
}
