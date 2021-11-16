import 'package:flutter/material.dart';

import '../../components/components.dart';

import 'login_presenter.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;
  LoginPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Header(),
          Headline1(
            title: 'Login',
          ),
          Padding(
            padding: EdgeInsets.all(32.0),
            child: Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      icon: Icon(
                        Icons.email,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: presenter.validateEmail,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 32.0, top: 8),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        icon: Icon(
                          Icons.lock,
                          color: Theme.of(context).primaryColorLight,
                        ),
                      ),
                      obscureText: true,
                      onChanged: presenter.validatePassword,
                    ),
                  ),
                  RaisedButton(
                    onPressed: null,
                    child: Text('Entrar'),
                  ),
                  FlatButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.person),
                    label: Text('Criar Conta'),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
