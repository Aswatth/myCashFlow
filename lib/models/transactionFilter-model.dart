import 'package:my_cash_flow/models/transaction-model.dart';
import 'package:my_cash_flow/models/transactionTypeEnum.dart';

import 'transaction-category.dart';

class TransactionFilterModel{
  String? startDate;
  String? endDate;
  double? minAmount;
  double? maxAmount;
  List<String> selectedCategories = [];
  TransactionType? transactionType;

  bool hasFilter(){
    return (startDate != null && endDate != null && minAmount != null && maxAmount != null && selectedCategories.isEmpty && transactionType != null);
  }

  @override
  String toString() {
    return 'TransactionFilterModel{startDate: $startDate, endDate: $endDate, minAmount: $minAmount, maxAmount: $maxAmount, selectedCategories: $selectedCategories, transactionType: $transactionType}';
  }
}

