import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/subject.dart';
import '../providers/subject_provider.dart';

/// Screen 1 — a form to add a subject with its mark.
///
/// It is a StatefulWidget only to own the TextEditingControllers and the form
/// key. It never calls setState; all app state lives in the provider.
class AddSubjectScreen extends StatefulWidget {
  const AddSubjectScreen({super.key});

  @override
  State<AddSubjectScreen> createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _markController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _markController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final mark = int.parse(_markController.text.trim());

    context.read<SubjectProvider>().addSubject(Subject(name: name, mark: mark));

    _nameController.clear();
    _markController.clear();
    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"$name" added')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Add a new subject', style: textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(
              'Enter the subject name and a mark between 0 and 100.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Subject name',
                prefixIcon: Icon(Icons.book_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a subject name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _markController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Mark (0 - 100)',
                prefixIcon: Icon(Icons.grade_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a mark';
                }
                final mark = int.tryParse(value.trim());
                if (mark == null) {
                  return 'Mark must be a whole number';
                }
                if (mark < 0 || mark > 100) {
                  return 'Mark must be between 0 and 100';
                }
                return null;
              },
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.add),
              label: const Text('Add Subject'),
            ),
          ],
        ),
      ),
    );
  }
}
