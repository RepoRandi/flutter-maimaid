import 'package:dartz/dartz.dart';
import 'package:maimaid/domain/entities/user.dart';
import 'package:maimaid/domain/repositories/user_repository.dart';
import 'package:maimaid/core/error/failures.dart';

class UpdateUser {
  final UserRepository repository;

  UpdateUser(this.repository);

  Future<Either<Failure, void>> call(User user) async {
    return await repository.updateUser(user);
  }
}
