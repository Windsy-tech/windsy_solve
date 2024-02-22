import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:windsy_solve/features/nc/repository/nc_actions_repository.dart';
import 'package:windsy_solve/models/nc/nc_actions_model.dart';
import 'package:windsy_solve/utils/snack_bar.dart';

final ncActionsControllerProvider = Provider<NCActionsController>((ref) {
  final ncActionsRepository = ref.watch(ncActionsRepositoryProvider);
  return NCActionsController(
    ncActionsRepository: ncActionsRepository,
    ref: ref,
  );
});

class NCActionsController {
  final NCActionsRepository _ncActionsRepository;
  final Ref _ref;

  NCActionsController({
    required NCActionsRepository ncActionsRepository,
    required Ref ref,
  })  : _ncActionsRepository = ncActionsRepository,
        _ref = ref;

  void addAction(
      BuildContext context, String ncId, NCActionsModel ncActionsModel) async {
    final res = await _ncActionsRepository.addActionToNC(ncId, ncActionsModel);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }
}
