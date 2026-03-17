import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_workers/data/admin_api_service.dart';
import 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  final AdminApiService _api;

  AdminCubit(this._api) : super(AdminInitial());

  // ── Загрузить всех ────────────────────────────────────────────────────────
  Future<void> getAdmins() async {
    if (isClosed) return;
    emit(AdminLoading());
    try {
      final admins = await _api.getAdmins();
      if (isClosed) return;
      emit(AdminLoaded(admins));
    } catch (e) {
      if (isClosed) return;
      emit(AdminError(e.toString()));
    }
  }

  // ── Создать нового ────────────────────────────────────────────────────────
  Future<void> createAdmin({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required String role,
    String? phoneNumber,
    bool isActive = true,
  }) async {
    if (isClosed) return;
    emit(AdminCreating());
    try {
      await _api.createAdmin(
        firstName: firstName,
        lastName: lastName,
        username: username,
        password: password,
        role: role,
        phoneNumber: phoneNumber,
        isActive: isActive,
      );
      if (isClosed) return;
      emit(AdminCreated());
      // Обновляем список
      await getAdmins();
    } catch (e) {
      if (isClosed) return;
      emit(AdminError(e.toString()));
    }
  }

  // ── Удалить ───────────────────────────────────────────────────────────────
  Future<void> deleteAdmin(String id) async {
    if (isClosed) return;
    try {
      await _api.deleteAdmin(id);
      await getAdmins();
    } catch (e) {
      if (isClosed) return;
      emit(AdminError(e.toString()));
    }
  }
}