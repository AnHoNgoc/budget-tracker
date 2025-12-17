import 'package:budget_tracker/widgets/category_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../services/transaction_service.dart';
import '../utils/app_validator.dart';
import '../utils/show_app_dialog.dart';
import 'month_dropdown.dart';


class AddTransactionForm extends StatefulWidget {
  const AddTransactionForm({super.key});

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _type = "credit";
  String _selectedMonth = "";
  bool _isLoader = false;

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    _selectedMonth = DateFormat("MMM y").format(now);
  }

  final TextEditingController _amountEditController = TextEditingController();
  final TextEditingController _titleEditController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoader = true);

      try {
        await TransactionService().addTransaction(
          title: _titleEditController.text,
          amount: int.parse(_amountEditController.text),
          type: _type,
          monthYear: _selectedMonth
        );

        if (!mounted) return;
        Navigator.pop(context);

      } catch (e) {
        showAppDialog(context, message: '$e', type: DialogType.error);
      } finally {
        if (mounted) setState(() => _isLoader = false);
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
    return CupertinoScrollbar(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                /// Title
                TextFormField(
                  controller: _titleEditController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: AppValidator.isEmptyCheck,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                SizedBox(height: 10.h),

                /// Amount
                TextFormField(
                  controller: _amountEditController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: AppValidator.isEmptyCheck,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Amount"),
                ),
                SizedBox(height: 10.h),

                SizedBox(height: 10.h),
                MonthDropdown(
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedMonth = value;   // bạn lưu lại giá trị đã chọn
                      });
                    }
                  },
                ),

                SizedBox(height: 15.h),

                /// FIXED — SegmentedControl credit/debit
                CupertinoSegmentedControl<String>(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  groupValue: _type,
                  selectedColor: const Color(0xFF1C1C1E),
                  unselectedColor: Colors.white,
                  borderColor: const Color(0xFF1C1C1E),
                  children: {
                    "credit": Padding(
                      padding: EdgeInsets.all(12.h),
                      child: const Text("Credit"),
                    ),
                    "debit": Padding(
                      padding: EdgeInsets.all(12.h),
                      child: const Text("Debit"),
                    ),
                  },
                  onValueChanged: (value) {
                    setState(() => _type = value);
                  },
                ),

                SizedBox(height: 20.h),

                /// iOS button
                SizedBox(
                  height: 50.h,
                  child: CupertinoButton.filled(
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.circular(10.r),
                    onPressed: _isLoader ? null : _submitForm,
                    child: _isLoader
                        ? const CupertinoActivityIndicator(color: Colors.white)
                        : Text(
                      "Add Transaction",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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