import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/features/nc/controller/nc_attachments_controller.dart';
import 'package:windsy_solve/models/attachment_model.dart';
import 'package:windsy_solve/theme/color_palette.dart';

class ShowAttachment extends ConsumerStatefulWidget {
  final String ncId;
  final AttachmentModel attachment;

  const ShowAttachment({
    super.key,
    required this.ncId,
    required this.attachment,
  });

  @override
  ConsumerState<ShowAttachment> createState() =>
      _CreateConsumerShowAttachmentState();
}

class _CreateConsumerShowAttachmentState extends ConsumerState<ShowAttachment> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.attachment.comment;
  }

  void updateComment(BuildContext context) {
    print(_controller.text);
    ref.read(ncAttachmentControllerProvider.notifier).updateAttachmentComment(
          context: context,
          ncId: widget.ncId,
          attachment: widget.attachment,
          comment: _controller.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if (widget.attachment.fileType != 'pdf' &&
                _controller.text != widget.attachment.comment) {
              updateComment(context);
            }
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close_outlined,
            size: 16,
          ),
        ),
        title: Text(
          widget.attachment.name,
          style: theme.textTheme.labelMedium,
        ),
      ),
      body: Container(
        height: size.height,
        decoration: BoxDecoration(
          gradient: theme.brightness == Brightness.dark
              ? ColorPalette.darkSurface
              : ColorPalette.lightSurface,
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                widget.attachment.fileType == 'pdf'
                    ? Expanded(
                        child: const PDF().fromUrl(widget.attachment.fileUrl))
                    : Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: InteractiveViewer(
                                constrained: true,
                                child: Image.network(
                                  widget.attachment.fileUrl,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? "${((loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!) * 100).toInt().toString()} %"
                                                : "",
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _controller,
                                maxLines: 2,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  hintText: 'Add Comment',
                                  hintStyle: theme.textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
