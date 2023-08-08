import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../src/globals.dart';
import '../src/perfil_model.dart';

class ResponsePage extends StatefulWidget {
  Perfil request;

  ResponsePage(this.request);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ResponsePageState();
  }
}

class ResponsePageState extends State<ResponsePage> {

  String? accessToken = '';

  _getData() async {
    final response;
    if (accessToken == '') {
      try {
        accessToken = await prefs?.getString('lastaccesstoken');
      } catch (onError) {
        accessToken = 'sin access token';
      }

      response = await http.post(
        Uri.parse('http://143.198.128.13/api/investor_profile/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode(<String, dynamic>{
          "asesor": widget.request.asesor,
          "edad": widget.request.optionEdad,
          "porcentaje_patrimonio": widget.request.optionTwo,
          "expectativa_ingresos": widget.request.optionThree,
          "fondo_reservas": widget.request.optionFour,
          "tiempo_mantener_inversiones": widget.request.optionFive,
          "retiro_inversion": widget.request.optionSix,
          "objetivo_inversion": widget.request.optionSeven,
          "experiencia_inversionista": widget.request.optionEight,
          "fondos_mutuos": widget.request.optionNine,
          "bonos": widget.request.optionTen,
          "acciones": widget.request.optionEleven,
          "aumentar_tasa_rendimiento": widget.request.optionTwelve,
          "inversion_disminuyo": widget.request.optionThirteen,
          "pensionarte_riesgo_enfermedad_muerte": widget.request.optionFourteen,
          "preparando_retiro": widget.request.optionFifteen,
          "familia_protegida": widget.request.optionSixteen,
          "ingresos_afectados_fallecer": widget.request.optionSeventeen,
          "politica_privacidad": '56'
        }),
      );

      print('*********TOTAL RESPONSE1*****');
      print(jsonEncode(<String, dynamic>{
        "asesor": widget.request.asesor,
        "edad": widget.request.optionEdad,
        "porcentaje_patrimonio": widget.request.optionTwo,
        "expectativa_ingresos": widget.request.optionThree,
        "fondo_reservas": widget.request.optionFour,
        "tiempo_mantener_inversiones": widget.request.optionFive,
        "retiro_inversion": widget.request.optionSix,
        "objetivo_inversion": widget.request.optionSeven,
        "experiencia_inversionista": widget.request.optionEight,
        "fondos_mutuos": widget.request.optionNine,
        "bonos": widget.request.optionTen,
        "acciones": widget.request.optionEleven,
        "aumentar_tasa_rendimiento": widget.request.optionTwelve,
        "inversion_disminuyo": widget.request.optionThirteen,
        "pensionarte_riesgo_enfermedad_muerte": widget.request.optionFourteen,
        "preparando_retiro": widget.request.optionFifteen,
        "familia_protegida": widget.request.optionSixteen,
        "ingresos_afectados_fallecer": widget.request.optionSeventeen,
        "politica_privacidad": '56'
      }));

    } else {
      response = await http.post(
        Uri.parse('http://143.198.128.13/api/investor_profile/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode(<String, dynamic>{
          "asesor": widget.request.asesor,
          "edad": widget.request.optionEdad,
          "porcentaje_patrimonio": widget.request.optionTwo,
          "expectativa_ingresos": widget.request.optionThree,
          "fondo_reservas": widget.request.optionFour,
          "tiempo_mantener_inversiones": widget.request.optionFive,
          "retiro_inversion": widget.request.optionSix,
          "objetivo_inversion": widget.request.optionSeven,
          "experiencia_inversionista": widget.request.optionEight,
          "fondos_mutuos": widget.request.optionNine,
          "bonos": widget.request.optionTen,
          "acciones": widget.request.optionEleven,
          "aumentar_tasa_rendimiento": widget.request.optionTwelve,
          "inversion_disminuyo": widget.request.optionThirteen,
          "pensionarte_riesgo_enfermedad_muerte": widget.request.optionFourteen,
          "preparando_retiro": widget.request.optionFifteen,
          "familia_protegida": widget.request.optionSixteen,
          "ingresos_afectados_fallecer": widget.request.optionSeventeen,
          "politica_privacidad": '56'
        }),
      );
    }

    print('*********TOTAL RESPONSE1*****');
    print(jsonEncode(<String, dynamic>{
      "asesor": widget.request.asesor,
      "edad": widget.request.optionEdad,
      "porcentaje_patrimonio": widget.request.optionTwo,
      "expectativa_ingresos": widget.request.optionThree,
      "fondo_reservas": widget.request.optionFour,
      "tiempo_mantener_inversiones": widget.request.optionFive,
      "retiro_inversion": widget.request.optionSix,
      "objetivo_inversion": widget.request.optionSeven,
      "experiencia_inversionista": widget.request.optionEight,
      "fondos_mutuos": widget.request.optionNine,
      "bonos": widget.request.optionTen,
      "acciones": widget.request.optionEleven,
      "aumentar_tasa_rendimiento": widget.request.optionTwelve,
      "inversion_disminuyo": widget.request.optionThirteen,
      "pensionarte_riesgo_enfermedad_muerte": widget.request.optionFourteen,
      "preparando_retiro": widget.request.optionFifteen,
      "familia_protegida": widget.request.optionSixteen,
      "ingresos_afectados_fallecer": widget.request.optionSeventeen,
      "politica_privacidad": '56'
    }));


    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              dynamic responseTotal = jsonDecode(snapshot.data.toString());

              print(responseTotal);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.80,
                    child: Column(
                      children: [
                        Text(
                          'Tu perfil es: ',
                          style:
                              TextStyle(fontSize: 24, color: Colors.blue[800]),
                        ),
                        Text(
                          responseTotal['data']['perfil_inversionista'],
                          style: TextStyle(
                              fontSize: 24, color: Colors.yellow[800]),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(responseTotal['data']
                        ['perfil_inversionista_descripcion']),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    // child: Image.network('https://opencoach.com.mx/wp-content/uploads/2019/08/graficaperfil_moderadook-1024x576.png'),
                    child: Image.network(responseTotal['data']['grafica']),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                        '/welcome', (Route<dynamic> route) => false),
                    child: Container(
                        margin: const EdgeInsets.all(10.0),
                        height: 45,
                        width: MediaQuery.of(context).size.width * 0.95,
                        decoration: const BoxDecoration(
                            color: Colors.orange,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        child: Center(
                            child: Text(
                          'ENTENDIDO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ))),
                  ),
                ],
              );
            }

            return SizedBox.shrink();
          }),
    );
  }

}
