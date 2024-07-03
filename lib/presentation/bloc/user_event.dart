part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoadUsers extends UserEvent {
  final int page;

  const LoadUsers({required this.page});

  @override
  List<Object> get props => [page];
}

class LoadUser extends UserEvent {
  final int id;

  const LoadUser({required this.id});

  @override
  List<Object> get props => [id];
}

class CreateUserEvent extends UserEvent {
  final User user;

  const CreateUserEvent({required this.user});

  @override
  List<Object> get props => [user];
}

class UpdateUserEvent extends UserEvent {
  final User user;

  const UpdateUserEvent({required this.user});

  @override
  List<Object> get props => [user];
}

class DeleteUserEvent extends UserEvent {
  final int id;

  const DeleteUserEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class SelectUserEvent extends UserEvent {
  final User user;

  const SelectUserEvent({required this.user});

  @override
  List<Object> get props => [user];
}

class LoadSelectedUsers extends UserEvent {}
