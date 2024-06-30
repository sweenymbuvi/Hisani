import 'package:local_auth/local_auth.dart';

class LocalAuth {
  static final _auth = LocalAuthentication();

  static Future<bool> _canAuthenticate() async {
    bool canCheckBiometrics = await _auth.canCheckBiometrics;
    bool isDeviceSupported = await _auth.isDeviceSupported();
    return canCheckBiometrics || isDeviceSupported;
  }

  static Future<bool> authenticate() async {
    try {
      if (!await _canAuthenticate()) return false;

      return await _auth.authenticate(
        localizedReason: 'Please authenticate to sign in',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      print('Error authenticating: $e');
      return false;
    }
  }
}
