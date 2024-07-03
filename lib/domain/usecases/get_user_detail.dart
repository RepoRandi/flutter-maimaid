import 'package:dartz/dartz.dart';
import 'package:maimaid/domain/entities/user.dart';
import 'package:maimaid/domain/repositories/user_repository.dart';
import 'package:maimaid/core/error/failures.dart';

class GetUserDetail {
  final UserRepository repository;

  GetUserDetail(this.repository);

  Future<Either<Failure, User>> call(int id) async {
    return await repository.getUserDetail(id);
  }
}
