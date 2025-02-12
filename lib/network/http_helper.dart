import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:weather_project/network/exception.dart';
import 'package:weather_project/network/header.dart';
import 'package:weather_project/network/remote_data_provider.dart';

class HttpHelper {
  final Dio _dio = RemoteDataProvider().dio;

  Future<dynamic> _responseData(
      Response response, {
        bool isRefresh = false,
      }) async {
    try {
      switch (response.statusCode) {
      // 200
        case HttpStatus.ok:
          return response;
      // 201
        case HttpStatus.created:
          return response;
      // 204
        case HttpStatus.noContent:
          break;
      // 400
        case HttpStatus.badRequest:
          throw BadRequestException(
            response.requestOptions.path,
            jsonDecode(jsonEncode(response.data)),
            response.data['error'],
            response.data['message'],
          );
      // 401
        case HttpStatus.unauthorized:
          throw UnauthorizedException(
              response.requestOptions.path,
              response.data['error'] ?? 'Unauthorized',
              response.data['message']);
        case HttpStatus.forbidden:
          throw ForbiddenException(
            response.requestOptions.path,
            response.data['error'] ?? 'Forbidden',
            response.data['message'],
          );
      // 404
        case HttpStatus.notFound:
          throw NotFoundException(
            response.requestOptions.path,
            response.data['error'] ?? 'This Uri Not Founded',
            response.data['message'],
          );
      // 422
        case HttpStatus.unprocessableEntity:
          throw UnprocessableEntityException(
            response.requestOptions.path,
            jsonDecode(jsonEncode(response.data)),
            response.data['error'],
            response.data['message'],
          );
      // 429
        case HttpStatus.tooManyRequests:
          throw TooManyRequestException(
            response.requestOptions.path,
            response.data is Map
                ? (response.data?['error'] ?? 'too many requests')
                : 'too many requests',
            response.data is Map
                ? (response.data?['message'] ?? 'too many requests')
                : 'too many requests',
          );
      // 500
        case HttpStatus.internalServerError:
          throw ServerException(
            response.requestOptions.path,
            response.data is Map
                ? (response.data?['error'] ?? 'Server Error')
                : 'Server Error',
            response.data is Map
                ? (response.data?['message'] ?? 'Server Error')
                : 'Server Error',
          );
      // 503
        case HttpStatus.serviceUnavailable:
          throw ServiceUnavailableException(
            response.requestOptions.path,
            response.data?['error'] ?? 'Service Unavailable',
            response.data?['message'] ?? 'Service Unavailable',
          );
      // 502
        case HttpStatus.badGateway:
          throw BadGatewayException(
            response.requestOptions.path,
            response.data is Map
                ? (response.data?['error'] ?? 'Bad Gateway')
                : 'Bad Gateway',
            response.data is Map
                ? (response.data?['message'] ?? 'Bad Gateway')
                : 'Bad Gateway',
          );
      // Others
        default:
          throw NotHandleException(
            response.requestOptions.path,
            response.data?['error'],
            response.data?['message'],
          );
      }
    } on JsonUnsupportedObjectError {
      throw ServerException(
        response.requestOptions.path,
        response.data?['error'],
        response.data?['message'],
      );
    } on FormatException {
      throw ServerException(
        response.requestOptions.path,
        response.data?['error'],
        response.data?['message'],
      );
    }
  }

  Future<dynamic> httpGet(
      String method, {
        Map<String, dynamic>? queryParameters,
        HttpHeaderType headerType = HttpHeaderType.authenticated,
        Map<String, dynamic>? anotherHeaders,
        int? sendTimeout,
        int? receiveTimeout,
        String? baseUrl,
        bool shouldSendToken = true,
      }) async {
    try {
      if (baseUrl != null) {
        _dio.options = _dio.options.copyWith(
          baseUrl: baseUrl,
        );
      }
      return _responseData(await _dio.get(
        '/$method',
        queryParameters: queryParameters,
        options: Options(
          headers: HttpHeader.setHeaders(
            headerType,
            anotherHeaders: anotherHeaders,
            shouldSendToken: shouldSendToken,
          ),
          //TOF
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
        ),
      ).whenComplete(() {
        _dio.options = _dio.options.copyWith(
          baseUrl: RemoteDataProvider().baseUrl,
        );
      }));
    } on DioException catch (e) {
      return _responseData(e.response!);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> httpPost(
      String method, {
        required dynamic data,
        String? baseURl,
        bool isRefresh = false,
        HttpHeaderType headerType = HttpHeaderType.authenticated,
        void Function(int, int)? onSendProgress,
        void Function(int, int)? onReceiveProgress,
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? anotherHeaders,
      }) async {
    try {
      if (baseURl != null) {
        _dio.options = _dio.options.copyWith(
          baseUrl: baseURl,
        );
      }
      return _responseData(
          await _dio
              .post(
            '/$method',
            data: data,
            queryParameters: queryParameters,
            options: Options(
              headers: HttpHeader.setHeaders(
                headerType,
                anotherHeaders: anotherHeaders,
              ),
              followRedirects: true,
            ),
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          )
              .whenComplete(() {
            _dio.options = _dio.options.copyWith(
              baseUrl: RemoteDataProvider().baseUrl,
            );
          }),
          isRefresh: isRefresh);
    } on DioException catch (e) {
      log(e.toString());
      return _responseData(
          e.response ?? Response(requestOptions: RequestOptions()),
          isRefresh: isRefresh);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> httpPut(
      String method, {
        required dynamic data,
        HttpHeaderType headerType = HttpHeaderType.authenticated,
        Map<String, dynamic>? anotherHeaders,
      }) async {
    try {
      return _responseData(await _dio.put(
        '/$method',
        data: data,
        options: Options(
          headers: HttpHeader.setHeaders(
            headerType,
            anotherHeaders: anotherHeaders,
          ),
        ),
      ));
    } on DioException catch (e) {
      return _responseData(e.response!);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> httpDelete(
      String method, {
        required dynamic data,
        Map<String, dynamic>? queryParameters,
        HttpHeaderType headerType = HttpHeaderType.authenticated,
        Map<String, dynamic>? anotherHeaders,
      }) async {
    try {
      return _responseData(await _dio.delete(
        '/$method',
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: HttpHeader.setHeaders(
            headerType,
            anotherHeaders: anotherHeaders,
          ),
        ),
      ));
    } on DioException catch (e) {
      return _responseData(e.response!);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<dynamic> httpPatch(
      String method, {
        Map<String, dynamic>? queryParameters,
        HttpHeaderType headerType = HttpHeaderType.authenticated,
        required dynamic data,
      }) async {
    try {
      return _responseData(await _dio.patch(
        '/$method',
        data: data,
        options: Options(
          headers: HttpHeader.setHeaders(headerType),
        ),
      ));
    } on SocketException catch (e) {
      throw SocketException(e.url, e.error);
    } on JsonUnsupportedObjectError catch (e) {
      throw JsonUnsupportedObjectError(e);
    }
  }
}
