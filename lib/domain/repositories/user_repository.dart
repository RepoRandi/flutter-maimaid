import 'package:dartz/dartz.dart';
import 'package:maimaid/core/error/failures.dart';
import 'package:maimaid/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, List<User>>> getUsers(int page);
  Future<Either<Failure, User>> getUserDetail(int id);
  Future<Either<Failure, void>> createUser(User user);
  Future<Either<Failure, void>> updateUser(User user);
  Future<Either<Failure, void>> deleteUser(int id);
}
