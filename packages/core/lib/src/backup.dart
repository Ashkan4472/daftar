import 'dart:io' show gzip;
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

/// Wrong password, damaged file, or not a Daftar backup.
class BackupError implements Exception {
  BackupError(this.message);
  final String message;
  @override
  String toString() => 'BackupError: $message';
}

const _magic = [0x44, 0x41, 0x46, 0x54, 0x41, 0x52, 0x01, 0x0A]; // "DAFTAR\x01\n"
const _memoryKiB = 19456;
const _iterations = 2;
const _headerLen = 8 + 4 + 4 + 16 + 12;

Uint8List _randomBytes(int n) {
  final r = Random.secure();
  return Uint8List.fromList([for (var i = 0; i < n; i++) r.nextInt(256)]);
}

Future<SecretKey> _key(String password, List<int> salt, int memory, int iterations) =>
    Argon2id(memory: memory, parallelism: 1, iterations: iterations, hashLength: 32)
        .deriveKeyFromPassword(password: password, nonce: salt);

/// gzip + AES-256-GCM, key from Argon2id.
///
/// File: magic(8) | memoryKiB u32 | iterations u32 | salt(16) | nonce(12) | ciphertext | tag(16).
/// The header is authenticated, so changing it breaks decryption.
Future<Uint8List> encryptBackup(Uint8List plain, String password) async {
  final salt = _randomBytes(16), nonce = _randomBytes(12);
  final header = BytesBuilder()
    ..add(_magic)
    ..add((ByteData(4)..setUint32(0, _memoryKiB)).buffer.asUint8List())
    ..add((ByteData(4)..setUint32(0, _iterations)).buffer.asUint8List())
    ..add(salt)
    ..add(nonce);
  final head = header.toBytes();
  final key = await _key(password, salt, _memoryKiB, _iterations);
  final box = await AesGcm.with256bits().encrypt(gzip.encode(plain), secretKey: key, nonce: nonce, aad: head);
  return (BytesBuilder()
        ..add(head)
        ..add(box.cipherText)
        ..add(box.mac.bytes))
      .toBytes();
}

Future<Uint8List> decryptBackup(Uint8List file, String password) async {
  if (file.length < _headerLen + 16 || !_eq(file.sublist(0, 8), _magic)) {
    throw BackupError('Not a Daftar backup file');
  }
  final bd = ByteData.sublistView(file, 8, 16);
  final memory = bd.getUint32(0), iterations = bd.getUint32(4);
  if (memory > 1 << 20 || iterations > 20) throw BackupError('Unsupported backup parameters');
  final salt = file.sublist(16, 32), nonce = file.sublist(32, 44);
  final head = file.sublist(0, _headerLen);
  final key = await _key(password, salt, memory, iterations);
  try {
    final plain = await AesGcm.with256bits().decrypt(
      SecretBox(file.sublist(_headerLen, file.length - 16), nonce: nonce, mac: Mac(file.sublist(file.length - 16))),
      secretKey: key,
      aad: head,
    );
    return Uint8List.fromList(gzip.decode(plain));
  } on SecretBoxAuthenticationError {
    throw BackupError('Wrong password or damaged file');
  }
}

bool _eq(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
