import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:windsy_solve/models/inspection/checklist_model.dart';
import 'package:windsy_solve/models/inspection/section_model.dart';
import 'package:windsy_solve/theme/pdf_palette.dart';
import 'package:windsy_solve/utils/text_utils.dart';

class GenerateSections {
  List<String> tableHeaders = [
    'System',
    'Checks',
    'Type',
    'Notes',
    'Risk',
  ];

  Widget sectionField(
    Context context,
    int index,
    SectionModel sectionModel,
    List<CheckListModel> checkLists,
  ) {
    final pallete = PdfPalette();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$index    ${TextUtils.capitalizeFirstLetter(sectionModel.sectionName)} - Inspection Summary and Findings',
          style: pallete.headerMedium,
        ),
        SizedBox(height: 10.0),
        Text('Summary of this section'),
        SizedBox(height: 10.0),
        _contentTable(context, checkLists),
        SizedBox(height: 16.0),
      ],
    );
  }

  Widget _contentTable(
    Context context,
    List<CheckListModel> checkLists,
  ) {
    return TableHelper.fromTextArray(
      border: TableBorder.all(),
      cellAlignment: Alignment.centerLeft,
      headerDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      headerHeight: 25,
      //cellHeight: 40,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.centerLeft,
        4: Alignment.centerLeft,
      },
      headerStyle: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
      cellStyle: const TextStyle(
        fontSize: 10,
      ),
      rowDecoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: .5,
          ),
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: List<List<dynamic>>.generate(
        checkLists.length,
        (row) => List<dynamic>.generate(
          tableHeaders.length,
          (col) {
            switch (col) {
              case 0:
                return checkLists[row].system;
              case 1:
                return checkLists[row].checks;
              case 2:
                return checkLists[row].type;
              case 3:
                return checkLists[row].notes;
              case 4:
                return _riskContainer(checkLists[row].risk);

              default:
                return '';
            }
          },
        ),
      ),
    );
  }

  Widget _riskContainer(int risk) {
    switch (risk) {
      case 0:
        return Container(width: 10, color: PdfColors.green);
      case 1:
        return Container(width: 10, color: PdfColors.yellow);
      case 2:
        return Container(width: 10, color: PdfColors.orange);
      case 3:
        return Container(width: 10, color: PdfColors.red);
      default:
        return Container(width: 10, color: PdfColors.white);
        
    }
  }
}
