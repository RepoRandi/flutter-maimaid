import 'package:dartz/dartz.dart';
import 'package:maimaid/data/models/user_model.dart';
import 'package:maimaid/domain/entities/user.dart';
import 'package:maimaid/domain/repositories/user_repository.dart';
import 'package:maimaid/data/data_sources/remote_data_source.dart';
import 'package:maimaid/core/error/failures.dart';

class UserRepositoryImpl implements UserRepository {
  final RemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<User>>> getUsers(int page) async {
    try {
      final users = await remoteDataSource.getUsers(page);
      return Right(users);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getUserDetail(int id) async {
    try {
      final user = await remoteDataSource.getUserDetail(id);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> createUser(User user) async {
    try {
      final userModel = UserModel(
        id: user.id,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        avatar: user.avatar,
      );
      await remoteDataSource.createUser(userModel.toCreateUpdateJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateUser(User user) async {
    try {
      final userModel = UserModel(
        id: user.id,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        avatar: user.avatar,
      );
      await remoteDataSource.updateUser(userModel.toCreateUpdateJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(int id) async {
    try {
      await remoteDataSource.deleteUser(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
