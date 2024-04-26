import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:qr_checkin/config/router.dart';

import '../features/auth/data/auth_repository.dart';
import '../features/result_type.dart';

const real = 'http://192.168.1.10:8888/api';
const simulator = 'http://10.0.2.2:8888/api';

final dio = Dio(
  BaseOptions(
    baseUrl: simulator,
  ),
);

final servicePaths = {
  'auth': '/auth',
  'events': '/events',
  'categories': '/categories',
  'images': '/images',
  'users': '/users',
};

Future<String> getDeviceName() async {
  try {
    return (await DeviceInfoPlugin().androidInfo).model;
  } on Exception {
    return 'Unknown';
  }
}

Future<String> getDeviceId() async {
  try {
    return (await DeviceInfoPlugin().androidInfo).id;
  } on Exception {
    return 'Unknown';
  }
}

void addAccessTokenInterceptor(Dio dio, AuthRepository authRepository) async {
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final result = await authRepository.getAccessToken();
        String deviceId = await getDeviceId();
        String deviceName = await getDeviceName();

        options.headers['device-id'] = deviceId;
        options.headers['device-name'] = deviceName;

        if (result is Success) {
          result as Success<String>;
          options.headers['Authorization'] = 'Bearer ${result.data}';
          return handler.next(options);
        } else {
          router.push('/login');
        }
      },
      onError: (DioException error, ErrorInterceptorHandler handler) async {
        if (error.response?.statusCode == 412) {
          final result = await authRepository.refreshToken();
          if (result is Success) {
            final accessToken = await authRepository.getAccessToken();
            dio.options.headers['Authorization'] = 'Bearer $accessToken';
            return handler.resolve(
              await dio.request(
                error.requestOptions.path,
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
                onSendProgress: error.requestOptions.onSendProgress,
                onReceiveProgress: error.requestOptions.onReceiveProgress,
                cancelToken: error.requestOptions.cancelToken,
                options: convertToOptions(error.requestOptions),
              ),
            );
          } else {
            router.push('/login');
          }
        } if (error.response?.statusCode == 406) {
          router.push('/login');
        }

        return handler.next(error);
      },
    ),
  );
}

Options convertToOptions(RequestOptions requestOptions) {
  return Options(
    method: requestOptions.method,
    persistentConnection: requestOptions.persistentConnection,
    preserveHeaderCase: requestOptions.preserveHeaderCase,
    receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
    headers: requestOptions.headers,
    responseType: requestOptions.responseType,
    contentType: requestOptions.contentType,
    validateStatus: requestOptions.validateStatus,
    receiveTimeout: requestOptions.receiveTimeout,
    sendTimeout: requestOptions.sendTimeout,
    extra: requestOptions.extra,
    followRedirects: requestOptions.followRedirects,
    maxRedirects: requestOptions.maxRedirects,
    requestEncoder: requestOptions.requestEncoder,
    responseDecoder: requestOptions.responseDecoder,
    listFormat: requestOptions.listFormat,
  );
}
