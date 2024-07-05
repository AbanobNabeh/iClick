import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iclick/config/services/contect_utility.dart';
import 'package:iclick/features/home/presentation/pages/postview.dart';
import 'package:iclick/features/profile/presentation/pages/profleuser.dart';
import 'package:iclick/features/reels/presentation/pages/rellview.dart';
import 'package:uni_links/uni_links.dart';

class UniLinksService {
  static Future<void> init({checkActualVersion = false}) async {
    try {
      final Uri? uri = await getInitialUri();
      _uniLinkHandler(uri: uri);
    } on PlatformException {
      if (kDebugMode)
        print("(PlatformException) Failed to receive initial uri.");
    } on FormatException catch (error) {
      if (kDebugMode)
        print(
            "(FormatException) Malformed Initial URI received. Error: $error");
    }

    // This is used for cases when: APP is already running and the user clicks on a link.
    uriLinkStream.listen((Uri? uri) async {
      _uniLinkHandler(uri: uri);
    }, onError: (error) {
      if (kDebugMode) print('UniLinks onUriLink error: $error');
    });
  }

  static Future<void> _uniLinkHandler({required Uri? uri}) async {
    if (uri!.queryParameters['post'] != null) {
      ContextUtility.navigator?.push(
        MaterialPageRoute(
            builder: (_) => PostView(int.parse(uri.queryParameters['post']!))),
      );
    } else if (uri.queryParameters['reel'] != null) {
      ContextUtility.navigator?.push(
        MaterialPageRoute(
            builder: (_) =>
                ReelViewScreen(int.parse(uri.queryParameters['reel']!))),
      );
    } else if (uri.queryParameters['profile'] != null) {
      ContextUtility.navigator?.push(
        MaterialPageRoute(
            builder: (_) =>
                ProfileUserScreen(int.parse(uri.queryParameters['profile']!))),
      );
    }
  }
}
