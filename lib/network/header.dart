
enum HttpHeaderType {
  authenticated,
  anonymous,
  testToken,
  multipart,
}

abstract class HttpHeader {
  static Map<String, String> setHeaders(
      HttpHeaderType headerType, {
        Map<String, dynamic>? anotherHeaders,
        bool setCustomHeaders = true,
        bool shouldSendToken = true,
      }) {
    //  String token= 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7ImlkIjo2LCJ1c2VybmFtZSI6InRlc3RpYW5udHd0Iiwicm9sZSI6ImVtcGxveWVlIiwiZW1haWwiOiJ0ZXNzQHRlc3R0LmNvbSIsIm5hbWUiOiJpbWFtIiwicGhvbmVfbnVtYmVyIjoiKzk4OTMxMTIzNDU2NyIsImNvbnRhY3RfaW5mbyI6ImFkZHJlc3MifSwidGltZXN0YW1wIjoxNzAxMDc3MjIyNTgzLCJpYXQiOjE3MDEwNzcyMjIsImV4cCI6MTcwMTE2MzYyMn0.qUwUSlpqehxdJUJ3eSmi6WTukRVhZV-Q82_gX4hDadE';
    Map<String, dynamic> headers;
    switch (headerType) {
      case HttpHeaderType.authenticated:
        headers = {
          'Authorization': "Bearer ",
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        };
        break;
      case HttpHeaderType.anonymous:
        headers = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        };
        break;
      case HttpHeaderType.testToken:
        headers = {
          // 'token': testToken,
          'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwdWJsaWMtYWNjZXNzLXRva2VuIjoidG9rZW4ifQ.M7W3vJUsDziPm4kzFpMkHz1XNbXSMTL7AovRfj6e-RI',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        };
      default:
        throw Exception('$headerType is not supported HttpHeaderType');
    }
    return {
      ...headers,
      ...?anotherHeaders,
    };
  }
}
