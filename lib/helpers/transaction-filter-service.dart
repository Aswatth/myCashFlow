import 'package:intl/intl.dart';
import 'package:my_cash_flow/helpers/globals.dart';
import 'package:my_cash_flow/models/transaction-filter-model.dart';

import '../models/transaction-model.dart';

class TransactionFilterService{
  static final TransactionFilterService instance = TransactionFilterService._privateConstructor();

  TransactionFilterService._privateConstructor();

  Future<List<TransactionModel>> filterData(int accountId, TransactionFilterModel transactionFilterModel) async{
    List<TransactionModel> transactionList = await TransactionDbHelper.instance.getAll(accountId);

    List<TransactionModel> filteredOnDateData = [];
    List<TransactionModel> filteredOnAmountData = [];
    List<TransactionModel> filteredOnCategoriesData = [];
    List<TransactionModel> filteredOnTransactionTypeData = [];

    //Filter for dates
    filteredOnDateData = transactionList.where((element){
      if(transactionFilterModel.startDate != null && transactionFilterModel.endDate != null){
        return (transactionFilterModel.startDate!.compareTo(element.transactionDate!) <= 0 )&& (transactionFilterModel.endDate!.compareTo(element.transactionDate!) >= 0 );
      }
      else if(transactionFilterModel.startDate != null){
        return (transactionFilterModel.startDate!.compareTo(element.transactionDate!) <= 0);
      }
      else if(transactionFilterModel.endDate != null){
        return (transactionFilterModel.endDate!.compareTo(element.transactionDate!) >=0);
      }
      return true;
    }).toList();

    //Filtering on amount
    filteredOnAmountData = transactionList.where((element){
      if(transactionFilterModel.minAmount != null && transactionFilterModel.maxAmount != null){
        return (transactionFilterModel.minAmount! <= element.amount!) && (element.amount! <= transactionFilterModel.maxAmount!);
      }
      else if(transactionFilterModel.minAmount != null){
        return (transactionFilterModel.minAmount! <= element.amount!);
      }
      else if(transactionFilterModel.maxAmount != null) {
        return (element.amount! <= transactionFilterModel.maxAmount!);
      }
      return true;
    }).toList();

    //Filtering on categories
    filteredOnCategoriesData = transactionList.where((element){
      if(transactionFilterModel.selectedCategories.isNotEmpty){
        return transactionFilterModel.selectedCategories.contains(element.category);
      }
      return true;
    }).toList();

    //Filtering on transaction type
    filteredOnTransactionTypeData = transactionList.where((element){
      if(transactionFilterModel.transactionType != null) {
        return element.transactionType == transactionFilterModel.transactionType;
      }
      return true;
    }).toList();

    return filteredOnDateData.toSet().intersection(filteredOnAmountData.toSet()).intersection(filteredOnCategoriesData.toSet()).intersection(filteredOnTransactionTypeData.toSet()).toList();
  }
}