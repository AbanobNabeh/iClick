import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:iclick/app.dart';
import 'package:iclick/config/network/dioapp.dart';
import 'package:iclick/config/network/dionotification.dart';
import 'package:iclick/config/services/context_utility.dart';
import 'package:iclick/core/blocobserve/blocobserve.dart';
import 'package:iclick/firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'config/shared preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UniLinksService.init();
  await CacheHelper.init();
  await DioApp.init();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  APInotification.initNotification();
  tz.initializeTimeZones();
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}
