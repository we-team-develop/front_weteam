import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CustomGetConnect extends GetConnect {
  Future<Map<String, String>?> putTokenToHeaders(
      Map<String, String>? headers) async {
    headers ??= {};
    if (!headers.containsKey('Authorization')) {
      headers['Authorization'] =
          'Bearer ${await FirebaseAuth.instance.currentUser?.getIdToken()}';
    }

    return headers;
  }

  @override
  Future<Response<T>> get<T>(
    String url, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
  }) async {
    headers = await putTokenToHeaders(headers);

    return await super.get<T>(
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
  }) async {
    headers = await putTokenToHeaders(headers);

    return await super.post<T>(
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
  }) async {
    headers = await putTokenToHeaders(headers);

    return await super.delete(
      url,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
    );
  }
}