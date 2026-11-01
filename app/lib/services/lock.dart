import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

const _storage = FlutterSecureStorage();
const _rounds = 20000;

List<int> _hash(String pin, List<int> salt) {
  var h = <int>[...salt, ...utf8.encode(pin)];
  for (var i = 0; i < _rounds; i++) {
    h = sha256.convert(h).bytes;
  }
  return h;
}

Future<void> savePin(String pin) async {
  final r = Random.secure();
  final salt = List<int>.generate(16, (_) => r.nextInt(256));
  await _storage.write(key: 'pin_salt', value: base64.encode(salt));
  await _storage.write(key: 'pin_hash', value: base64.encode(_hash(pin, salt)));
}

Future<bool> verifyPin(String pin) async {
  final salt = await _storage.read(key: 'pin_salt');
  final hash = await _storage.read(key: 'pin_hash');
  if (salt == null || hash == null) return false;
  return base64.encode(_hash(pin, base64.decode(salt))) == hash;
}

Future<void> clearPin() async {
  await _storage.delete(key: 'pin_salt');
  await _storage.delete(key: 'pin_hash');
}

final _auth = LocalAuthentication();

Future<bool> biometricsAvailable() async {
  try {
    return await _auth.isDeviceSupported() && (await _auth.getAvailableBiometrics()).isNotEmpty;
  } catch (_) {
    return false;
  }
}

Future<bool> biometricUnlock(String reason) async {
  try {
    return await _auth.authenticate(localizedReason: reason, biometricOnly: true);
  } catch (_) {
    return false;
  }
}
