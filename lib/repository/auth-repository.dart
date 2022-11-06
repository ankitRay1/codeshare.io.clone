import 'dart:convert';

import 'package:codeshareclone/models/user.dart';
import 'package:codeshareclone/repository/local-storage-repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

import '../constant.dart';
import '../models/api_response_data.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    client: Client(),
    googleSignIn: GoogleSignIn(),
    localStorageRepository: LocalStorageRepository()));

final userStateProvider = StateProvider<User?>((ref) => null);

class AuthRepository {
  final Client _client;
  final GoogleSignIn _googleSignIn;
  final LocalStorageRepository _localStorageRepository;

  AuthRepository(
      {required Client client,
      required GoogleSignIn googleSignIn,
      required LocalStorageRepository localStorageRepository})
      : _client = client,
        _googleSignIn = googleSignIn,
        _localStorageRepository = localStorageRepository;

  Future<ApiResponseData> signInWithGoogle() async {
    ApiResponseData apiResponseData =
        ApiResponseData(message: '', responseData: '');

    try {
      final user = await _googleSignIn.signIn();

      print(user?.email ?? 'sdff');

      if (user != null) {
        final userData = User(
            name: user.displayName ?? '',
            email: user.email,
            profilePic: user.photoUrl ?? '',
            uid: '',
            token: '');

        var response =
            await _client.post(Uri.parse('${Constant.hostname}/api/signin'),
                headers: {
                  "Content-Type": "application/json; charset=UTF-8",
                  "Access-Control-Allow-Origin": "*"
                },
                body: userData.toJson());

        final responseData = jsonDecode(response.body);

        switch (response.statusCode) {
          case 200:
            apiResponseData = ApiResponseData(
                message: responseData["message"],
                responseData: userData.copyWith(
                    uid: responseData['data']["user"]["_id"],
                    token: responseData["data"]["token"]));

            _localStorageRepository.setTokenToStorage(
                token: responseData["data"]["token"]);
            return apiResponseData;
          default:
            apiResponseData = ApiResponseData(
                message: responseData["message"], responseData: null);
        }
      }
    } catch (e) {
      apiResponseData =
          ApiResponseData(message: e.toString(), responseData: null);
    }

    return apiResponseData;
  }

  Future<ApiResponseData> getUserData() async {
    ApiResponseData apiResponseData =
        ApiResponseData(message: '', responseData: null);

    try {
      String? token = await _localStorageRepository.getTokenFromLocalStorage();

      if (token != null) {
        var response = await _client.get(
          Uri.parse('${Constant.hostname}/api/getuser'),
          headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Access-Control-Allow-Origin": "*",
            'x-auth-token': token,
          },
        );

        final responseData = jsonDecode(response.body);

        switch (response.statusCode) {
          case 200:
            final user = User.fromMap(responseData['data']['user']);

            apiResponseData = ApiResponseData(
                message: responseData["message"],
                responseData: user.copyWith(token: token));

            return apiResponseData;
          default:
            apiResponseData = ApiResponseData(
                message: responseData["message"], responseData: null);
        }
      } else {
        apiResponseData = ApiResponseData(
            message: 'You session have been expired , Please login again',
            responseData: null);
      }
    } catch (e) {
      apiResponseData =
          ApiResponseData(message: e.toString(), responseData: null);
    }
    return apiResponseData;
  }
}
