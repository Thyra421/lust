import 'dart:async';

import 'package:location/location.dart' as loc;
import 'package:lust/data/location_data.dart';
import 'package:lust/data/match_data.dart';
import 'package:lust/data/relations_data.dart';
import 'package:lust/global/api.dart';
import 'package:lust/global/location.dart';
import 'package:lust/theme.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  MatchData? _matchData;
  bool? _hasEnabledLocation;
  Duration _duration = const Duration(minutes: 48, seconds: 13);
  late Timer _timer;
  bool _loading = false;
  LocationData _locationData = LocationData();

  Future<void> _onGetLocation() async {
    loc.LocationData? locationData = await Location.tryGetLocation();
    if (locationData != null)
      _locationData = LocationData(
          posX: locationData.longitude, posY: locationData.latitude);
    setState(() => _hasEnabledLocation = locationData != null);
  }

  Future<void> _onSearch() async {
    try {
      setState(() => _loading = true);

      await _onGetLocation();
      if (!_hasEnabledLocation!) {
        setState(() => _loading = false);
        return;
      }

      await Api.setLocation(_locationData);

      MatchData matchData = await Api.search();

      setState(() {
        _matchData = matchData;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _onNotInterested() async {
    await Api.addRelations(RelationsData(notInterested: [_matchData!.userId!]));
    _onSearch();
  }

  Widget _name() => Text.rich(TextSpan(
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          children: [
            TextSpan(text: "${_matchData!.matchIdentity!.firstName!}, "),
            TextSpan(
                text: (_matchData!.matchIdentity!.dateOfBirth!
                            .difference(DateTime.now())
                            .inDays /
                        365)
                    .floor()
                    .abs()
                    .toString())
          ]));

  Widget _picture() => ClipRRect(
      borderRadius: BorderRadius.circular(kBorderRadius),
      child: Image.asset('assets/images/therock.jpg', fit: BoxFit.fitHeight));

  Widget _description() => Text(_matchData!.matchIdentity!.description!,
      textAlign: TextAlign.justify);

  Widget _hobbiesInCommon() => Text.rich(TextSpan(children: [
        const TextSpan(text: "You have "),
        TextSpan(
            text: _matchData!.commonHobbiesCount!.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const TextSpan(text: " hobbies in common")
      ]));

  Widget _distance() => Text.rich(TextSpan(children: [
        TextSpan(
            text: _matchData!.distance!.toStringAsFixed(1),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const TextSpan(text: " km away")
      ]));

  Widget _match() => Container(
      padding: const EdgeInsets.all(kHorizontalPadding),
      child: _matchData!.noMatch ?? false
          ? _noOneInSight()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                  Expanded(
                      child: Stack(fit: StackFit.expand, children: [
                    _picture(),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                            padding: const EdgeInsets.all(kHorizontalPadding),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [_name(), _distance()])))
                  ])),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: kHorizontalPadding),
                      child: _description()),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _hobbiesInCommon(),
                                  IconButton(
                                      onPressed: _onNotInterested,
                                      icon: const Icon(Icons.close,
                                          color: Colors.red)),
                                ]),
                            ElevatedButton(
                                style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(60, 60)),
                                    shape: MaterialStateProperty.all(
                                        const CircleBorder())),
                                onPressed: () {},
                                child: const Icon(Icons.message))
                          ]))
                ]));

  Widget _match2() => Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kBorderRadius),
          color: Theme.of(context).inputDecorationTheme.fillColor),
      child: Column(children: [
        Row(children: [
          Container(
              margin: const EdgeInsets.only(right: 20),
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
              child: const Icon(Icons.person, color: Colors.black, size: 40)),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text.rich(TextSpan(
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(text: "${_matchData!.matchIdentity!.firstName!}, "),
                  TextSpan(
                      text: (_matchData!.matchIdentity!.dateOfBirth!
                                  .difference(DateTime.now())
                                  .inDays /
                              365)
                          .floor()
                          .abs()
                          .toString())
                ])),
            Text.rich(TextSpan(children: [
              const TextSpan(text: "You have "),
              TextSpan(
                  text: _matchData!.commonHobbiesCount!.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: " hobbies in common")
            ]))
          ])
        ]),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(_matchData!.matchIdentity!.description!,
                textAlign: TextAlign.justify)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.pin_drop)),
            Text.rich(TextSpan(children: [
              TextSpan(
                  text: _matchData!.distance!.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: " km away")
            ]))
          ]),
          IconButton(
              icon: const Icon(Icons.waving_hand_rounded), onPressed: () {})
        ])
      ]));

  Widget _searchButton() => Center(
      child: IconButton(icon: const Icon(Icons.search), onPressed: _onSearch));

  Widget _timeIndicator() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text.rich(TextSpan(children: [
            const TextSpan(text: "Next search available in "),
            TextSpan(
                text: "${_duration.toString().split('.').first}.",
                style: const TextStyle(fontWeight: FontWeight.bold))
          ], style: const TextStyle(fontSize: 14))),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(onPressed: () {}, child: const Text("Subscribe")),
              const Text("to get unlimited search.")
            ],
          ),
        ],
      );

  Widget _loadingIndicator() =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
        CircularProgressIndicator(),
        Text("Finding the best match for you...")
      ]);

  Widget _enableLocation() =>
      const Center(child: Text("Enable your location to continue"));

  Widget _search() {
    if (_loading) return _loadingIndicator();
    if (_hasEnabledLocation != null && !_hasEnabledLocation!)
      return _enableLocation();
    if (_matchData != null) return _match();
    return Center(child: _searchButton());
  }

  Widget _noOneInSight() =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text(
            "Oh no! It seems like there is no one in sight... Try again later, or increase the search distance in your settings",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20)),
        _searchButton()
      ]);

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) =>
            setState(() => _duration -= const Duration(seconds: 1)));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _search();
  }
}
