import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:maimaid/data/data_sources/local_data_source.dart';
import 'package:maimaid/domain/entities/user.dart';
import 'package:maimaid/domain/usecases/get_users.dart';
import 'package:maimaid/domain/usecases/get_user_detail.dart';
import 'package:maimaid/domain/usecases/create_user.dart';
import 'package:maimaid/domain/usecases/update_user.dart';
import 'package:maimaid/domain/usecases/delete_user.dart';
import 'package:maimaid/domain/usecases/select_user.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsers getUsers;
  final GetUserDetail getUserDetail;
  final CreateUser createUser;
  final UpdateUser updateUser;
  final DeleteUser deleteUser;
  final SelectUser selectUser;
  final LocalDataSource localDataSource;

  UserBloc(
      {required this.getUsers,
      required this.getUserDetail,
      required this.createUser,
      required this.updateUser,
      required this.deleteUser,
      required this.selectUser,
      required this.localDataSource})
      : super(UserInitial()) {
    on<LoadUsers>((event, emit) async {
      emit(UserLoading());
      final failureOrUsers = await getUsers(event.page);
      failureOrUsers.fold(
        (failure) => emit(const UserError(message: "Failed to load users")),
        (users) {
          if (users.isEmpty) {
            emit(const UserLoaded(
                users: [], hasReachedMax: true, totalPages: 0));
          } else {
            emit(UserLoaded(users: users, hasReachedMax: false, totalPages: 2));
          }
        },
      );
    });

    on<LoadUser>((event, emit) async {
      emit(UserLoading());
      final failureOrUsers = await getUserDetail(event.id);
      failureOrUsers.fold(
        (failure) => emit(const UserError(message: "Failed to load users")),
        (user) {
          emit(UserDetailLoaded(user: user));
        },
      );
    });

    on<CreateUserEvent>((event, emit) async {
      final failureOrVoid = await createUser(event.user);
      failureOrVoid.fold(
        (failure) => emit(const UserError(message: "Failed to create user")),
        (_) => emit(const UserCreated()),
      );
    });

    on<UpdateUserEvent>((event, emit) async {
      final failureOrVoid = await updateUser(event.user);
      failureOrVoid.fold(
        (failure) => emit(const UserError(message: "Failed to update user")),
        (_) => emit(const UserUpdated()),
      );
    });

    on<DeleteUserEvent>((event, emit) async {
      final failureOrVoid = await deleteUser(event.id);
      failureOrVoid.fold(
        (failure) => emit(const UserError(message: "Failed to delete user")),
        (_) => emit(const UserDeleted()),
      );
    });

    on<SelectUserEvent>((event, emit) async {
      await selectUser(event.user);
      final selectedUsers = await localDataSource.getSelectedUsers();
      emit(UserSelected(users: selectedUsers));
    });

    on<LoadSelectedUsers>((event, emit) async {
      final selectedUsers = await localDataSource.getSelectedUsers();
      emit(UserSelected(users: selectedUsers));
    });
  }
}
