import 'package:flutter/material.dart';

import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:amazon_cognito_identity_dart/sig_v4.dart';

import 'package:flutter_feedback_app/services/cognito.dart';
import 'package:flutter_feedback_app/models/user.dart';
import 'package:flutter_feedback_app/screens/login.dart';


class MemberOverviewScreen extends StatefulWidget {
  MemberOverviewScreen({Key key}) : super(key: key);

  @override
  _MemberOverviewScreenState createState() => _MemberOverviewScreenState();
}

class _MemberOverviewScreenState extends State<MemberOverviewScreen> {
  final _userService = UserService(userPool);
  CounterService _counterService;
  AwsSigV4Client _awsSigV4Client;
  User _user = User();
  Counter _counter = Counter(0);
  bool _isAuthenticated = false;

  void _incrementCounter() async {
    final counter = await _counterService.incrementCounter();
    setState(() {
      _counter = counter;
    });
  }

  Future<UserService> _getValues(BuildContext context) async {
    try {
      await _userService.init();
      _isAuthenticated = await _userService.checkAuthenticated();
      if (_isAuthenticated) {
        // get user attributes from cognito
        _user = await _userService.getCurrentUser();

        // get session credentials
        final credentials = await _userService.getCredentials();
        _awsSigV4Client = AwsSigV4Client(
            credentials.accessKeyId, credentials.secretAccessKey, _endpoint,
            region: _region, sessionToken: credentials.sessionToken);

        // get previous count
        _counterService = CounterService(_awsSigV4Client);
        _counter = await _counterService.getCounter();
      }
      return _userService;
    } on CognitoClientException catch (e) {
      if (e.code == 'NotAuthorizedException') {
        await _userService.signOut();
        Navigator.pop(context);
      }
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getValues(context),
        builder: (context, AsyncSnapshot<UserService> snapshot) {
          if (snapshot.hasData) {
            if (!_isAuthenticated) {
              return LoginScreen();
            }

            return Scaffold(
              appBar: AppBar(
                title: Text('Secure Counter'),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Welcome ${_user.name}!',
                      style: Theme.of(context).textTheme.display1,
                    ),
                    Divider(),
                    Text(
                      'You have pushed the button this many times:',
                    ),
                    Text(
                      '${_counter.count}',
                      style: Theme.of(context).textTheme.display1,
                    ),
                    Divider(),
                    Center(
                      child: InkWell(
                        child: Text(
                          'Logout',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        onTap: () {
                          _userService.signOut();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (snapshot.hasData) {
                    _incrementCounter();
                  }
                },
                tooltip: 'Increment',
                child: Icon(Icons.add),
              ),
            );
          }
          return Scaffold(
              appBar: AppBar(title: Text('Loading...')));
        });
  }
}