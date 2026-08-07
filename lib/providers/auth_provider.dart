import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  AuthNotifier() : super(AuthState.initial()) {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await _storageService.isLoggedIn();
    if (isLoggedIn) {
      final userId = await _storageService.getUserId();
      if (userId != null) {
        try {
          final user = await _apiService.getUser(userId);
          state = AuthState.authenticated(user);
        } catch (e) {
          state = AuthState.unauthenticated();
        }
      }
    } else {
      state = AuthState.unauthenticated();
    }
  }

  Future<bool> login(String username, String password) async {
    try {
      state = AuthState.loading();
      print('🟡 AuthNotifier: Starting login...');
      
      final response = await _apiService.login(username, password);
      final token = response['token'];
      print('🟢 Got token: $token');
      
      final userId = 1;
      
      await _storageService.saveToken(token);
      await _storageService.saveUserId(userId);
      
      final user = await _apiService.getUser(userId);
      print('🟢 Got user: ${user.username}');
      
      state = AuthState.authenticated(user);
      return true;
    } catch (e) {
      print('🔴 Login error: $e');
      state = AuthState.error(e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await _storageService.clearAll();
    state = AuthState.unauthenticated();
  }

  void clearError() {
    if (state.error != null) {
      state = AuthState.unauthenticated();
    }
  }
}

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final User? user;
  final String? error;

  AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.user,
    this.error,
  });

  factory AuthState.initial() {
    return AuthState(isLoading: true, isAuthenticated: false);
  }

  factory AuthState.loading() {
    return AuthState(isLoading: true);
  }

  factory AuthState.authenticated(User user) {
    return AuthState(isAuthenticated: true, user: user);
  }

  factory AuthState.unauthenticated() {
    return AuthState(isAuthenticated: false);
  }

  factory AuthState.error(String error) {
    return AuthState(error: error);
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});