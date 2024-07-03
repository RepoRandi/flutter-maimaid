import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maimaid/presentation/arguments/success_page_arguments.dart';
import 'package:maimaid/presentation/bloc/user_bloc.dart';
import 'package:maimaid/presentation/widgets/custom_dropdown.dart';
import 'package:maimaid/presentation/widgets/custom_text_field.dart';
import 'package:maimaid/presentation/widgets/custom_button.dart';
import 'package:maimaid/domain/entities/user.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final TextEditingController _nameController = TextEditingController();
  String selectedJob = 'Job';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: const Color(0XFFECF0F4),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                    ),
                  ),
                ),
              ),
            ],
          ),
          title: const Text("Create User")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CustomTextField(
              controller: _nameController,
              label: "Name",
            ),
            const SizedBox(height: 30.0),
            CustomDropdown<String>(
              items: const ['Front End', 'Back End', 'Data Analist'],
              title: 'Select an Option',
              itemLabelBuilder: (item) => item,
              onItemSelected: (selectedItem) {
                setState(() {
                  selectedJob = selectedItem;
                });
              },
              initialValue: selectedJob,
            ),
            const Expanded(child: SizedBox()),
            BlocListener<UserBloc, UserState>(
              listener: (context, state) {
                if (state is UserCreated) {
                  Navigator.of(context).pushNamed(
                    '/success',
                    arguments: SuccessPageArguments(
                      title: "Create Successful",
                      onUpdate: () {
                        Navigator.of(context).pushNamed('/user_list');
                      },
                    ),
                  );
                }
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CustomButton(
                  label: "Create",
                  onPressed: () {
                    final user = User(
                      id: 0,
                      firstName: _nameController.text,
                      lastName: selectedJob,
                      email: '',
                      avatar: '',
                    );
                    context.read<UserBloc>().add(CreateUserEvent(user: user));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
