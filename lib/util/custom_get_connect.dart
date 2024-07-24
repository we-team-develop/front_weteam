import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// API요청시 도움을 주는 클래스입니다.
/// 기본적으로 firebase token을 header에 삽입합니다.
/// 필요한 경우 오류와 api요청 정보를 로그에 남깁니다.
class CustomGetConnect extends GetConnect {
  /// API 요청에 대한 정보를 로깅합니다.
  ///
  /// * 디버그 상태일 때만 출력합니다

  Future<void> _printResponseInfo(Response rp) async {
    // 출력을 원하지 않는 경우 아래 변수의 값을 false로 변경하세요.
    bool enabled = true;
    bool logOnlyError = false;
    bool hideResponse = true;
    // 디버그 상태 체크
    if (!kDebugMode || !enabled) {
      return;
    }
    // ignore: dead_code
    if (logOnlyError && rp.isOk) {
      return;
    }

    String? url = rp.request?.url.toString(); // 요청 url
    Map? requestHeader = {};
    requestHeader.addAll(rp.request?.headers ?? {}); // 요청 헤더

    // 요청 헤더에 토큰이 있다면 생략시킵니다. (스팸 방지)
    String? authorization = requestHeader['Authorization'];
    if (authorization != null && authorization.length > 10) {
      requestHeader['Authorization'] =
          "${(authorization).substring(0, 10)}...(생략됨)";
    }

    int? statusCode = rp.statusCode; // 응답 코드
    String? bodyString = rp.bodyString; // 응답 bodyString
    bool isOk = rp.isOk;
    String? method = rp.request?.method;

    if (hideResponse) {
      bodyString = "(숨겨짐)";
    }

    log("=========== ($method) $url ===========\n요청 헤더: $requestHeader\n\n응답 코드 : $statusCode (${isOk ? '성공' : '오류'})\n응답 내용 : $bodyString\n\n=========== END OF API 요청 정보 ===========",
        name: 'API 요청 정보', time: DateTime.now());
  }

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

    Response<T> rp = await super.get<T>(
      url,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
    );

    _printResponseInfo(rp);
    return rp;
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

    Response<T> rp = await super.post<T>(
      url,
      body,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
      uploadProgress: uploadProgress,
    );

    _printResponseInfo(rp);
    return rp;
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

    Response<T> rp = await super.delete(
      url,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
    );

    _printResponseInfo(rp);
    return rp;
  }

  @override
  Future<Response<T>> patch<T>(
    String url,
    dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
    Progress? uploadProgress,
  }) async {
    headers = await putTokenToHeaders(headers);

    Response<T> rp = await httpClient.patch<T>(
      url,
      body: body,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
      uploadProgress: uploadProgress,
    );

    _printResponseInfo(rp);
    return rp;
  }
}
