import 'package:rxdart/rxdart.dart';
import '../services/AuthService.dart';

class AuthViewModel {
  final BehaviorSubject<bool> _isAuthenticated = BehaviorSubject.seeded(false);
  final BehaviorSubject<bool> _isAuthenticating = BehaviorSubject.seeded(false);

  Stream<bool> get isAuthenticatedStream => _isAuthenticated.stream;
  Stream<bool> get isAuthenticatingStream => _isAuthenticating.stream;
  bool get isAuthenticated => _isAuthenticated.value;

  AuthViewModel() {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    _isAuthenticated.add(await AuthService.isAuthenticated());
  }

  Future<void> handleAuth() async {
    if (_isAuthenticated.value) {
      await AuthService.logout();
      await checkAuthStatus();
    } else {
      _isAuthenticating.add(true); // ✅ On lance le loader
      try {
        await AuthService.authenticate();
        await checkAuthStatus();
      } catch (e) {
        print('Erreur auth : $e');
      } finally {
        _isAuthenticating.add(false); // ✅ On arrête le loader même en cas d'erreur
      }
    }
  }

  void dispose() {
    _isAuthenticated.close();
    _isAuthenticating.close();
  }
}
