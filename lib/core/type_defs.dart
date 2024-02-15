import 'package:fpdart/fpdart.dart';

import 'handler/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
