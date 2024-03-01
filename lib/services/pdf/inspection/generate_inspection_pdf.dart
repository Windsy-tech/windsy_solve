import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:windsy_solve/core/constants/constants.dart';
import 'package:windsy_solve/services/pdf/pdf_service.dart';
import 'package:windsy_solve/services/pdf/inspection/generate_inspection_sections.dart';
import 'package:windsy_solve/models/common/user_model.dart';
import 'package:windsy_solve/models/inspection/checklist_model.dart';
import 'package:windsy_solve/models/inspection/inspection_model.dart';
import 'package:windsy_solve/models/inspection/section_model.dart';
import 'package:windsy_solve/theme/pdf_palette.dart';
import 'package:windsy_solve/utils/date_time_utils.dart';

class GenerateInspectionPDF extends PDFService {
  final GenerateSections _sections = GenerateSections();
  int index = 6;

  Future<Document> createPDF({
    required Document pdf,
    required String id,
    required UserModel user,
    required InspectionModel inspection,
    required String confidentialityLevel,
  }) async {
    ByteData? image = await getFileData(Constants.pPdfLogo);
    Uint8List logo = image.buffer.asUint8List();
    //Main Page
    pdf.addPage(
      Page(
        pageFormat: PdfPageFormat.a4,
        margin: const EdgeInsets.all(32.0),
        build: (context) => _mainPage(
          user,
          inspection,
          confidentialityLevel,
        ),
      ),
    );

    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (context) => header(inspection.id, logo),
        footer: (context) => footer(),
        margin: const EdgeInsets.all(32.0),
        build: (Context context) {
          return <Widget>[
            _tableOfContents(),
            SizedBox(height: 16.0),
            _goalPurposeScope(inspection),
            SizedBox(height: 16.0),
            _inspectionCriteria(),
            SizedBox(height: 16.0),
          ];
        },
      ),
    );
    return pdf;
  }

  Future<Document> addChecklists(
    Document pdf,
    SectionModel sectionModel,
    List<CheckListModel> checkLists,
  ) async {
    ByteData? image = await getFileData(Constants.pPdfLogo);
    Uint8List logo = image.buffer.asUint8List();
    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (context) => header(sectionModel.inspectionId, logo),
        footer: (context) => footer(),
        margin: const EdgeInsets.all(32.0),
        build: (Context context) {
          return <Widget>[
            _sections.sectionField(
              context,
              index++,
              sectionModel,
              checkLists,
            ),
          ];
        },
      ),
    );
    return pdf;
  }

  Future<File> generatePDF(String fileName, Document pdf) async {
    final output = await getExternalStorageDirectory();
    final file = File('${output!.path}/$fileName.pdf');
    return await file.writeAsBytes(await pdf.save());
  }

  Widget _mainPage(
    UserModel user,
    InspectionModel inspection,
    String confidentialityLevel,
  ) {
    final pallete = PdfPalette();
    return Container(
      width: double.infinity,
      decoration: pallete.containerDecoration,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: pallete.containerDecoration,
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      decoration: pallete.containerDecoration,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Company
                          Text(
                            'Company',
                            style: pallete.headerSmall,
                          ),
                          Text(
                            user.companyName,
                          ),

                          Spacer(),

                          //Internal Approval
                          Text(
                            'Created by:',
                            style: pallete.headerSmall,
                          ),
                          Text(inspection.createdBy),
                          SizedBox(height: 10),
                          Text(
                            'Checked by:',
                            style: pallete.headerSmall,
                          ),
                          Text(''),
                          SizedBox(height: 10),
                          Text(
                            'Approved by:',
                            style: pallete.headerSmall,
                          ),
                          Text(''),

                          SizedBox(height: 20),
                          Text(
                            'Date of release: ${DateTime.now().toDateString()}',
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      decoration: pallete.containerDecoration,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Confidentiality level:',
                            style: pallete.headerSmall,
                          ),
                          Text(confidentialityLevel),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: pallete.containerDecoration,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'INSPECTION REPORT',
                    style: pallete.headerLarge,
                  ),
                  Text(inspection.title, style: pallete.headerMedium),
                  SizedBox(height: 30),
                  Text(
                    'Wind Farm: ${inspection.windFarm}',
                    style: pallete.headerMedium.copyWith(
                      color: PdfColors.grey500,
                    ),
                  ),
                  Text(
                    'WTG: ${inspection.turbineNo}',
                    style: pallete.headerMedium.copyWith(
                      color: PdfColors.grey500,
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

  Widget _tableOfContents() {
    final pallete = PdfPalette();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Changes are marked gray within the document.'),
        Text(
          'Table of Contents',
          style: pallete.headerSmall,
        ),
      ],
    );
  }

  Widget _goalPurposeScope(InspectionModel inspection) {
    final pallete = PdfPalette();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '1    Goal and Purpose',
          style: pallete.headerMedium,
        ),
        Text(
          'This document describes the INSPECTION REPORT for the ${inspection.title}.',
        ),
        SizedBox(height: 10),
        Text(
          '2    Scope',
          style: pallete.headerMedium,
        ),
        Text(
          'The inspection was carried out on the ${inspection.createdAt.toDateString()}.',
        ),
        SizedBox(height: 10),
        Text(
          '3    Terms and Abbreviations',
          style: pallete.headerMedium,
        ),
      ],
    );
  }

  Widget _inspectionCriteria() {
    final pallete = PdfPalette();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '5    Inspection Criteria',
          style: pallete.headerMedium,
        ),
        Text(
          'The findings have been rated according to their severity and resulting risk for the WTG operation.',
        ),
        SizedBox(height: 10.0),
        _criteriaContainer(
          3,
          PdfColors.red,
          'Major technical issue that can impact the function of the component within the lifetime.',
        ),
        _criteriaContainer(
          2,
          PdfColors.orange,
          'Finding or critical finding that needs to be resolved before the WTG will be used again.',
        ),
        _criteriaContainer(
          1,
          PdfColors.yellow,
          'Minor finding that needs to be resolved before the WTG will be used again.',
        ),
        _criteriaContainer(
          0,
          PdfColors.green,
          'Positive finding',
        ),
      ],
    );
  }

  Row _criteriaContainer(int risk, PdfColor color, String description) {
    return Row(
      children: [
        Container(
          height: 30,
          width: 30,
          color: color,
          child: Center(
            child: Text(
              risk.toString(),
            ),
          ),
        ),
        Text(
          ' - $description',
        ),
      ],
    );
  }
}
