import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:iclick/core/componennts/app_components.dart';
import 'package:iclick/core/utils/app_colors.dart';
import 'package:iclick/core/utils/icon_broken.dart';
import 'package:iclick/core/utils/my_flutter_app_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class PDFviewScreen extends StatefulWidget {
  Map document;
  PDFviewScreen(this.document);
  @override
  State<PDFviewScreen> createState() => _PDFviewScreenState(document);
}

class _PDFviewScreenState extends State<PDFviewScreen> {
  Map document;
  _PDFviewScreenState(this.document);
  PDFViewController? controller;
  int startpage = 0;
  int maxpage = 0;
  Future<void> download(String url) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final basestorage = await getExternalStorageDirectory();
      try {
        await FlutterDownloader.enqueue(
          url: url,
          savedDir: basestorage!.path,
          fileName: document['name'],
        );
      } catch (e) {
        print("error message = ${e.toString()}");
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Components.defText(text: document['name']),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Center(
              child: Components.defText(text: "$startpage/$maxpage", size: 12),
            ),
          )
        ],
      ),
      body: PDF(
        onPageChanged: (page, total) {
          setState(() {
            startpage = page! + 1;
            maxpage = total!;
          });
        },
        onViewCreated: (controller) {
          print("object ${controller.getCurrentPage()}");
        },
        onRender: (pages) {
          print("object 2 $pages");
        },
        onError: (error) {
          print(error.toString());
        },
        onPageError: (page, error) {
          print('$page: ${error.toString()}');
        },
      ).cachedFromUrl(
          placeholder: (progress) => Center(child: Text('$progress %')),
          errorWidget: (error) => Center(child: Text(error.toString())),
          "${document['link']}"),
      floatingActionButton: FloatingActionButton(
        onPressed: () => download(document['link']!),
        backgroundColor: AppColors.primary,
        child: Icon(
          MyFlutterApp.download,
          color: AppColors.white,
        ),
      ),
    );
  }
}
