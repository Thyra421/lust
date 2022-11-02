import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:lust/data/error_data.dart';
import 'package:lust/data/hobbies_data.dart';
import 'package:lust/data/identity_data.dart';
import 'package:lust/data/match_data.dart';
import 'package:lust/data/relations_data.dart';
import 'package:lust/data/settings_data.dart';
import 'package:lust/global/storage.dart';
import 'package:http/http.dart' as http;

import '../data/steps_data.dart';

class Api {
  static const String _kEndpoint = 'http://localhost:8080';
  static const Duration _kTimeoutDuration = Duration(seconds: 5);
  static String _token = "";

  static Uri _url(String route) => Uri.parse("$_kEndpoint/$route");

  static void setToken(String token) => _token = token;

  static Map<String, String> _headers({bool authorization = true}) => {
        'content-type': 'application/json',
        if (authorization) "Authorization": _token
      };

  static Future<T> _request<T>({
    required Future<http.Response> Function() query,
    required T Function(String body) onSuccess,
  }) async {
    try {
      final http.Response response = await query();
      if (response.statusCode == 200) return onSuccess(response.body);
      return Future.error(ErrorData.fromJson(jsonDecode(response.body)));
    } on TimeoutException catch (_) {
      return Future.error(ErrorData(value: "Request timeout", code: 504));
    } on SocketException catch (_) {
      return Future.error(ErrorData(value: "Server unreachable", code: 503));
    } catch (_) {
      return Future.error(ErrorData(value: "Uncategorized error", code: 400));
    }
  }

  static void logout() {
    _token = "";
    clearStorage('token');
  }

  static Future<void> login({
    required String mail,
    required String password,
  }) async =>
      await _request(
          query: () => http.post(_url('login'),
              headers: _headers(authorization: false),
              body: jsonEncode({"mail": mail, 'password': password})),
          onSuccess: (String body) {
            setToken(body);
            writeStorage('token', body);
          });

  static Future<void> register({
    required String mail,
    required String password,
  }) async =>
      await _request(
          query: () => http.post(_url('register'),
              headers: _headers(authorization: false),
              body: jsonEncode({"mail": mail, 'password': password})),
          onSuccess: (String body) {
            setToken(body);
            writeStorage('token', body);
          });

  static Future<SettingsData> getSettings() async => await _request(
      query: () => http.get(_url('settings'), headers: _headers()),
      onSuccess: (String body) => SettingsData.fromJson(jsonDecode(body)));

  static Future<void> setSettings(SettingsData settingsData) async => _request(
      query: () => http.put(_url('settings'),
          headers: _headers(), body: jsonEncode(settingsData)),
      onSuccess: (_) => {});

  static Future<HobbiesData> getHobbies() async => await _request(
      query: () => http.get(_url('hobbies'), headers: _headers()),
      onSuccess: (String body) => HobbiesData.fromJson(jsonDecode(body)));

  static Future<void> setHobbies(List<String> hobbies) async => await _request(
      query: () => http.put(_url('hobbies'),
          headers: _headers(), body: jsonEncode(hobbies)),
      onSuccess: (_) => {});

  static Future<StepsData> getSteps() async => await _request(
      query: () => http.get(_url('steps'), headers: _headers()),
      onSuccess: (String body) => StepsData.fromJson(jsonDecode(body)));

  static Future<void> setSteps(StepsData stepsData) async => await _request(
      query: () => http.put(_url('steps'),
          headers: _headers(), body: jsonEncode(stepsData)),
      onSuccess: (_) => {});

  static Future<IdentityData> getIdentity() async => await _request(
      query: () => http.get(_url('identity'), headers: _headers()),
      onSuccess: (String body) => IdentityData.fromJson(jsonDecode(body)));

  static Future<void> setIdentity(IdentityData identityData) async =>
      await _request(
          query: () => http.put(_url('identity'),
              headers: _headers(), body: jsonEncode(identityData)),
          onSuccess: (_) => {});

  static Future<MatchData> search() async => await _request(
      query: () => http.get(_url('search'), headers: _headers()),
      onSuccess: (String body) => MatchData.fromJson(jsonDecode(body)));

  static Future<void> addRelations(RelationsData relationsData) async =>
      await _request(
          query: () => http.patch(_url('relations/add'),
              headers: _headers(), body: jsonEncode(relationsData)),
          onSuccess: (_) => {});

  static Future<void> removeRelations(RelationsData relationsData) async =>
      await _request(
          query: () => http.patch(_url('relations/remove'),
              headers: _headers(), body: jsonEncode(relationsData)),
          onSuccess: (_) => {});
}
