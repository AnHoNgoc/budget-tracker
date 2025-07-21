import 'package:budget_tracker/widgets/category_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/transaction_service.dart';
import '../utils/app_validator.dart';

class AddTransactionForm extends StatefulWidget {
  const AddTransactionForm({super.key});

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _type = "credit";
  String _category = "Others";
  bool _isLoader = false;

  final TextEditingController _amountEditController = TextEditingController();
  final TextEditingController _titleEditController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoader = true;
      });

      try {
        await TransactionService().addTransaction(
          title: _titleEditController.text,
          amount: int.parse(_amountEditController.text),
          type: _type,
          category: _category,
        );

        Navigator.pop(context);
      } catch (e) {
        print("Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong: $e')),
        );
      } finally {
        setState(() {
          _isLoader = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _amountEditController.dispose();
    _titleEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleEditController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: AppValidator.isEmptyCheck,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextFormField(
              controller: _amountEditController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: AppValidator.isEmptyCheck,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Amount"),
            ),
            CategoryDropdown(
              categoryType: _category,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    _category = value;
                  });
                }
              },
            ),
            DropdownButtonFormField(
              value: _type,
              items: const [
                DropdownMenuItem(value: "credit", child: Text("Credit")),
                DropdownMenuItem(value: "debit", child: Text("Debit"))
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _type = value;
                  });
                }
              },
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () {
                if (!_isLoader) {
                  _submitForm();
                }
              },
              child: _isLoader
                  ? const Center(child: CircularProgressIndicator())
                  : const Text("Add Transaction"),
            ),
          ],
        ),
      ),
    );
  }
}