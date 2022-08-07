import 'package:auth_app_1/ui/providers/loading_provider.dart';
import 'package:auth_app_1/utils/labels.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final authViewModelProvider = ChangeNotifierProvider(
  (ref) => AuthViewModel(ref.read),
);

final userProvider = StreamProvider<User?>(
  (ref) => ref.read(authViewModelProvider).userStream,
);

class AuthViewModel extends ChangeNotifier {
  final Reader _reader;
  AuthViewModel(this._reader);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _auth.currentUser;

  Stream<User?> get userStream => _auth.authStateChanges();

  String _email = '';
  String get email => _email;
  set email(String email) {
    _email = email;
    notifyListeners();
  }

  String _password = '';
  String get password => _password;
  set password(String password) {
    _password = password;
    notifyListeners();
  }

  String _confirmPassord = '';
  String get confirmPassord => _confirmPassord;
  set confirmPassord(String confirmPassord) {
    _confirmPassord = confirmPassord;
    notifyListeners();
  }

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;
  set obscurePassword(bool obscureText) {
    _obscurePassword = obscureText;
    notifyListeners();
  }

  bool _obscureConfirmPassword = true;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  set obscureConfirmPassword(bool obscureConfirmPassword) {
    _obscureConfirmPassword = obscureConfirmPassword;
    notifyListeners();
  }

  String? emailValidate(String value) {
    const String format =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    return !RegExp(format).hasMatch(value) ? Labels.enterValidEmail : null;
  }

  Future<void> login() async {
    _loading.start();
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _loading.end();
    } on FirebaseAuthException catch (e) {
      print(e.code);
      _loading.stop();

      if (e.code == "wrong-password") {
        return Future.error(Labels.wrongPasswordPlease);
      } else if (e.code == "user-not-found") {
        return Future.error(Labels.userNotFound);
      } else {
        return Future.error(e.message ?? "");
      }
    } catch (e) {
      _loading.stop();

      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> register() async {
    _loading.start();
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      sendEmail();
      _loading.end();
    } on FirebaseAuthException catch (e) {
      _loading.stop();

      if (e.code == "weak-password") {
        return Future.error(Labels.weakPassordPlease);
      } else {
        return Future.error(e.message ?? "");
      }
    } catch (e) {
      _loading.stop();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> reload() async {
    await _auth.currentUser!.reload();
    notifyListeners();
  }

  Future<void> sendEmail() async {
    try {
      await _auth.currentUser!.sendEmailVerification();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void streamCheck({required VoidCallback onDone}) {
    final stream = Stream.periodic(const Duration(seconds: 2), (t) => t);
    stream.listen((_) async {
      await reload();
      if (_auth.currentUser!.emailVerified) {
        onDone();
      }
    });
  }

  String _phone = '';
  String get phone => _phone;
  set phone(String phone) {
    _phone = phone;
    resendToken = null;
    notifyListeners();
  }

  String? verficationId;

  int? resendToken;

  Loading get _loading => _reader(loadingProvider);

  final formatter = MaskTextInputFormatter(
      mask: '# - # - # - # - # - #', filter: {"#": RegExp(r'[0-9]')});

  late Stream<int> stream;

  Stream<int> get _stream => Stream.periodic(
        const Duration(seconds: 1),
        (i) => 30 - i,
      );

  void sendOtp(
      {required VoidCallback onCodeSent,
      required Function(String) onMessage,
      required Function(String) onError,
      required VoidCallback onCompleted}) {
    try {
      _loading.start();
      _auth.verifyPhoneNumber(
        forceResendingToken: resendToken,
        phoneNumber: "+91$phone",
        verificationCompleted: (phoneAuthCredential) async {
          _loading.start();
          try {
            await _auth.signInWithCredential(phoneAuthCredential);
            onCompleted();
          } on FirebaseAuthException catch (e) {
            onError(e.message ?? e.code);
          }
          _loading.stop();
        },
        verificationFailed: (error) {
          debugPrint("$error");
          _loading.stop();
          onError(error.message ?? error.code);
        },
        codeSent: (id, forceResendingToken) {
          verficationId = id;
          if (resendToken != null) {
            onMessage("Code resent!");
            notifyListeners();
          }
          stream = _stream;
          resendToken = forceResendingToken;
          _loading.stop();
          onCodeSent();
        },
        // timeout: const Duration(seconds: 0),
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } catch (e) {
      onError("Something error!");
    }
  }

  Future<void> validatePhone(String code) async {
    _loading.start();
    try {
      final creds = PhoneAuthProvider.credential(
          verificationId: verficationId!, smsCode: code);
      await _auth.signInWithCredential(creds);
      _loading.end();
    } on FirebaseAuthException catch (e) {
      _loading.stop();

      return Future.error(e.message ?? e.code);
    }
  }
}
