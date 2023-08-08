import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../src/global_functions.dart';
import '../src/globals.dart';

class ProfilePage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfilePageState();
  }

}

class ProfilePageState extends State<ProfilePage> {

  var jsonResponse;
  String? accessToken = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: appBar(context, 'Perfil      '),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: floatActionButton(context),
      bottomNavigationBar: bottomApp(context),
      drawer: menuLateral(context),
      body: FutureBuilder(
        future: _getProfile(),
        builder: (context, snapshot) {

          if(snapshot.connectionState == ConnectionState.done) {

            return Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        const SizedBox(height: 20,),
                        Text('¡Bienvenido ' + jsonResponse['data']['name'] + '!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[800]),),
                        const SizedBox(height: 15,),
                        CircleAvatar(
                          // backgroundImage: NetworkImage('https://picsum.photos/id/237/200/300',),
                          radius: 60,
                          backgroundImage: NetworkImage(jsonResponse['data']['photo'],),
                        ),

                        const SizedBox(height: 20,),

                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Table(
                            columnWidths: const {
                              0: FixedColumnWidth(10.0),
                              1: FixedColumnWidth(100.0),
                            },
                            children: [
                              TableRow(children: [
                                const Text('Correo' + ':', style: TextStyle(fontSize: 18),),
                                Text(jsonResponse['data']['email'], style: const TextStyle(fontSize: 18),),
                              ]),
                              TableRow(children: [
                                const Text('Teléfono' + ':', style: TextStyle(fontSize: 18),),
                                Text(jsonResponse['data']['phone'], style: const TextStyle(fontSize: 18),),
                              ]),
                              // TableRow(children: [
                              //   const Text('Perfil' + ':', style: TextStyle(fontSize: 18),),
                              //   Text(jsonResponse['data']['perfil_inversionista'], style: const TextStyle(fontSize: 18),),
                              // ]),
                            ]
                          ),
                        ),

                        // _item('Creado en', jsonResponse['data']['created_at']),
                        // _item('Correo', jsonResponse['data']['email']),
                        // _item('Teléfono', jsonResponse['data']['phone']),
                        // _item('Perfil', jsonResponse['data']['perfil_inversionista']),

                      ],
                    ),
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     GestureDetector(
                    //       onTap: () => Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (Route<dynamic> route) => false),
                    //       child: Container(
                    //           decoration: BoxDecoration(
                    //               border: Border.all(
                    //                 color: Colors.blue[500]!,
                    //               ),
                    //               color: Colors.blue[500]!,
                    //               borderRadius: const BorderRadius.all(Radius.circular(10))
                    //           ),
                    //           child: const Padding(
                    //             padding: EdgeInsets.all(4.0),
                    //             child: Center(child: Text('Entendido', style: TextStyle(color: Colors.white, fontSize: 18),),),
                    //           )
                    //       ),
                    //     ),
                    //     const SizedBox(height: 35,),
                    //   ],
                    // ),
                  ],
                ),
              ),
            );
          }

          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }

          return const SizedBox.shrink();

        }
      ),
    );
  }

  _getProfile() async {

    try{
      accessToken = await prefs?.getString('lastaccesstoken');
    } catch(onError){
      accessToken = 'sin access token';
    }

    try{

      final response = await http.get(Uri.parse('http://143.198.128.13/api/profile/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
      );

      jsonResponse = jsonDecode(response.body);

    } catch(onerror){
      print('error: ' +  onerror.toString());
    }

  }

  _item(title, description){
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(flex: 1, child: Text(title + ':', style: TextStyle(fontSize: 18),),),
          const SizedBox(width: 14,),
          Flexible(flex: 3, child: Text(description, style: TextStyle(fontSize: 18),),),
        ],
      ),
    );
  }

}