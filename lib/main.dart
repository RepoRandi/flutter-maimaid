import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:maimaid/data/data_sources/local_data_source.dart';
import 'package:maimaid/data/repositories/user_repository_impl.dart';
import 'package:maimaid/data/data_sources/remote_data_source.dart';
import 'package:maimaid/domain/usecases/get_users.dart';
import 'package:maimaid/domain/usecases/get_user_detail.dart';
import 'package:maimaid/domain/usecases/create_user.dart';
import 'package:maimaid/domain/usecases/update_user.dart';
import 'package:maimaid/domain/usecases/delete_user.dart';
import 'package:maimaid/domain/usecases/select_user.dart';
import 'package:maimaid/presentation/bloc/user_bloc.dart';
import 'package:maimaid/presentation/pages/splash_screen.dart';
import 'package:maimaid/presentation/pages/onboarding_page.dart';
import 'package:maimaid/presentation/pages/success_page.dart';
import 'package:maimaid/presentation/pages/user_list_page.dart';
import 'package:maimaid/presentation/pages/create_user_page.dart';
import 'package:maimaid/presentation/pages/update_user_page.dart';

import 'domain/entities/user.dart';
import 'presentation/arguments/success_page_arguments.dart';

void main() {
  final http.Client httpClient = http.Client();
  final RemoteDataSource remoteDataSource = RemoteDataSource(httpClient);
  final UserRepositoryImpl userRepository =
      UserRepositoryImpl(remoteDataSource);

  runApp(MyApp(userRepository: userRepository));
}

class MyApp extends StatelessWidget {
  final UserRepositoryImpl userRepository;

  const MyApp({super.key, required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserBloc(
            getUsers: GetUsers(userRepository),
            getUserDetail: GetUserDetail(userRepository),
            createUser: CreateUser(userRepository),
            updateUser: UpdateUser(userRepository),
            deleteUser: DeleteUser(userRepository),
            selectUser: SelectUser(),
            localDataSource: LocalDataSource(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'User Management',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                  builder: (context) => const SplashScreen());
            case '/onboarding':
              return MaterialPageRoute(
                  builder: (context) => const OnboardingPage());
            case '/user_list':
              return MaterialPageRoute(
                  builder: (context) => const UserListPage());
            case '/create_user':
              return MaterialPageRoute(builder: (context) => CreateUserPage());
            case '/update_user':
              final user = settings.arguments as User;
              return MaterialPageRoute(
                  builder: (context) => UpdateUserPage(user: user));
            case '/success':
              final successArgs = settings.arguments as SuccessPageArguments;
              return MaterialPageRoute(
                builder: (context) => SuccessPage(
                  title: successArgs.title,
                  onUpdate: successArgs.onUpdate,
                ),
              );
            default:
              return null;
          }
        },
      ),
    );
  }
}
