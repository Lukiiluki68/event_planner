import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Rejestracja email/hasło
  static Future<void> register(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  /// Logowanie email/hasło
  static Future<bool> login(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user != null;
  }

  /// Logowanie przez Google
  static Future<UserCredential> signInWithGoogle() async {
    // 1. Poproś użytkownika o wybranie konta Google
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      // Użytkownik anulował logowanie
      throw Exception('Logowanie przez Google przerwane');
    }

    // 2. Pobierz token uwierzytelniający
    final googleAuth = await googleUser.authentication;

    // 3. Utwórz credential do Firebase
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // 4. Zaloguj w Firebase
    return await _auth.signInWithCredential(credential);
  }

  /// Wylogowanie
  static Future<void> signOut() async {
    // Najpierw wyloguj się z Google, żeby usunąć token
    await GoogleSignIn().signOut();
    // Następnie wyloguj z Firebase
    await _auth.signOut();
  }

  static User? get currentUser => _auth.currentUser;
}
