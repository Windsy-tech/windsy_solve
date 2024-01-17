import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:windsy_solve/features/nc/repository/nc_actions_repository.dart';

class NCActionsController {
  final NCActionsRepository _ncActionsRepository;
  final Ref _ref;

  NCActionsController({
    required NCActionsRepository ncActionsRepository,
    required Ref ref,
  })  : _ncActionsRepository = ncActionsRepository,
        _ref = ref;
}
