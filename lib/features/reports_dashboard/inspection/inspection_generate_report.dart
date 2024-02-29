import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/features/reports_dashboard/controller/reports_controller.dart';
import 'package:windsy_solve/theme/color_palette.dart';
import 'package:windsy_solve/utils/text_utils.dart';

class InspectionGenerateReport extends ConsumerStatefulWidget {
  const InspectionGenerateReport({super.key});

  @override
  ConsumerState<InspectionGenerateReport> createState() =>
      _InspectionGenerateReportState();
}

class _InspectionGenerateReportState
    extends ConsumerState<InspectionGenerateReport> {
  final _fileNameTextController = TextEditingController();
  final List<String> _languages = ['English', 'German', 'French'];
  final List<String> _confidentialityLevel = [
    'Public',
    'Internal',
    'Confidential',
    'Restricted',
    'Highly Restricted',
  ];

  final String _selectedConfidentialityLevel = 'Public';
  final String _selectedLanguage = 'English';
  bool _includeAllAttachments = true;

  @override
  void dispose() {
    _fileNameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(reportsControllerProvider);
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Inspection Report"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Routemaster.of(context).history.back();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: theme.brightness == Brightness.dark
              ? ColorPalette.darkSurface
              : ColorPalette.lightSurface,
        ),
        child: SizedBox(
          height: size.height,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'What kind of report do you want to generate?',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Choose from the options below',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          //File name
                          TextField(
                            controller: _fileNameTextController,
                            inputFormatters: [
                              NoSpaceFormatter(),
                            ],
                            decoration: InputDecoration(
                              labelText: 'File Name',
                              helperText:
                                  'Enter file name without spaces & extension',
                              labelStyle: theme.textTheme.bodyMedium,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              suffix: const Text('.pdf'),
                            ),
                          ),
                          const SizedBox(height: 16.0),

                          //Set Version Manually

                          //const SizedBox(height: 10.0),
                          //Language
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: _selectedConfidentialityLevel,
                            decoration: InputDecoration(
                              labelText: 'Confidentiality Level',
                              labelStyle: theme.textTheme.bodyMedium,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            dropdownColor: theme.colorScheme.surface,
                            items: _confidentialityLevel
                                .map<DropdownMenuItem<String>>(
                                    (String confidentialityLevel) {
                              return DropdownMenuItem<String>(
                                value: confidentialityLevel,
                                child: Text(
                                  confidentialityLevel,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              print(val);
                            },
                          ),
                          const SizedBox(height: 16.0),
                          //Language
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: _selectedLanguage,
                            decoration: InputDecoration(
                              labelText: 'Language',
                              labelStyle: theme.textTheme.bodyMedium,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            dropdownColor: theme.colorScheme.surface,
                            items: _languages.map<DropdownMenuItem<String>>(
                                (String language) {
                              return DropdownMenuItem<String>(
                                value: language,
                                child: Text(
                                  language,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              print(val);
                            },
                          ),

                          const SizedBox(height: 8.0),

                          //Include all attachments button
                          CheckboxListTile.adaptive(
                            value: _includeAllAttachments,
                            title: Text(
                              'Include all attachments',
                              style: theme.textTheme.bodyMedium,
                            ),
                            onChanged: (val) {
                              setState(() {
                                _includeAllAttachments = val!;
                              });
                            },
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                            ),
                          ),

                          //Generate Report Button
                          ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(reportsControllerProvider.notifier)
                                  .createInspectionReport(
                                    id: 'test',
                                    fileName: _fileNameTextController.text,
                                    language: _selectedLanguage,
                                    includeAllAttachments:
                                        _includeAllAttachments,
                                    fileType: 'pdf',
                                    confidentialityLevel:
                                        _selectedConfidentialityLevel,
                                    context: context,
                                  );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  theme.colorScheme.secondaryContainer,
                            ),
                            child: const Text('Generate Report'),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
