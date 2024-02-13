import 'package:flutter/material.dart';
import 'package:windsy_solve/core/common/widgets/label_widget.dart';
import 'package:windsy_solve/utils/text_utils.dart';

class CheckListListTile extends StatelessWidget {
  final String title;
  final String? value;
  final Function()? onTap;
  const CheckListListTile({
    required this.title,
    this.value,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onTap,
      leading: LabelWidget(title),
      trailing: Text(
        value?.shortenText() ?? "",
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}
