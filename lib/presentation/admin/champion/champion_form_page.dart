import 'package:flutter/material.dart';
import 'package:lol_champions/l10n/app_localizations.dart';

class ChampionFormPage extends StatefulWidget {
  const ChampionFormPage({super.key});

  @override
  State<ChampionFormPage> createState() => _ChampionFormPageState();
}

class _ChampionFormPageState extends State<ChampionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController blurbController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    titleController.dispose();
    blurbController.dispose();
    tagsController.dispose();
    imageController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.creationDisabled)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String? required(String? value) =>
        value == null || value.trim().isEmpty ? l10n.required : null;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: l10n.fieldName),
                  validator: required,
                ),
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: l10n.fieldTitle),
                  validator: required,
                ),
                TextFormField(
                  controller: blurbController,
                  decoration: InputDecoration(labelText: l10n.fieldBlurb),
                  maxLines: 3,
                  validator: required,
                ),
                TextFormField(
                  controller: tagsController,
                  decoration: InputDecoration(labelText: l10n.fieldTags),
                  validator: required,
                ),
                TextFormField(
                  controller: imageController,
                  decoration: InputDecoration(labelText: l10n.fieldImageUrl),
                  keyboardType: TextInputType.url,
                  validator: required,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: Text(l10n.submit),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
