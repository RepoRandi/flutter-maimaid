import 'package:dartz/dartz.dart';
import 'package:maimaid/domain/entities/user.dart';
import 'package:maimaid/domain/repositories/user_repository.dart';
import 'package:maimaid/core/error/failures.dart';

class CreateUser {
  final UserRepository repository;

  CreateUser(this.repository);

  Future<Either<Failure, void>> call(User user) async {
    return await repository.createUser(user);
  }
}
