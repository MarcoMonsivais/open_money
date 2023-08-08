import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_money/src/global_functions.dart';
import 'package:open_money/src/user_model.dart';
import 'package:open_money/user/perfil_page.dart';

import '../src/globals.dart';

late User currentUs = const User(success: false, accessToken: '');

class Register extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RegisterState();
  }
}

class RegisterState extends State<Register> {

  TextEditingController _nameController = TextEditingController();
  TextEditingController _mailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmationController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  // SharedPreferences? prefs;

  bool isChecked = false;
  bool _obscure = true;
  bool _obscureConfirmation = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            SizedBox(height: MediaQuery.of(context).size.height * 0.07,),
            const Center(child: Text('Registrate con nosotros', style: TextStyle(fontSize: 27),),),

            SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
            SizedBox(width: MediaQuery.of(context).size.width * 0.75, child: Text('Nombre completo', textAlign: TextAlign.left,)),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                height: 50,
                child: TextField(
                  autocorrect: false,
                  controller: _nameController,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    labelStyle: TextStyle(
                        color: Colors.black
                    ),
                  ),
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                ),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
            SizedBox(width: MediaQuery.of(context).size.width * 0.75, child: Text('Correo eléctronico', textAlign: TextAlign.left,)),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                height: 50,
                child: TextField(
                  autocorrect: false,
                  controller: _mailController,
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    labelStyle: TextStyle(
                        color: Colors.black
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.next,
                ),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
            SizedBox(width: MediaQuery.of(context).size.width * 0.75, child: Text('Teléfono', textAlign: TextAlign.left,)),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                height: 50,
                child: TextField(
                  autocorrect: false,
                  controller: _phoneController,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    labelStyle: TextStyle(
                        color: Colors.black
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.next,
                ),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
            SizedBox(width: MediaQuery.of(context).size.width * 0.75, child: Text('Contraseña', textAlign: TextAlign.left,)),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                height: 50,
                child: TextField(
                  autocorrect: false,
                  controller: _passwordController,
                  obscureText: _obscure,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    labelStyle: const TextStyle(
                        color: Colors.black
                    ),
                    suffix: GestureDetector(
                        onTap: (){
                          setState(() {
                            _obscure = !_obscure;
                          });
                        },
                        child: Icon(Icons.remove_red_eye,)),
                  ),
                ),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
            SizedBox(width: MediaQuery.of(context).size.width * 0.75, child: Text('Confirmación de contraseña', textAlign: TextAlign.left,)),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                height: 50,
                child: TextField(
                  autocorrect: false,
                  controller: _confirmationController,
                  obscureText: _obscureConfirmation,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    labelStyle: const TextStyle(
                        color: Colors.black
                    ),
                    suffix: GestureDetector(
                        onTap: (){
                          setState(() {
                            _obscureConfirmation = !_obscureConfirmation;
                          });
                        },
                        child: const Icon(Icons.remove_red_eye,)),
                  ),
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 15),
              width: MediaQuery.of(context).size.width * 0.75,
              child: Row(
                children: [
                  Checkbox(
                    checkColor: Colors.black,
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  const Expanded(
                      child: Text(
                          'Estoy de acuerdo en enviar mi información de acuerdo al aviso de privacidad plasmado en este medio.'))
                ],
              ),
            ),

            GestureDetector(
              onTap: () => _register(),
              child: Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.75,
                  decoration: const BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.all(Radius.circular(5.0))
                  ),
                  child: const Center(child: Text('Registrarse', style: TextStyle(color: Colors.white, fontSize: 25,),))
              ),
            ),

          ],),
      )
    );
  }

  _register() async {

    if(_nameController.text.isNotEmpty&&_mailController.text.isNotEmpty&&_passwordController.text.isNotEmpty&&_confirmationController.text.isNotEmpty&&_phoneController.text.isNotEmpty&&isChecked) {
      final response = await http.post(
        Uri.parse('http://143.198.128.13/api/register/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "name": _nameController.text,
          "email": _mailController.text,
          "password": _passwordController.text,
          "password_confirmation": _confirmationController.text,
          "phone": _phoneController.text
        }),
      );

      final jsonResponse = jsonDecode(response.body);
      currentUs = User.fromJson(jsonDecode(response.body));

      switch (response.statusCode) {
        case 200:
          await prefs?.setString('logged', 'yes');
          await prefs?.setString('lastaccesstoken', currentUs.accessToken);
          await prefs?.setString('lastresponeGlobal', response.body);

          await prefs?.setString('name', _nameController.text);
          await prefs?.setString('mail', _mailController.text);
          await prefs?.setString('phone', _phoneController.text);

          Navigator.of(context).pushNamedAndRemoveUntil(
              '/welcome', (Route<dynamic> route) => false);
          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => PerfilPage(_nameController.text, _mailController.text, _phoneController.text)));

          break;
        case 422:
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Error"),
                  content: Text(jsonResponse['message']),
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
        default:
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Error " + response.statusCode.toString()),
                  content: Text('El usuario y contraseña no válido. Code: ' +
                      response.body.toString()),
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
    } else{
      showMyDialog('Oops, parece que hace falta llenar un campo', context);
    }
  }

}



