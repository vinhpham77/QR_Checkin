import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';

const real = 'http://192.168.153.55:8888/api';
const simulator = 'http://10.0.2.2:8888/api';

final dio = Dio(
  BaseOptions(
    baseUrl: real,
  ),
);

Future<void> setDeviceInfo(Dio dio) async {
  String deviceName = await getDeviceName();
  String deviceId = await getDeviceId();

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      options.headers['device-id'] = deviceId;
      options.headers['device-name'] = deviceName;
      return handler.next(options);
    },
  ));
}

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
