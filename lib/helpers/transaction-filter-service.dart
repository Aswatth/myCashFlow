import 'package:my_cash_flow/models/transactionFilter-model.dart';

import '../models/transaction-model.dart';

class TransactionFilterService{
  static final TransactionFilterService instance = TransactionFilterService._privateConstructor();

  TransactionFilterService._privateConstructor();

  Future<List<TransactionModel>> filterData(int accountId, TransactionFilterModel transactionFilterModel) async{
    List<TransactionModel> data = [];

    List<TransactionModel>? filteredOnDateData;
    List<TransactionModel>? filteredOnAmountData;
    List<TransactionModel>? filteredOnCategoriesData;
    List<TransactionModel>? filteredOnTransactionTypeData;

    //Filtering on date
    if(transactionFilterModel.startDate != null && transactionFilterModel.endDate != null){
      filteredOnDateData = await TransactionDbHelper.instance.filterDataOnStartAndEndDate(accountId, transactionFilterModel.startDate!, transactionFilterModel.endDate!);
    }
    else if(transactionFilterModel.startDate != null){
      filteredOnDateData = await TransactionDbHelper.instance.filterDataOnStartDate(accountId, transactionFilterModel.startDate!);
    }
    else if(transactionFilterModel.endDate != null){
      filteredOnDateData = await TransactionDbHelper.instance.filterDataOnEndDate(accountId, transactionFilterModel.endDate!);
    }

    //Filtering on amount
    if(transactionFilterModel.minAmount != null && transactionFilterModel.maxAmount != null){
      filteredOnAmountData = await TransactionDbHelper.instance.filterDataOnMinMaxAmount(accountId, transactionFilterModel.minAmount!, transactionFilterModel.maxAmount!);
    }
    else if(transactionFilterModel.minAmount != null){
      filteredOnAmountData = await TransactionDbHelper.instance.filterDataOnMinAmount(accountId, transactionFilterModel.minAmount!);
    }
    else if(transactionFilterModel.maxAmount != null){
      filteredOnAmountData = await TransactionDbHelper.instance.filterDataOnMaxAmount(accountId, transactionFilterModel.maxAmount!);
    }

    //Filtering on categories
    if(transactionFilterModel.selectedCategories.isNotEmpty){
      filteredOnCategoriesData = await TransactionDbHelper.instance.filterDataOnCategories(accountId, transactionFilterModel.selectedCategories);
    }

    //Filtering on transaction type
    if(transactionFilterModel.transactionType != null) {
      filteredOnTransactionTypeData = await TransactionDbHelper.instance.filterDataOnTransactionType(accountId, transactionFilterModel.transactionType!);
    }

    List<TransactionModel>? consolidatedData;
    if(filteredOnDateData != null){
      consolidatedData = [];
      consolidatedData.addAll(filteredOnDateData);
      consolidatedData = consolidatedData.toSet().intersection(filteredOnDateData.toSet()).toList();
    }
    if(filteredOnAmountData != null){
      if(consolidatedData == null) {
        consolidatedData = [];
        consolidatedData.addAll(filteredOnAmountData);
      }
      consolidatedData = consolidatedData.toSet().intersection(filteredOnAmountData.toSet()).toList();
    }
    if(filteredOnCategoriesData != null){
      if(consolidatedData == null) {
        consolidatedData = [];
        consolidatedData.addAll(filteredOnCategoriesData);
      }
      consolidatedData = consolidatedData.toSet().intersection(filteredOnCategoriesData.toSet()).toList();
    }
    if(filteredOnTransactionTypeData != null){
      if(consolidatedData == null) {
        consolidatedData = [];
        consolidatedData.addAll(filteredOnTransactionTypeData);
      }
      consolidatedData = consolidatedData.toSet().intersection(filteredOnTransactionTypeData.toSet()).toList();
    }

    if(consolidatedData == null) {
      data = [];
    }
    else{
      data = consolidatedData;
    }
    return data;
  }
}