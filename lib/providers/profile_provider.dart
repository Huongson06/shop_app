import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplite/constants/pref_data.dart';
import 'package:shoplite/repositories/auth_repository.dart';
import 'package:shoplite/models/profile.dart';
import '../constants/apilist.dart';
import '../constants/enum.dart';

class ProfileState {
  final Profile profile;
  final UpdateStatus updateStatus;
  final String? errorMessage;

  ProfileState({
    required this.profile,
    this.updateStatus = UpdateStatus.initial,
    this.errorMessage,
  });

  // Sao chép ProfileState với các giá trị có thể được cập nhật
  ProfileState copyWith({
    Profile? profile,
    UpdateStatus? updateStatus,
    String? errorMessage,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      updateStatus: updateStatus ?? this.updateStatus,
      errorMessage: errorMessage,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final AuthRepository _repository;

  ProfileNotifier(this._repository) : super(ProfileState(profile: initialProfile)) {
    _loadProfile();
  }

  Future<void> updateProfile(Profile updatedProfile) async {
    try {
      // Cập nhật trạng thái thành loading
      state = state.copyWith(updateStatus: UpdateStatus.loading);

      // Gửi yêu cầu cập nhật profile lên API
      bool isSuccess = await _repository.updateProfile(updatedProfile);  // Gọi hàm updateProfile của repository

      if (isSuccess) {
        // Thành công, cập nhật state và lưu thông tin
        state = state.copyWith(updateStatus: UpdateStatus.success, profile: updatedProfile);
        await PrefData.setProfile(updatedProfile);  // Lưu thông tin profile vào SharedPreferences
      } else {
        // Thất bại
        state = state.copyWith(updateStatus: UpdateStatus.failure, errorMessage: "Failed to update profile");
      }
    } catch (e) {
      state = state.copyWith(updateStatus: UpdateStatus.failure, errorMessage: e.toString());
    }
  }
}

class _loadProfile {
}



// Provider cho AuthRepository
final profileRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository());

// StateNotifierProvider để quản lý trạng thái ProfileNotifier
final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return ProfileNotifier(repository);
});
