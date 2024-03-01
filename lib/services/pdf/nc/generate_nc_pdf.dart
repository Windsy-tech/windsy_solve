import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:windsy_solve/core/constants/constants.dart';
import 'package:windsy_solve/services/pdf/pdf_service.dart';
import 'package:windsy_solve/models/nc/nc_model.dart';
import 'package:windsy_solve/utils/date_time_utils.dart';

class GenerateNCPDF extends PDFService {
  Future<File> createPDF({
    required String id,
    required NCModel nc,
    required String fileName,
  }) async {
    ByteData? image = await getFileData(Constants.pPdfLogo);
    Uint8List logo = image.buffer.asUint8List();

    final pdf = Document();
    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const EdgeInsets.all(20.0),
        footer: (context) => footer(),
        header: (context) => header(nc.id, logo),
        build: (Context context) {
          return <Widget>[
            _showNCID(nc),
            SizedBox(height: 2.0),
            _showNCTitle(context, nc),
            SizedBox(height: 2.0),
            //_showWindPark(nc),
            SizedBox(height: 2.0),
            _showDescription(nc),
            SizedBox(height: 2.0),
            //_showImages(),
          ];
        },
      ),
    );
    final output = await getExternalStorageDirectory();
    final file = File('${output!.path}/$fileName.pdf');
    return await file.writeAsBytes(await pdf.save());
  }

  _showNCID(NCModel nc) {
    PdfColor? textColor = PdfColor.fromHex("#474747");
    PdfColor? bgColor = PdfColors.grey200;
    PdfColor? headingTextColor = PdfColor.fromHex("#000000");

    return Container(
      width: double.infinity,
      //height: 20,
      decoration: BoxDecoration(
        color: bgColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "#ID: ${nc.id}",
                  style: TextStyle(
                    color: headingTextColor,
                    font: Font.timesBold(),
                    fontSize: 14,
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        "Type: Quality",
                        style: TextStyle(
                          color: textColor,
                          font: Font.timesBold(),
                          fontSize: 8,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        "Status: ${nc.status}",
                        style: TextStyle(
                          color: textColor,
                          font: Font.timesBold(),
                          fontSize: 8,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        "Severity: ${nc.severity}",
                        style: TextStyle(
                          color: textColor,
                          font: Font.timesBold(),
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ],
                ),
                /*pw.Text(
              "Reported Date: ${data[0]['CREATED_DATE']}",
              style: pw.TextStyle(
                color: textColor,
                font: pw.Font.timesBold(),
                fontSize: 8,
              ),
            ),*/
              ],
            ),
            SizedBox(height: 4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reported Date: ${nc.createdAt.toDateTimeString()}',
                  style: TextStyle(
                    color: textColor,
                    font: Font.timesBold(),
                    fontSize: 8,
                  ),
                ),
                Text(
                  'Reported By: ${nc.createdBy}',
                  style: TextStyle(
                    color: textColor,
                    font: Font.timesBold(),
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _showNCTitle(Context context, NCModel nc) {
    PdfColor? textColor = PdfColor.fromHex("#474747");
    PdfColor? bgColor = PdfColors.grey200;
    PdfColor? headingTextColor = PdfColor.fromHex("#000000");

    return Container(
      //height: 50,
      color: bgColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Title",
                    style: TextStyle(
                      color: headingTextColor,
                      font: Font.timesBold(),
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    nc.title,
                    style: TextStyle(
                      color: textColor,
                      font: Font.timesBold(),
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //_showWindPark(NCModel nc) {}

  _showDescription(NCModel nc) {
    PdfColor? textColor = PdfColor.fromHex("#474747");
    PdfColor? bgColor = PdfColors.grey200;
    PdfColor? headingTextColor = PdfColor.fromHex("#000000");
    return Container(
      width: double.infinity,
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Text(
                "Description",
                style: TextStyle(
                  color: headingTextColor,
                  font: Font.timesBold(),
                  fontSize: 10,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Text(
                nc.problemDescription.replaceAll("\n", " "),
                style: TextStyle(
                  color: textColor,
                  font: Font.timesBold(),
                  fontSize: 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
