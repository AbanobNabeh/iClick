import 'package:flutter/material.dart';

class ContextUtility {
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'ContextUtilityNavigatorKey');
  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  static bool get hasNavigator => navigatorKey.currentState != null;
  static NavigatorState? get navigator => navigatorKey.currentState;

  static bool get hasContext => navigator?.overlay?.context != null;
  static BuildContext? get context => navigator?.overlay?.context;
}
