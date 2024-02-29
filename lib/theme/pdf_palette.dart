import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfPalette {

final headerLarge = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
);

final headerMedium = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

final headerSmall = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
);

final containerDecoration = BoxDecoration(
  border: Border.all(
    color: PdfColors.black,
    width: 1.0,
  ),
);

}