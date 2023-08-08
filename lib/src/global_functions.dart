import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_money/demo/calculator_demo.dart';
import 'package:open_money/user/video_playing.dart';
import 'package:open_money/src/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user/user_profile.dart';

Future<void> showMyDialog(string, context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Open Money'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(string),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Aceptar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

menuLateral(context) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        // UserAccountsDrawerHeader(
        //   accountName: Text('Open Money'),
        //   accountEmail: Text(''),
        //   decoration: BoxDecoration(
        //     color: Colors.blue[800],
        //   ),
        // ),
        SizedBox(
          height: 15,
        ),
        Image.asset(
          'assets/logo.png',
          height: 120,
        ),
        SizedBox(
          height: 15,
        ),
        ListTile(
          title: const Text("Inicio"),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => WelcomePage())),
        ),
        ListTile(
          title: const Text("Calculadora"),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CalculatorDemo())),
        ),
        ListTile(
          title: const Text("Perfil"),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ProfilePage())),
        ),
        ListTile(
          title: const Text("Videos"),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => VideoPlaying())),
        ),
        ListTile(
          title: const Text("Cerrar sesión"),
          onTap: () => _logout(context),
        ),
        const ListTile(
          title: Text(
            "Version 02.00.06",
            style: TextStyle(color: Colors.grey, fontSize: 10),
            textAlign: TextAlign.right,
          ),
        ),
        ListTile(
          onTap: () => _Confirmation(context),
          title: const Text(
            "Eliminar cuenta",
            style: TextStyle(color: Colors.red, fontSize: 8),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    ),
  );
}

floatActionButton(context) {
  return FloatingActionButton(
    backgroundColor: Colors.blue[500],
    child: const Icon(Icons.home),
    onPressed: () => Navigator.of(context)
        .pushNamedAndRemoveUntil('/welcome', (Route<dynamic> route) => false),
  );
}

bottomApp(context) {
  return BottomAppBar(
    shape: const CircularNotchedRectangle(),
    notchMargin: 4.0,
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ProfilePage())),
        ),
        IconButton(
          icon: const Icon(Icons.outbond_outlined),
          onPressed: () => _logout(context),
        )
      ],
    ),
  );
}

appBar(context, title) {
  return AppBar(
    title: Center(
        child: Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Text(
        title,
      ),
    )),
    backgroundColor: Colors.orange,
  );
}

_logout(context) async {
  late final prefs;
  String? accessToken = '';
  prefs = await SharedPreferences.getInstance();

  try {
    accessToken = await prefs?.getString('lastaccesstoken');
  } catch (onError) {
    accessToken = 'sin access token';
  }

  final response = await http.get(
    Uri.parse('http://143.198.128.13/api/logout/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken'
    },
  );

  switch (response.statusCode) {
    case 200:
      await prefs.remove('logged');
      await prefs.remove('lastaccesstoken');
      await prefs.remove('lastresponeGlobal');
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);

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
    case 401:
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text('Usuario no autentificado'),
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
              content: Text('El usuario y contraseña no válido'),
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
}

Future<void> _Confirmation(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('¿Eliminar cuenta?'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                  'Esta acción no puede ser revertida y tus datos serán eliminados. Aún así, podrás crear una cuenta siempre que quieras de nuevo.'),
            ],
          ),
        ),
        actions: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(
                    'Eliminar',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () => _deleteUser(context),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

_deleteUser(context) {
  // final response = await http.post(Uri.parse('http://143.198.128.13/api/register/'),
  //   headers: <String, String>{
  //     'Content-Type': 'application/json; charset=UTF-8',
  //     'Accept': 'application/json; charset=UTF-8',
  //   },
  //   body: jsonEncode(<String, String>{
  //     "name": _nameController.text,
  //     "email": _mailController.text,
  //     "password": _passwordController.text,
  //     "password_confirmation": _confirmationController.text,
  //     "phone": _phoneController.text
  //   }),
  // );
  showMyDialog('Usuario eliminado. Esperamos verte pronto', context)
      .whenComplete(() => Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false));
}
