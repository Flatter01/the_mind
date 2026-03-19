import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_students/data/datasources/lid_api_service.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/lids/lid_models.dart';
import 'lid_state.dart';

class LidCubit extends Cubit<LidState> {
  final LidApiService _api;

  LidCubit(this._api) : super(LidInitial());

  // ── Загрузить все лиды ────────────────────────────────────────────────────
  Future<void> getLeads() async {
    if (isClosed) return;
    emit(LidLoading());
    try {
      final leads = await _api.getLeads();
      if (isClosed) return;
      emit(LidLoaded(leads));
    } catch (e) {
      if (isClosed) return;
      emit(LidError(e.toString()));
    }
  }

  // ── Создать лида ──────────────────────────────────────────────────────────
  Future<void> createLead({
    required String firstName,
    required String phone,
    String status = 'new',
    int? interestedCourse,
    String? source,
    String? comment,
  }) async {
    if (isClosed) return;
    emit(LidCreating());
    try {
      await _api.createLead(
        firstName: firstName,
        phone: phone,
        status: status,
        interestedCourse: interestedCourse,
        source: source,
        comment: comment,
      );
      if (isClosed) return;
      await getLeads();
    } catch (e) {
      if (isClosed) return;
      emit(LidError(e.toString()));
    }
  }

  // ── Обновить лида ─────────────────────────────────────────────────────────
  Future<void> updateLead({
    required int id,
    required String firstName,
    String? phone,
    String? date,
    int? branch,
    String? destination,
    String? source,
    String? gender,
    int? course,
    bool giveBook = false,
    String? comment,
    String? statusDisplay, // принимаем русское название
  }) async {
    if (isClosed) return;
    final prevLeads = state is LidLoaded
        ? List<LidModel>.from((state as LidLoaded).leads)
        : <LidModel>[];
    emit(LidUpdating());
    try {
      final apiStatus = statusDisplay != null
          ? LidModel.toApiStatus(statusDisplay)
          : null;
      await _api.updateLead(
        id: id,
        firstName: firstName,
        phone: phone,
        date: date,
        branch: branch,
        destination: destination,
        source: source,
        gender: gender,
        course: course,
        giveBook: giveBook,
        comment: comment,
        status: apiStatus,
      );
      if (isClosed) return;
      await getLeads();
    } catch (e) {
      if (isClosed) return;
      emit(LidError(e.toString()));
    }
  }

  // ── Сменить статус ────────────────────────────────────────────────────────
  // ✅ Валидные API статусы: new | demo | came | not_came | call | no_answer
  Future<void> changeStatus({
    required int id,
    required String statusDisplay, // русское название из UI
    required VoidCallback onSuccess
  }) async {
    if (isClosed) return;
    try {
      final apiStatus = LidModel.toApiStatus(statusDisplay);
      print('Changing status: $statusDisplay → $apiStatus');
      await _api.updateStatus(id: id, status: apiStatus);
      if (isClosed) return;
      await getLeads();
      WidgetsBinding.instance.addPostFrameCallback((_) => onSuccess());
    } catch (e) {
      if (isClosed) return;
      emit(LidError(e.toString()));
    }
  }

  // ── Удалить ───────────────────────────────────────────────────────────────
  Future<void> deleteLead(int id) async {
    if (isClosed) return;
    try {
      await _api.deleteLead(id);
      if (isClosed) return;
      await getLeads();
    } catch (e) {
      if (isClosed) return;
      emit(LidError(e.toString()));
    }
  }
}