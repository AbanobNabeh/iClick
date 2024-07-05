import 'package:permission_handler/permission_handler.dart';

class PermissionApp {
  static void storageperm(fun) {
    Permission.storage.request().then((status) {
      if (status.isPermanentlyDenied) {
        openAppSettings();
      } else if (status.isGranted) {
        fun;
      }
    });
  }

  static void notificationper() {
    Permission.notification.request().then((status) {
      if (status.isPermanentlyDenied) {
        openAppSettings();
      } else if (status.isGranted) {
        print(status);
      }
    });
  }
}
