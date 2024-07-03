import 'package:dartz/dartz.dart';
import 'package:maimaid/domain/entities/user.dart';
import 'package:maimaid/domain/repositories/user_repository.dart';
import 'package:maimaid/core/error/failures.dart';

class GetUsers {
  final UserRepository repository;

  GetUsers(this.repository);

  Future<Either<Failure, List<User>>> call(int page) async {
    return await repository.getUsers(page);
  }
}
