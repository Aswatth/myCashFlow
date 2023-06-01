import 'package:my_cash_flow/models/transaction-model.dart';
import 'package:my_cash_flow/models/transactionTypeEnum.dart';

import '../helpers/enums.dart';
import 'transaction-category.dart';

class TransactionFilterModel{
  DateTime? startDate;
  DateTime? endDate;
  double? minAmount;
  double? maxAmount;
  List<String> selectedCategories = [];
  TransactionType? transactionType;
}

