import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maimaid/data/data_sources/local_data_source.dart';
import 'package:maimaid/data/models/user_model.dart';
import 'package:maimaid/domain/entities/user.dart';
import 'package:maimaid/presentation/bloc/user_bloc.dart';
import 'package:maimaid/presentation/widgets/custom_dialog.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  List<UserModel>? _selectedUsers;

  @override
  void initState() {
    super.initState();
    _loadSelectedUsers();
    context.read<UserBloc>().add(LoadUsers(page: _currentPage));
    _scrollController.addListener(_scrollListener);
  }

  void _selectUser(UserModel user) async {
    await LocalDataSource().selectUser(user.toUser());
    await _loadSelectedUsers();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User selected'),
      ),
    );
  }

  void _deleteSelectedUser(UserModel user) async {
    await LocalDataSource().deleteUser(user.toUser());
    await _loadSelectedUsers();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User deleted from selected list'),
      ),
    );
  }

  Future<void> _loadSelectedUsers() async {
    final List<User> selectedUsers = await LocalDataSource().getSelectedUsers();
    setState(() {
      _selectedUsers =
          selectedUsers.map((user) => UserModel.fromUser(user)).toList();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final currentState = context.read<UserBloc>().state;
      if (currentState is UserLoaded &&
          _currentPage < currentState.totalPages) {
        _currentPage++;
        context.read<UserBloc>().add(LoadUsers(page: _currentPage));
      } else {
        print('No more data available');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("User List"),
          actions: [
            CircleAvatar(
              radius: 45,
              backgroundColor: const Color(0XFFECF0F4),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/create_user');
                },
                icon: const Icon(
                  Icons.add,
                ),
              ),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Color(0XFFFB6D3A),
            labelColor: Color(0XFFFB6D3A),
            tabs: [
              Tab(text: "Non Selected"),
              Tab(text: "Selected"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUserListTab("Non Selected"),
            _buildUserListTab("Selected"),
          ],
        ),
      ),
    );
  }

  Widget _buildUserListTab(String tabType) {
    if (tabType == "Non Selected") {
      return BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserDeleted) {
            context.read<UserBloc>().add(LoadUsers(page: _currentPage));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('User deleted successfully'),
              ),
            );
          }
          if (state is UserSelected) {
            context.read<UserBloc>().add(LoadUsers(page: _currentPage));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('User selected'),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is UserLoading && _currentPage == 1) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserError && _currentPage == 1) {
            return Center(child: Text(state.message));
          } else if (state is UserLoaded) {
            return _buildUserList(state);
          }
          return Container();
        },
      );
    } else if (tabType == "Selected") {
      if (_selectedUsers != null && _selectedUsers!.isNotEmpty) {
        return ListView.builder(
          itemCount: _selectedUsers!.length,
          itemBuilder: (context, index) {
            final selectedUser = _selectedUsers![index];
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  selectedUser.avatar,
                  width: 102,
                  height: 102,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                '${selectedUser.firstName} ${selectedUser.lastName}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0XFF32343E),
                ),
              ),
              subtitle: Text(
                selectedUser.email,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0XFFFF7622),
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialog(
                        title: 'Are You Sure?',
                        content: 'Delete Now',
                        onConfirm: () {
                          _deleteSelectedUser(selectedUser);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );
                },
              ),
            );
          },
        );
      } else {
        return const Center(
          child: Text("No selected user"),
        );
      }
    }
    return Container();
  }

  Widget _buildUserList(UserLoaded state) {
    final users = state.users;
    return RefreshIndicator(
      onRefresh: () async {
        context.read<UserBloc>().add(LoadUsers(page: _currentPage));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18, top: 18, bottom: 18),
            child: Text(
              'Total ${users.length} items',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0XFF9C9BA6),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _calculateListItemCount(state),
              itemBuilder: (context, index) {
                if (index < users.length) {
                  final user = users[index];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        user.avatar,
                        width: 102,
                        height: 102,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      '${user.firstName} ${user.lastName}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0XFF32343E),
                      ),
                    ),
                    subtitle: Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0XFFFF7622),
                      ),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'Select':
                            _selectUser(UserModel.fromUser(user));
                            break;
                          case 'Update':
                            Navigator.of(context)
                                .pushNamed('/update_user', arguments: user);
                            break;
                          case 'Delete':
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialog(
                                  title: 'Are You Sure?',
                                  content: 'Delete Now',
                                  onConfirm: () {
                                    context
                                        .read<UserBloc>()
                                        .add(DeleteUserEvent(id: user.id));
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            );
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return {'Select', 'Update', 'Delete'}
                            .map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                  );
                } else {
                  const Center(child: CircularProgressIndicator());
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  int _calculateListItemCount(UserLoaded state) {
    if (state.users.isEmpty) {
      return 0;
    } else {
      return state.users.length + (state.hasReachedMax ? 0 : 1);
    }
  }
}
