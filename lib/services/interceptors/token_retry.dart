import 'package:http_interceptor/http_interceptor.dart';

class ExpiredTokenRetryPolicy extends RetryPolicy {
  @override
  int get maxRetryAttempts => 5;

  // @override
  // bool shouldAttemptRetryOnException(Exception reason) {
  //   print(reason);

  //   return false;
  // }

  @override
  Future<bool> shouldAttemptRetryOnResponse(BaseResponse response) async {
    if (response.statusCode == 401) {
      return true;
    }

    return false;
  }
}
