import '../helpers/enums.dart';

class TransactionFilterModel{
  DateTime? startDate;
  DateTime? endDate;
  double? minAmount;
  double? maxAmount;
  List<String> selectedCategories = [];
  TransactionType? transactionType;
}

