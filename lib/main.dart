import 'package:flutter/material.dart';
import 'package:open_money/auth/register.dart';
import 'package:open_money/src/globals.dart';
import 'package:open_money/src/welcome.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:open_money/src/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:open_money/user/perfil_page.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

late User currentUs = const User(success: false, accessToken: '');

void main() {

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: {
        '/home': (BuildContext context) => MyHomePage(),
        '/welcome': (BuildContext context) => WelcomePage(),
        '/register': (BuildContext context) => Register(),
        // '/perfil': (BuildContext context) => PerfilPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController _userController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String? loggedBefore;
  bool _obscure = true;
  late Future<User> futureUser;

  @override
  void initState(){
    super.initState();
    initialization();
  }

  void initialization() async {

    prefs = await SharedPreferences.getInstance();

    try {
      loggedBefore = await prefs?.getString('logged');
    } catch (onError){
      loggedBefore = 'no';
    }

    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    if(loggedBefore == 'yes') {
      return WelcomePage();
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                      ),
                    ),

                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[Colors.white, Colors.orange]),
                        ),
                      ),
                    ),

                  ],
                )),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.12,
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {});
                        },
                        child: Image.asset(
                          'assets/banner.jpeg',
                          width: 360,
                        )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                    ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: TextField(
                          autocorrect: false,
                          controller: _userController,
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            labelText: 'Correo',
                            labelStyle: TextStyle(color: Colors.black),
                            suffix: GestureDetector(
                                onTap: () {
                                  // _usernameController!.text = _usernameController!.text + '@hotmail.com';
                                },
                                child: const Icon(Icons.mail)),
                            // suffixIcon: IconButton(
                            //   color: Colors.black,
                            //   icon: const Icon(Icons.cancel),
                            //   onPressed: () => _usernameController!.clear(),
                            // ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                          textInputAction: TextInputAction.next,
                          // onEditingComplete: () {
                          //   _focusNode?.requestFocus();
                          // },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: TextField(
                          autocorrect: false,
                          autofocus: false,
                          controller: _passwordController,
                          obscureText: _obscure,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.none,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            labelText: 'Contraseña',
                            labelStyle: const TextStyle(color: Colors.black),
                            suffix: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscure = !_obscure;
                                  });
                                },
                                child: const Icon(
                                  Icons.remove_red_eye,
                                )),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                    ),
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width * 0.75,
                    //   child: const Align(
                    //     alignment: Alignment.topRight,
                    //     child: Text('Olvide mi contraseña'),
                    //   ),
                    // ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    GestureDetector(
                      onTap: () => futureUser = fetchUser(_userController.text,
                          _passwordController.text, context),
                      child: Container(
                          margin: const EdgeInsets.all(10.0),
                          height: 45,
                          width: MediaQuery.of(context).size.width * 0.75,
                          decoration: const BoxDecoration(
                              color: Colors.orange,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          child: const Center(
                              child: Text(
                            'Ingresar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ))),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Register())),
                      child: Container(
                          margin: const EdgeInsets.all(10.0),
                          height: 45,
                          width: MediaQuery.of(context).size.width * 0.75,
                          decoration: const BoxDecoration(
                              color: Colors.orange,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          child: const Center(
                              child: Text(
                            'Crear cuenta',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ))),
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async => await launchUrl(Uri.parse('http://www.openmx.online/pol%C3%ADtica-de-privacidad'), mode: LaunchMode.externalNonBrowserApplication),
                    child: const Text(
                      'Conoce nuestras políticas de seguridad aquí',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                        color: Colors.blue
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                ],
              ),
            )
          ],
        ),
      );
    }
  }

  Future<User> fetchUser(String user, String password, context) async {

    final response = await http.post(Uri.parse('http://143.198.128.13/api/login/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": user,
        "password": password
      }),
    );

    currentUs = User.fromJson(jsonDecode(response.body));

    switch(response.statusCode){
      case 200:

        await prefs?.setString('logged', 'yes');
        await prefs?.setString('lastaccesstoken', currentUs.accessToken);
        await prefs?.setString('lastresponeGlobal', response.body);

        Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (Route<dynamic> route) => false);

        break;
      case 422:
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text('Usuario o contraseña incorrecto'),
                actions: [
                  ElevatedButton(
                    child: Text("Ok"),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              );
            });
        break;
      default:
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Error " + response.statusCode.toString()),
                content: Text('El usuario y contraseña no válido. Code: ' + response.body.toString()),
                actions: [
                  ElevatedButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
        break;
    }

    return User.fromJson(jsonDecode(response.body));

  }

}

