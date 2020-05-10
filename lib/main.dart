import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgettestdemo/main_bloc.dart';
import 'package:widgettestdemo/main_event.dart';
import 'package:widgettestdemo/main_state.dart';
import 'package:widgettestdemo/model/create_account_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  MainBloc mainBloc;

  // Focus Nodes
  FocusNode _firstNameFocusNode = FocusNode();
  FocusNode _lastNameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

// Controllers
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    mainBloc = MainBloc();
    var firstNameTextField = TextFormField(
      key: const Key("key_fname"),
      decoration: InputDecoration(
        hintText: "First Name",
      ),
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.text,
      focusNode: _firstNameFocusNode,
      controller: _firstNameController,
      onFieldSubmitted: (term) {
        _fieldFocusChange(context, _firstNameFocusNode, _lastNameFocusNode);
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Please provide first name';
        }
        return null;
      },
    );

    var lastNameTextField = TextFormField(
      key: const Key("key_lname"),
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      focusNode: _lastNameFocusNode,
      controller: _lastNameController,
      onFieldSubmitted: (term) {
        _fieldFocusChange(context, _lastNameFocusNode, _emailFocusNode);
      },
      decoration: InputDecoration(
        hintText: "Last Name",
      ),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please provide last name';
        }
        return null;
      },
    );

    var emailTextField = TextFormField(
      key: const Key("key_email"),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(hintText: "Email"),
      focusNode: _emailFocusNode,
      controller: _emailController,
      onFieldSubmitted: (term) {
        _fieldFocusChange(context, _emailFocusNode, _passwordFocusNode);
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Please provide email';
        }
        return null;
      },
    );

    var passwordTextField = TextFormField(
      key: const Key("key_password"),
      keyboardType: TextInputType.emailAddress,
      obscureText: true,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(hintText: "Password"),
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please provide password';
        }
        return null;
      },
    );

    var createAccountButton = RaisedButton(
      key: const Key("button_create"),
      onPressed: () {
        if (_formKey.currentState.validate()) {
          CreateAccountData data = CreateAccountData();
          data.firstName = _firstNameController.text.trim();
          data.lastName = _lastNameController.text.trim();
          data.email = _emailController.text.trim().toLowerCase();
          data.password = _firstNameController.text;
          mainBloc.add(CreateAccountPressedEvent(data));
        }
      },
      child: Container(
        alignment: Alignment.center,
        child: Text(
          "Create Account",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        width: double.infinity,
      ),
    );
    return BlocListener<MainBloc, MainState>(
      listener: (context, state) {
        if (state is AccountCreatedState) {
          showSnackBar("Account created successfuly!");
        }
      },
      bloc: mainBloc,
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: SingleChildScrollView(
              child: Form(
                autovalidate: true,
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      firstNameTextField,
                      SizedBox(
                        height: 10,
                      ),
                      lastNameTextField,
                      SizedBox(
                        height: 10,
                      ),
                      emailTextField,
                      SizedBox(
                        height: 10,
                      ),
                      passwordTextField,
                      SizedBox(
                        height: 10,
                      ),
                      createAccountButton
                    ],
                  ),
                ),
              ),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          );
        },
        bloc: mainBloc,
      ),
    );
  }

  @override
  void dispose() {
    mainBloc.close();
    super.dispose();
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  showSnackBar(String text) {
    Scaffold.of(_formKey.currentContext).showSnackBar(SnackBar(
      content: Text((text)),
      duration: Duration(seconds: 4),
    ));
  }
}
