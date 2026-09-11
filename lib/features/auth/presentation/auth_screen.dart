import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (!_validateInput(email, password)) return;

    await _authenticate(
      () => FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
      isRegister: false,
    );
  }

  Future<void> _register() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (!_validateInput(email, password)) return;

    await _authenticate(
      () => FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ),
      isRegister: true,
    );
  }

  bool _validateInput(String email, String password) {
    if (email.isEmpty) {
      _showError('Bitte gib deine E-Mail-Adresse ein.');
      return false;
    }

    if (!email.contains('@') || !email.contains('.')) {
      _showError('Bitte gib eine gültige E-Mail-Adresse ein.');
      return false;
    }

    if (password.isEmpty) {
      _showError('Bitte gib dein Passwort ein.');
      return false;
    }

    if (password.length < 6) {
      _showError('Das Passwort muss mindestens 6 Zeichen lang sein.');
      return false;
    }

    return true;
  }

  Future<void> _authenticate(
    Future<UserCredential> Function() action, {
    required bool isRegister,
  }) async {
    setState(() {
      isLoading = true;
    });

    try {
      await action();
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;

      _showError(_getAuthErrorMessage(error.code, isRegister: isRegister));
    } catch (_) {
      if (!mounted) return;

      _showError('Etwas ist schiefgelaufen. Bitte versuche es später erneut.');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String _getAuthErrorMessage(String code, {required bool isRegister}) {
    switch (code) {
      case 'invalid-email':
        return 'Bitte gib eine gültige E-Mail-Adresse ein.';

      case 'email-already-in-use':
        return 'Für diese E-Mail-Adresse gibt es bereits ein Konto.';

      case 'weak-password':
        return 'Das Passwort ist zu unsicher. Bitte wähle ein stärkeres Passwort.';

      case 'user-not-found':
        return 'Für diese E-Mail-Adresse wurde kein Konto gefunden.';

      case 'wrong-password':
      case 'invalid-credential':
        return 'E-Mail-Adresse oder Passwort ist nicht korrekt.';

      case 'user-disabled':
        return 'Dieses Konto wurde deaktiviert.';

      case 'too-many-requests':
        return 'Zu viele Versuche. Bitte warte kurz und versuche es später erneut.';

      case 'network-request-failed':
        return 'Keine Internetverbindung. Bitte überprüfe deine Verbindung.';

      case 'operation-not-allowed':
        return isRegister
            ? 'Die Registrierung ist momentan nicht verfügbar.'
            : 'Die Anmeldung ist momentan nicht verfügbar.';

      default:
        return isRegister
            ? 'Die Registrierung ist fehlgeschlagen. Bitte versuche es erneut.'
            : 'Die Anmeldung ist fehlgeschlagen. Bitte versuche es erneut.';
    }
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anmelden'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'E-Mail',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Passwort',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            if (isLoading)
              const CircularProgressIndicator()
            else ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  child: const Text('Einloggen'),
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _register,
                  child: const Text('Registrieren'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
