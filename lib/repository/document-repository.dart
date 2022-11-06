import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../constant.dart';
import '../models/api_response_data.dart';
import '../models/document.dart';

final documentRepositoryProvider =
    Provider((ref) => DocumentRepository(client: Client()));

class DocumentRepository {
  final Client _client;

  DocumentRepository({
    required Client client,
  }) : _client = client;

  Future<ApiResponseData> createDocument() async {
    ApiResponseData apiResponseData =
        ApiResponseData(message: '', responseData: null);
    try {
      var response = await _client.post(
          Uri.parse('${Constant.hostname}/api/createDocument'),
          headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Access-Control-Allow-Origin": "*",
            // 'x-auth-token': token,
          },
          body: jsonEncode({
            'createdAt': DateTime.now().millisecondsSinceEpoch,
            'updatedAt': DateTime.now().millisecondsSinceEpoch,
          }));

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final documentData = Document.fromJson(jsonEncode(data['data']));

        apiResponseData = ApiResponseData(
            message: data["message"], responseData: documentData);

        return apiResponseData;
      }

      apiResponseData = ApiResponseData(
          message: jsonDecode(response.body)['message'], responseData: null);

      return apiResponseData;
    } catch (e) {
      apiResponseData =
          ApiResponseData(message: e.toString(), responseData: null);
    }

    return apiResponseData;
  }

  Future<ApiResponseData> fetchDocumentById(
      {required String documentId}) async {
    ApiResponseData apiResponseData =
        ApiResponseData(message: '', responseData: null);

    try {
      var response = await _client.get(
        Uri.parse('${Constant.hostname}/api/display/doc/$documentId'),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Access-Control-Allow-Origin": "*",
          // 'x-auth-token': token,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final documentData = Document.fromJson(jsonEncode(data['data']));

        apiResponseData = ApiResponseData(
            message: data["message"], responseData: documentData);

        return apiResponseData;
      }

      apiResponseData = ApiResponseData(
          message: 'This Document does not exist, please create a new one.',
          responseData: null);

      // return apiResponseData;

    } catch (e) {
      apiResponseData =
          ApiResponseData(message: e.toString(), responseData: null);
    }
    return apiResponseData;
  }
}
