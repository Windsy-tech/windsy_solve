import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

class ShareService {
  Future<void> shareFile(String url) async {
    final output = await getExternalStorageDirectory();
    File file = File('${output!.path}/kiel3.pdf');
    XFile newFile = XFile(file.path);
    /*     final bytes = await rootBundle.load('${output!.path}/dirk.pdf');
    XFile file = XFile.fromData(bytes.buffer.asUint8List());  */

    await Share.shareXFiles([newFile], text: 'Great document');
  }

  Future<XFile> getImageXFileByUrl(String url) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    Uri uri = Uri.parse(url);
    final response = await http.get(uri);
    String fileName = "i";
    File fileWrite = File("$tempPath/$fileName");

    fileWrite.writeAsBytesSync(response.bodyBytes);
    final mimeType =
        lookupMimeType("$tempPath/$fileName", headerBytes: [0xFF, 0xD8]);
    final type = mimeType!.split("/");
    final file = XFile("$tempPath/$fileName", mimeType: mimeType);
    return file;
  }
}
