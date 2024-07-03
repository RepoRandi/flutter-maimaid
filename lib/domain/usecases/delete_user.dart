import 'package:dartz/dartz.dart';
import 'package:maimaid/domain/repositories/user_repository.dart';
import 'package:maimaid/core/error/failures.dart';

class DeleteUser {
  final UserRepository repository;

  DeleteUser(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.deleteUser(id);
  }
}
