import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:weather_project/utils/loggger_helper.dart';

Stopwatch? _stopwatch;

class RemoteDataProvider {
  late Dio dio;

  static final RemoteDataProvider _singleton = RemoteDataProvider._internal();

  RemoteDataProvider._internal() {
    dio = createDio();
  }

  factory RemoteDataProvider() {
    return _singleton;
  }

  static const JsonEncoder jsonEncoder = JsonEncoder.withIndent('  ');
  static const JsonDecoder jsonDecoder = JsonDecoder();

  Dio createDio() {
    const timeOutInMilliSeconds = 30000;
    Dio dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(milliseconds: timeOutInMilliSeconds),
        receiveTimeout: const Duration(milliseconds: timeOutInMilliSeconds),
        baseUrl: baseUrl,
      ),
    );
    // if (isDev) {
    return dioWithInterceptors(dio);
    // }
    // return dio;
  }
  //TOF
  // String get baseUrl => publicPrefs.get('baseUrl')=="stage"?"https://api.wms.stage.miladbazar.com":"https://api.wms.miladbazar.com";
  // String get baseUrl => "https://api.wms.stage.miladbazar.com";
  String get baseUrl => "https://api.wms.miladbazar.com";
  // String get baseUrl => AppEnvironment.baseApiUrl;
  Dio dioWithInterceptors(Dio dio) {
    dio.interceptors.clear();
    if (!kReleaseMode) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest:
              (RequestOptions options, RequestInterceptorHandler handler) =>
              requestInterceptor(options, handler),
          onResponse: (Response response, ResponseInterceptorHandler handler) =>
              responseInterceptor(response, handler),
          onError: (DioError dioError, ErrorInterceptorHandler handler) =>
              errorInterceptor(dioError, handler),
        ),
      );
      // dio.interceptors.add(
      //   PrettyDioLogger(
      //     request: true,
      //     requestHeader: true,
      //     requestBody: true,
      //     responseBody: true,
      //     maxWidth: 100,
      //   ),
      // );
    }
    // dio.interceptors.add(DioFirebasePerformanceInterceptor());
    return dio;
  }

  static const _exceptionApiPathsToNotLog = [
    'country-codes',
  ];

  dynamic requestInterceptor(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    if (_exceptionApiPathsToNotLog.any((e) => options.path.endsWith(e))) {
      return handler.next(options);
    }
    if (kDebugMode) {
      String res = '';
      res +=
      '╔${options.method.toUpperCase()} ${(options.baseUrl) + (options.path)}\n';
      res += '║ Request Headers:\n';
      options.headers.forEach((k, v) => res += '║ $k: $v\n');
      if (options.queryParameters.isNotEmpty) {
        res += "║ queryParameters:\n";
        options.queryParameters.forEach((k, v) {
          res += '║ $k: $v\n';
        });
      }
      if (options.data != null) {
        res += _prettyPrintJson('Request Body: ', options.data);
      }
      ColorfulLogger.printCustom(
        res,
        color: LogColor.white,
      );
    }
    return handler.next(options);
  }

  String _prettyPrintJson(String prefix, dynamic data) {
    late String res;
    try {
      final decoded = jsonDecoder.convert(json.encode(data));
      final prettyString = jsonEncoder.convert(decoded);
      res = prefix + prettyString;
    } catch (_) {
      try {
        res = prefix + json.encode(data);
      } catch (_) {
        res = prefix + data.toString();
      }
    }
    return res;
  }

  dynamic responseInterceptor(
      Response response,
      ResponseInterceptorHandler handler,
      ) async {
    if (_exceptionApiPathsToNotLog
        .any((e) => response.requestOptions.path.endsWith(e))) {
      return handler.next(response);
    }
    String res = '';
    if (kDebugMode) {
      res +=
      "\n<-- ${response.statusCode} ${response.requestOptions.method} ${(response.requestOptions.baseUrl + response.requestOptions.path)}";
      res += _prettyPrintJson('\nResponse: ', response.data);
      if (!kReleaseMode) {
        res +=
        '\n\nresponse time: ${_stopwatch?.elapsed.inMilliseconds} milliseconds';
      }
      res += "╚";
      ColorfulLogger.printCustom(
        res,
        color: LogColor.green,
      );
    }
    return handler.next(response);
  }

  dynamic errorInterceptor(DioError dioError, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      String res = '';
      res +=
      "\n<-- ${dioError.message} ${dioError.requestOptions.method} ${(dioError.response?.requestOptions != null ? (dioError.response!.requestOptions.baseUrl + dioError.response!.requestOptions.path) : 'URL')}";
      res +=
      "\n${dioError.response != null ? dioError.response!.data : 'Unknown Error'}";
      if (!kReleaseMode) {
        res +=
        '\n\nresponse time: ${_stopwatch?.elapsed.inMilliseconds} milliseconds';
      }
      ColorfulLogger.printCustom(
        res,
        color: LogColor.red,
      );
    }
    return handler.next(dioError);
  }
}

class DioFirebasePerformanceInterceptor extends Interceptor {
  DioFirebasePerformanceInterceptor({
    this.requestContentLengthMethod = defaultRequestContentLength,
    this.responseContentLengthMethod = defaultResponseContentLength,
  });

  /// key: requestKey hash code, value: ongoing metric
  final _map = <int, HttpMetric>{};
  final RequestContentLengthMethod requestContentLengthMethod;
  final ResponseContentLengthMethod responseContentLengthMethod;

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final metric = FirebasePerformance.instance.newHttpMetric(
        options.uri.normalized(),
        options.method.asHttpMethod()!,
      );

      final requestKey = options.extra.hashCode;
      _map[requestKey] = metric;
      final requestContentLength = requestContentLengthMethod(options);
      await metric.start();
      if (requestContentLength != null) {
        metric.requestPayloadSize = requestContentLength;
      }
    } catch (_) {}
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    try {
      final requestKey = response.requestOptions.extra.hashCode;
      final metric = _map[requestKey];
      metric?.setResponse(response, responseContentLengthMethod);
      await metric?.stop();
      _map.remove(requestKey);
    } catch (_) {}
    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    try {
      final requestKey = err.requestOptions.extra.hashCode;
      final metric = _map[requestKey];
      metric?.setResponse(err.response, responseContentLengthMethod);
      await metric?.stop();
      _map.remove(requestKey);
    } catch (_) {}
    return super.onError(err, handler);
  }
}

typedef RequestContentLengthMethod = int? Function(RequestOptions options);

int? defaultRequestContentLength(RequestOptions options) {
  try {
    return options.headers.toString().length + options.data.toString().length;
  } catch (_) {
    return null;
  }
}

typedef ResponseContentLengthMethod = int? Function(Response options);

int? defaultResponseContentLength(Response response) {
  try {
    String? lengthHeader = response.headers[Headers.contentLengthHeader]?.first;
    int length = int.parse(lengthHeader ?? '-1');
    if (length <= 0) {
      int headers = response.headers.toString().length;
      length = headers + response.data.toString().length;
    }
    return length;
  } catch (_) {
    return null;
  }
}

extension _ResponseHttpMetric on HttpMetric {
  void setResponse(Response? value,
      ResponseContentLengthMethod responseContentLengthMethod) {
    if (value == null) {
      return;
    }
    final responseContentLength = responseContentLengthMethod(value);
    if (responseContentLength != null) {
      responsePayloadSize = responseContentLength;
    }
    final contentType = value.headers.value.call(Headers.contentTypeHeader);
    if (contentType != null) {
      responseContentType = contentType;
    }
    if (value.statusCode != null) {
      httpResponseCode = value.statusCode;
    }
  }
}

extension _UriHttpMethod on Uri {
  String normalized() {
    return "$scheme://$host$path";
  }
}

extension _StringHttpMethod on String {
  HttpMethod? asHttpMethod() {
    switch (toUpperCase()) {
      case 'POST':
        return HttpMethod.Post;
      case 'GET':
        return HttpMethod.Get;
      case 'DELETE':
        return HttpMethod.Delete;
      case 'PUT':
        return HttpMethod.Put;
      case 'PATCH':
        return HttpMethod.Patch;
      case 'OPTIONS':
        return HttpMethod.Options;
      default:
        return null;
    }
  }
}
