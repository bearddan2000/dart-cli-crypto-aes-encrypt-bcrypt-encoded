import 'package:dbcrypt/dbcrypt.dart';
import 'package:dargon2/dargon2.dart';
import 'package:convert/convert.dart';
import 'dart:convert';
import 'package:encrypt/encrypt.dart';

final s = Salt.newSalt();
final key = Key.fromUtf8('my 32 length key................');
final iv = IV.fromLength(16);

encrypt(psw) {
  final encrypter = Encrypter(AES(key));
  final encrypted = encrypter.encrypt(psw, iv: iv);
  return encrypted.base64;
}


verify(psw1, psw2, hashed) {
  print("[VERIFY] $psw1\t$psw2");
  psw1 = encrypt(psw1);
  var isCorrect = new DBCrypt().checkpw(psw1, hashed);
  print("[VERIFY] $isCorrect");
}

hash(psw) {
  print("[HASH] plainPassword: $psw");
  psw = encrypt(psw);
  var hashed = new DBCrypt().hashpw(psw, new DBCrypt().gensalt());
  print("[HASH] hashedPassword: $hashed");
  return hashed;
}

main() async {
  String psw1 = "pass1234";
  String psw2 = "1234pass";
  String hash1 = await hash(psw1);
  String hash2 = await hash(psw2);
  verify(psw1, psw2, hash2);
  verify(psw1, psw1, hash1);
}
