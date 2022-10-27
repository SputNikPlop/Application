import 'dart:convert';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

@pragma('vm:entry-point')
Future<void> _show({
  required int id,
  required String channelId,
  required String channelName,
  String? image,
  String? title,
  String? body,
  bool requestPermission = false,
}) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(image ?? 'ic_stat_notifications');

  await flutterLocalNotificationsPlugin.initialize(
    InitializationSettings(android: initializationSettingsAndroid),
  );

  if (requestPermission) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  await flutterLocalNotificationsPlugin.show(
    id,
    title,
    body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
      ),
    ),
  );
}

@pragma('vm:entry-point')
Future<void> onBackgroundAlarm({bool notification = true}) async {
  final NotificationsMapper notificationsMapper = NotificationsMapper();
  final List<String> checkedUuids = await notificationsMapper.getCheckedUuids();
  final String lastCheck = await notificationsMapper.getLastCheck();

  final WebSocketChannel channel = WebSocketChannel.connect(
    Uri.parse('wss://beta-api.ziedelth.fr/notifications'),
  );
  channel.sink.add('fr;$lastCheck');
  final String response = await channel.stream.first;
  await channel.sink.close();

  final List<Map<String, dynamic>> data =
      List<Map<String, dynamic>>.from(jsonDecode(response));

  final List<String> uuids = data
      .map((Map<String, dynamic> element) => element['uuid'] as String)
      .toList();
  final String animes = data
      .where(
        (Map<String, dynamic> element) =>
            !checkedUuids.contains(element['uuid']),
      )
      .map((Map<String, dynamic> element) => element['name'])
      .join(', ');

  if (animes.isNotEmpty && notification) {
    await _show(
      id: 0,
      channelId: 'notifications',
      channelName: 'Notifications',
      body: animes,
    );
  }

  await notificationsMapper.setLastCheck();
  await notificationsMapper.setCheckedUuids(uuids);
}

class NotificationsMapper {
  final String _lastCheckKey = 'lastCheck';

  String getCurrentTime() {
    final String currentTime = DateTime.now().toUtc().toIso8601String();

    if (!currentTime.contains('.')) {
      return currentTime;
    }

    return '${currentTime.split('.')[0]}Z';
  }

  Future<List<String>> getCheckedUuids() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('checkedUuids') ?? <String>[];
  }

  Future<void> setCheckedUuids(List<String> uuids) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('checkedUuids', uuids);
  }

  Future<String> getLastCheck() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastCheckKey) ?? getCurrentTime();
  }

  Future<void> setLastCheck() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastCheckKey, getCurrentTime());
  }

  Future<bool> setAlarm() async {
    final bool response = await AndroidAlarmManager.initialize();

    if (!response) {
      return false;
    }

    final bool set = await AndroidAlarmManager.periodic(
      const Duration(minutes: 1),
      0,
      onBackgroundAlarm,
      allowWhileIdle: true,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );

    return set;
  }
}
