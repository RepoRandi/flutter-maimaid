part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> users;
  final bool hasReachedMax;
  final int totalPages;

  const UserLoaded({
    required this.users,
    required this.hasReachedMax,
    required this.totalPages,
  });

  @override
  List<Object> get props => [users, hasReachedMax, totalPages];
}

class UserDetailLoaded extends UserState {
  final User user;

  const UserDetailLoaded({
    required this.user,
  });

  @override
  List<Object> get props => [user];
}

class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object> get props => [message];
}

class UserSelected extends UserState {
  final List<User> users;

  const UserSelected({required this.users});

  @override
  List<Object> get props => [users];
}

class UserDeleted extends UserState {
  const UserDeleted();

  @override
  List<Object> get props => [];
}

class UserUpdated extends UserState {
  const UserUpdated();

  @override
  List<Object> get props => [];
}

class UserCreated extends UserState {
  const UserCreated();

  @override
  List<Object> get props => [];
}
