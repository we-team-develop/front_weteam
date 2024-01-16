import 'package:get/get.dart';

import '../service/auth_service.dart';

class CustomGetConnect extends GetConnect {
  @override
  Future<Response<T>> get<T>(
      String url, {
        Map<String, String>? headers,
        String? contentType,
        Map<String, dynamic>? query,
        Decoder<T>? decoder,
      }) {

    headers ??= {};
    if (!headers.containsKey('Authorization')) {
      headers['Authorization'] = 'Bearer ${Get.find<AuthService>().token}';
    }

    return super.get<T>(
      url,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,

    );
  }

  @override
  Future<Response<T>> post<T>(
      String? url,
      dynamic body, {
        String? contentType,
        Map<String, String>? headers,
        Map<String, dynamic>? query,
        Decoder<T>? decoder,
        Progress? uploadProgress,
      }) {

    headers ??= {};
    if (!headers.containsKey('Authorization')) {
      headers['Authorization'] = 'Bearer ${Get.find<AuthService>().token}';
    }

    return super.post<T>(
      url,
      body,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
      uploadProgress: uploadProgress,
    );
  }

  @override
  Future<Response<T>> delete<T>(
      String url, {
        Map<String, String>? headers,
        String? contentType,
        Map<String, dynamic>? query,
        Decoder<T>? decoder,
      }) {

    headers ??= {};
    if (!headers.containsKey('Authorization')) {
      headers['Authorization'] = 'Bearer ${Get.find<AuthService>().token}';
    }

    return super.delete(
      url,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
    );
  }
}