import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:repore_chat/chat/application/chat_group_notifier.dart';
import 'package:repore_chat/utils/widgets/custom_button.dart';
import 'package:repore_chat/utils/widgets/custom_textfield.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _groupNameController = TextEditingController();
  final _membersController = TextEditingController();

  @override
  void dispose() {
    _groupNameController.dispose();
    _membersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupState = ref.watch(chatGroupProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _groupNameController,
                label: 'Group Name',
                hint: 'e.g Our wonderful group',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a group name';
                  }
                  return null;
                },
              ),
              const Gap(16),
              CustomTextField(
                controller: _membersController,
                label: 'Member Emails',
                hint: 'Enter email addresses separated by commas',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter at least one member email';
                  }
                  final emails = value.split(',').map((e) => e.trim()).toList();
                  for (final email in emails) {
                    if (!email.contains('@')) {
                      return 'Invalid email format: $email';
                    }
                  }
                  return null;
                },
              ),
              const Gap(16),
              CustomButton(
                text: 'Create Group',
                loading: groupState.isLoading,
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    try {
                      await ref
                          .read(chatGroupProvider.notifier)
                          .createGroup(_groupNameController.text, _membersController.text);

                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
