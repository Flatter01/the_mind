import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_transactions/data/transaction_api_service.dart';
import 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionApiService _api;

  TransactionCubit(this._api) : super(TransactionInitial());

  Future<void> getTransactions() async {
    if (isClosed) return;
    emit(TransactionLoading());
    try {
      final list = await _api.getTransactions();
      if (isClosed) return;
      emit(TransactionLoaded(list));
    } catch (e) {
      if (isClosed) return;
      emit(TransactionError(e.toString()));
    }
  }
}