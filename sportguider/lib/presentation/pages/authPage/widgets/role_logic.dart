import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sportguider/data/models/account_model.dart';
import 'package:sportguider/domain/entities/account_entity.dart';
import 'package:sportguider/domain/entities/coach_entity.dart';
import 'package:sportguider/domain/entities/user_entity.dart';
import 'package:sportguider/firebase_service.dart';
import 'package:sportguider/routes/router.gr.dart';

Future<void> roleLogic(
  DatabaseReference dbRef,
  String role,
  AccountEntity Function(AccountModel) entityFactory,
  String email,
  String password,
  dynamic context,
  dynamic _errorMes,
) async {
  DatabaseEvent event = await dbRef.once();
  Map? data = event.snapshot.value as Map?;

  bool userFound = false;

  if (data != null) {
    for (var entry in data.entries) {
      Map? userData = entry.value as Map?;
      if (userData != null && userData['email'] == email) {
        userFound = true;
        break;
      }
    }
  }

  if (!userFound) {
    if (role == 'user') {
      _errorMes =
          'Такого пользователя не существует, возможно вы зарегестрированы как тренер';
    } else {
      _errorMes =
          'Такого пользователя не существует, возможно вы зарегестрированы как спортсмен';
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_errorMes)));
    return;
  }

  final loginResult = await FirebaseService.onLogin(
    email: email,
    password: password,
  );

  if (loginResult!.isSuccess) {
    context.router.replace(
      UserProfileRoute(
        account: entityFactory(
          AccountModel.fromFirebaseUser(loginResult!.credential!.user),
        ),
      ),
    );
  } else {
    _errorMes = loginResult.errorMes;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_errorMes)));
  }
}
