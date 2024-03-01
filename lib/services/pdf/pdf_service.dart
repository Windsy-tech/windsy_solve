import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:windsy_solve/utils/date_time_utils.dart';

abstract class PDFService {
  Widget footer() {
    return Footer(
      leading: Text(
        "Auto-generated report from Windsy Solve",
        style: TextStyle(
          font: Font.times(),
          fontSize: 6,
        ),
      ),
      title: Text(
        "All Rights Reserved © Company Confidential",
        style: TextStyle(
          font: Font.times(),
          fontSize: 6,
        ),
      ),
      trailing: Text(
        "Protective note DIN ISO 16016:2016",
        style: TextStyle(
          font: Font.times(),
          fontSize: 6,
        ),
      ),
    );
  }

  Widget header(String id, Uint8List logo) {
    return Header(
      level: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image(
            MemoryImage(logo),
            width: 100,
          ),
          Text(
            "Inspection Report",
            style: TextStyle(
              color: PdfColors.red,
              font: Font.timesBold(),
              fontSize: 14,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Doc No.: $id",
                style: const TextStyle(fontSize: 6),
              ),
              Text(
                "Revision No.: 001",
                style: const TextStyle(fontSize: 6),
              ),
              Text(
                DateTime.now().toDateTimeString(),
                style: const TextStyle(fontSize: 6),
              ),
              Text(
                "Auto-generated report",
                style: const TextStyle(fontSize: 6),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<ByteData> getFileData(String path) async {
    return await rootBundle.load(path);
  }
}
