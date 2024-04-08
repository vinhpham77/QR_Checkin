import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: 'http://10.0.2.2:8888/api',
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
  String deviceName;
  try {
    deviceName = (await DeviceInfoPlugin().androidInfo).device;
  } on Exception {
    deviceName = 'Unknown';
  }
  return deviceName;
}

Future<String> getDeviceId() async {
  String deviceId;
  try {
    deviceId = (await DeviceInfoPlugin().androidInfo).id;
  } on Exception {
    deviceId = 'Unknown';
  }
  return deviceId;
}
