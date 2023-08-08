import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_money/user/response_perfil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../src/global_functions.dart';
import '../src/globals.dart';
import '../src/perfil_model.dart';
import 'package:http/http.dart' as http;

class PerfilPage extends StatefulWidget {
  final String? name, mail, phone;

  PerfilPage(this.name, this.mail, this.phone);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PerfilPageState();
  }
}

class PerfilPageState extends State<PerfilPage> {
  PageController _pvController = PageController();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _nameasessorController = TextEditingController();

  String optionEdad = '',
      optionTwo = '',
      optionThree = '',
      optionFour = '',
      optionFive = '',
      optionSix = '',
      optionSeven = '',
      optionEight = '',
      optionNine = '',
      optionTen = '',
      optionEleven = '',
      optionTwelve = '',
      optionThirteen = '',
      optionFourteen = '',
      optionFifteen = '',
      optionSixteen = '',
      optionSeventeen = '';
  String backoptionEdad = '',
      backoptionTwo = '',
      backoptionThree = '',
      backoptionFour = '',
      backoptionFive = '',
      backoptionSix = '',
      backoptionSeven = '',
      backoptionEight = '',
      backoptionNine = '',
      backoptionTen = '',
      backoptionEleven = '',
      backoptionTwelve = '',
      backoptionThirteen = '',
      backoptionFourteen = '',
      backoptionFifteen = '',
      backoptionSixteen = '',
      backoptionSeventeen = '';

  String labelPage = 'Siguiente';
  bool isChecked = false;

  String? responseGlobal = '';
  String? accessToken = '';
  String name = '';
  var jsonResponse;
  bool showresponse = false;

  double percent = 0.055;

  _getQuestions() async {
    try {
      accessToken = await prefs?.getString('lastaccesstoken');
      responseGlobal = await prefs?.getString('lastresponeGlobal');
      name = json.decode(responseGlobal!)['data']['name'];
      if (name.isEmpty) {
        setState(() {
          name;
        });
      }
    } catch (onError) {
      accessToken = 'sin access token';
      name = '-';
    }

    try {
      final response = await http.get(
        Uri.parse('http://143.198.128.13/api/questions/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
      );

      setState(() {
        jsonResponse = jsonDecode(response.body);
        showresponse = true;
      });
    } catch (onerror) {
      print('error: ' + onerror.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getQuestions();
  }

  @override
  Widget build(BuildContext context) {
    if (showresponse) {
      return Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 30),
                  height: 35,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: const Center(
                      child: Text(
                    'CUESTIONARIO PERFIL DE INVERSIONISTA',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                    ),
                  ))),
              Expanded(
                child: PageView(
                  controller: _pvController,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          _preItem('Nombre', _nameController, widget.name!),
                          _preItem('Correo Eléctronico', _emailController, widget.mail!),
                          _preItem('Teléfono', _phoneController, widget.phone!),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.88,
                              child: const Text(
                                'Nombre de tu asesor',
                                textAlign: TextAlign.left,
                              )),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.88,
                              height: 40,
                              child: TextField(
                                autocorrect: false,
                                controller: _nameasessorController,
                                keyboardType: TextInputType.text,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                  labelStyle: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          _modelQA(
                              jsonResponse['data'][1]['question'],
                              [
                                jsonResponse['data'][1]['responses'][0]
                                    ['response'],
                                jsonResponse['data'][1]['responses'][1]
                                    ['response'],
                                jsonResponse['data'][1]['responses'][2]
                                    ['response'],
                                jsonResponse['data'][1]['responses'][3]
                                    ['response']
                              ],
                              optionEdad,
                              1),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          _modelQA(
                              jsonResponse['data'][2]['question'],
                              [
                                jsonResponse['data'][2]['responses'][0]
                                    ['response'],
                                jsonResponse['data'][2]['responses'][1]
                                    ['response'],
                                jsonResponse['data'][2]['responses'][2]
                                    ['response'],
                              ],
                              optionTwo,
                              2),
                          _modelQA(
                              jsonResponse['data'][3]['question'],
                              [
                                jsonResponse['data'][3]['responses'][0]
                                    ['response'],
                                jsonResponse['data'][3]['responses'][1]
                                    ['response'],
                                jsonResponse['data'][3]['responses'][2]
                                    ['response'],
                              ],
                              optionThree,
                              3),
                          _modelQA(
                              jsonResponse['data'][4]['question'],
                              [
                                jsonResponse['data'][4]['responses'][0]
                                    ['response'],
                                jsonResponse['data'][4]['responses'][1]
                                    ['response']
                              ],
                              optionFour,
                              4),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          _modelQA(
                              jsonResponse['data'][5]['question'],
                              [
                                jsonResponse['data'][5]['responses'][0]
                                    ['response'],
                                jsonResponse['data'][5]['responses'][1]
                                    ['response'],
                                jsonResponse['data'][5]['responses'][2]
                                    ['response'],
                                jsonResponse['data'][5]['responses'][3]
                                    ['response'],
                              ],
                              optionFive,
                              5),
                          _modelQA(
                              jsonResponse['data'][6]['question'],
                              [
                                jsonResponse['data'][6]['responses'][0]
                                    ['response'],
                                jsonResponse['data'][6]['responses'][1]
                                    ['response'],
                                jsonResponse['data'][6]['responses'][2]
                                    ['response'],
                                jsonResponse['data'][6]['responses'][3]
                                    ['response'],
                              ],
                              optionSix,
                              6),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          _modelQA(
                              jsonResponse['data'][7]['question'],
                              [
                                jsonResponse['data'][7]['responses'][0]
                                    ['response'],
                                jsonResponse['data'][7]['responses'][1]
                                    ['response'],
                                jsonResponse['data'][7]['responses'][2]
                                    ['response'],
                                jsonResponse['data'][7]['responses'][3]
                                    ['response'],
                              ],
                              optionSeven,
                              7),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          _modelQA(
                              jsonResponse['data'][8]['question'],
                              [
                                jsonResponse['data'][8]['responses'][0]
                                    ['response'],
                                jsonResponse['data'][8]['responses'][1]
                                    ['response'],
                                jsonResponse['data'][8]['responses'][2]
                                    ['response'],
                              ],
                              optionEight,
                              8),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.88,
                              child: const Text(
                                  'Si usted tuviese que describir su experiencia en los siguientes productos de inversión (Ninguna, Limitada, Moderada o Extensa) cuál seria para:')),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          _modelQA(
                              jsonResponse['data'][9]['question'],
                              [
                                jsonResponse['data'][9]['responses'][0]
                                    ['response'],
                                jsonResponse['data'][9]['responses'][1]
                                    ['response'],
                                jsonResponse['data'][9]['responses'][2]
                                    ['response'],
                                jsonResponse['data'][9]['responses'][3]
                                    ['response'],
                              ],
                              optionNine,
                              9),
                          _modelQA(
                              jsonResponse['data'][10]['question'],
                              [
                                jsonResponse['data'][10]['responses'][0]
                                    ['response'],
                                jsonResponse['data'][10]['responses'][1]
                                    ['response'],
                                jsonResponse['data'][10]['responses'][2]
                                    ['response'],
                                jsonResponse['data'][10]['responses'][3]
                                    ['response'],
                              ],
                              optionTen,
                              10),
                          _modelQA(
                              jsonResponse['data'][11]['question'],
                              [
                                jsonResponse['data'][11]['responses'][0]
                                    ['response'],
                                jsonResponse['data'][11]['responses'][1]
                                    ['response'],
                                jsonResponse['data'][11]['responses'][2]
                                    ['response'],
                                jsonResponse['data'][11]['responses'][3]
                                    ['response'],
                              ],
                              optionEleven,
                              11),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          _modelQA(
                              jsonResponse['data'][12]['question'],
                              [
                                jsonResponse['data'][12]['responses'][0]
                                    ['response'],
                                jsonResponse['data'][12]['responses'][1]
                                    ['response'],
                                jsonResponse['data'][12]['responses'][2]
                                    ['response'],
                              ],
                              optionTwelve,
                              12),
                          _modelQA(
                              jsonResponse['data'][13]['question'],
                              [
                                jsonResponse['data'][13]['responses'][0]
                                    ['response'],
                                jsonResponse['data'][13]['responses'][1]
                                    ['response'],
                                jsonResponse['data'][13]['responses'][2]
                                    ['response'],
                                jsonResponse['data'][13]['responses'][3]
                                    ['response'],
                              ],
                              optionThirteen,
                              13),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          _modelQA(
                              jsonResponse['data'][14]['question'],
                              [
                                jsonResponse['data'][14]['responses'][0]
                                    ['response'],
                                jsonResponse['data'][14]['responses'][1]
                                    ['response'],
                                jsonResponse['data'][14]['responses'][2]
                                    ['response'],
                              ],
                              optionFourteen,
                              14),
                          _modelQA(
                              jsonResponse['data'][15]['question'],
                              [
                                jsonResponse['data'][15]['responses'][0]
                                    ['response'],
                                jsonResponse['data'][15]['responses'][1]
                                    ['response'],
                                jsonResponse['data'][15]['responses'][2]
                                    ['response'],
                              ],
                              optionFifteen,
                              15),
                          _modelQA(
                              jsonResponse['data'][16]['question'],
                              [
                                jsonResponse['data'][16]['responses'][0]
                                    ['response'],
                                jsonResponse['data'][16]['responses'][1]
                                    ['response'],
                              ],
                              optionSixteen,
                              16),
                          _modelQA(
                              jsonResponse['data'][17]['question'],
                              [
                                jsonResponse['data'][17]['responses'][0]
                                    ['response'],
                                jsonResponse['data'][17]['responses'][1]
                                    ['response'],
                              ],
                              optionSeventeen,
                              17),
                          Row(
                            children: [
                              Checkbox(
                                checkColor: Colors.black,
                                value: isChecked,
                                onChanged: (bool? value) {

                                  if(isChecked){
                                    percent = percent - 0.0099999999999996;
                                  } else {
                                    percent = percent + 0.0099999999999996;
                                  }

                                  setState(() {
                                    isChecked = value!;
                                    percent;
                                  });
                                },
                              ),
                              Expanded(
                                  child: Text(
                                      'Estoy de acuerdo en enviar mi información de acuerdo al aviso de privacidad plasmado en este medio.'))
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width - 20,
                  animation: true,
                  lineHeight: 20.0,
                  animationDuration: 600,
                  animateFromLastPercent: true,
                  percent: percent,
                  center: Text(
                    (percent * 100).round().toString() + '%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18
                    ),
                  ),
                  barRadius: Radius.circular(10),
                  // linearStrokeCap: ,
                  progressColor: Colors.blue[800],
                ),
              ),
              GestureDetector(
                onTap: () {
                  switch (_pvController.page?.toInt()) {
                    case 0:
                      if (optionEdad == '' ||
                          _nameasessorController.text == '') {
                        showMyDialog('Hace falta un campo por llenar', context);
                      } else {
                        _pvController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeIn);
                      }
                      break;
                    case 1:
                      if (optionTwo == '' ||
                          optionThree == '' ||
                          optionFour == '') {
                        showMyDialog('Hace falta un campo por llenar', context);
                      } else {
                        _pvController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeIn);
                      }
                      break;
                    case 2:
                      if (optionFive == '' || optionSix == '') {
                        showMyDialog('Hace falta un campo por llenar', context);
                      } else {
                        _pvController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeIn);
                      }
                      break;
                    case 3:
                      if (optionSeven == '') {
                        showMyDialog('Hace falta un campo por llenar', context);
                      } else {
                        _pvController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeIn);
                      }
                      break;
                    case 4:
                      if (optionEight == '' ||
                          optionNine == '' ||
                          optionTen == '' ||
                          optionEleven == '') {
                        showMyDialog('Hace falta un campo por llenar', context);
                      } else {
                        _pvController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeIn);
                      }
                      break;
                    case 5:
                      if (optionTwelve == '' || optionThirteen == '') {
                        showMyDialog('Hace falta un campo por llenar', context);
                      } else {
                        setState(() {
                          labelPage = 'Finalizar';
                        });
                        _pvController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeIn);
                      }
                      break;
                    case 6:
                      if (optionEdad != '' &&
                          optionTwo != '' &&
                          optionThree != '' &&
                          optionFour != '' &&
                          optionFive != '' &&
                          optionSix != '' &&
                          optionSeven != '' &&
                          optionEight != '' &&
                          optionNine != '' &&
                          optionTen != '' &&
                          optionEleven != '' &&
                          optionTwelve != '' &&
                          optionThirteen != '' &&
                          optionFourteen != '' &&
                          optionFifteen != '' &&
                          optionSixteen != '' &&
                          optionSeventeen != '') {
                        if (isChecked) {
                          Perfil request = Perfil(
                              asesor: _nameasessorController.text,
                              optionEdad: backoptionEdad,
                              optionTwo: backoptionTwo,
                              optionThree: backoptionThree,
                              optionFour: backoptionFour,
                              optionFive: backoptionFive,
                              optionSix: backoptionSix,
                              optionSeven: backoptionSeven,
                              optionEight: backoptionEight,
                              optionNine: backoptionNine,
                              optionTen: backoptionTen,
                              optionEleven: backoptionEleven,
                              optionTwelve: backoptionTwelve,
                              optionThirteen: backoptionThirteen,
                              optionFourteen: backoptionFourteen,
                              optionFifteen: backoptionFifteen,
                              optionSixteen: backoptionSixteen,
                              optionSeventeen: backoptionSeventeen);

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ResponsePage(request)));
                        } else {
                          showMyDialog(
                              'Debes aceptar nuestra política de privacidad',
                              context);
                        }
                      } else {
                        showMyDialog('Hace falta un campo de llenar', context);
                      }
                      break;
                    default:
                      _pvController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeIn);
                      break;
                  }
                },
                child: Container(
                    margin: const EdgeInsets.all(10.0),
                    height: 45,
                    width: MediaQuery.of(context).size.width * 0.95,
                    decoration: const BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Center(
                        child: Text(
                      labelPage,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ))),
              ),
            ],
          ),
        ),
      );
    } else {
      return const Scaffold(
        body: Center(
          child: Text('Cargando...', style: TextStyle(fontSize: 48)),
        ),
      );
    }
  }

  _preItem(String title, TextEditingController _controller, String hin) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.88,
            child: Text(
              title,
              textAlign: TextAlign.left,
            )),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.88,
            height: 40,
            child: TextField(
              autocorrect: false,
              enabled: false,
              controller: _controller,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: hin,
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
                labelStyle: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _modelQA(String labelTxt, List<String> optionsLabel, String optionSelected, int op) {
    return Column(
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.88,
            child: Text(
              labelTxt,
              textAlign: TextAlign.left,
            )),
        ListView.builder(
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: optionsLabel.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(optionsLabel[index]),
                leading: Radio<String>(
                  value: optionsLabel[index],
                  groupValue: optionSelected,
                  onChanged: (String? value) {
                    switch (op) {
                      case 1:
                        if(optionEdad.isEmpty){
                          percent = percent + 0.055;
                        }
                        setState(() {
                          optionEdad = value!;
                          backoptionEdad = jsonResponse['data'][1]['responses'][index]['id'].toString();
                          percent;
                        });
                        break;
                      case 2:
                        if(optionTwo.isEmpty){
                          percent = percent + 0.055;
                        }
                        setState(() {
                          optionTwo = value!;
                          backoptionTwo = jsonResponse['data'][2]['responses']
                                  [index]['id']
                              .toString();
                          percent;
                        });
                        break;
                      case 3:
                        if(optionThree.isEmpty){
                          percent = percent + 0.055;
                        }
                        setState(() {
                          optionThree = value!;
                          backoptionThree = jsonResponse['data'][3]['responses'][index]['id'].toString();
                          percent;
                        });
                        break;
                      case 4:
                        if(optionFour.isEmpty){
                          percent = percent + 0.055;
                        }
                        setState(() {
                          optionFour = value!;
                          backoptionFour = jsonResponse['data'][4]['responses'][index]['id'].toString();
                          percent;
                        });
                        break;
                      case 5:
                        if(optionFive.isEmpty){
                          percent = percent + 0.055;
                        }
                        setState(() {
                          optionFive = value!;
                          backoptionFive = jsonResponse['data'][5]['responses'][index]['id'].toString();
                          percent;
                        });
                        break;
                      case 6:
                        if(optionSix.isEmpty){
                          percent = percent + 0.055;
                        }
                        setState(() {
                          optionSix = value!;
                          backoptionSix = jsonResponse['data'][6]['responses'][index]['id'].toString();
                          percent;
                        });
                        break;
                      case 7:
                        if(optionSeven.isEmpty){
                          percent = percent + 0.055;
                        }
                        setState(() {
                          optionSeven = value!;
                          backoptionSeven = jsonResponse['data'][7]['responses']
                                  [index]['id']
                              .toString();
                          percent;
                        });
                        break;
                      case 8:
                        if(optionEight.isEmpty){
                          percent = percent + 0.055;
                        }
                        setState(() {
                          optionEight = value!;
                          backoptionEight = jsonResponse['data'][8]['responses']
                                  [index]['id']
                              .toString();
                          percent;
                        });
                        break;
                      case 9:
                        if(optionNine.isEmpty){
                          percent = percent + 0.055;
                        }
                        setState(() {
                          optionNine = value!;
                          backoptionNine = jsonResponse['data'][9]['responses']
                                  [index]['id']
                              .toString();
                          percent;
                        });
                        break;
                      case 10:
                        if(optionTen.isEmpty){
                          percent = percent + 0.055;
                        }
                        setState(() {
                          optionTen = value!;
                          backoptionTen = jsonResponse['data'][10]['responses']
                                  [index]['id']
                              .toString();
                          percent;
                        });
                        break;
                      case 11:
                        if(optionEleven.isEmpty){
                          percent = percent + 0.055;
                        }
                        setState(() {
                          optionEleven = value!;
                          backoptionEleven = jsonResponse['data'][11]
                                  ['responses'][index]['id']
                              .toString();
                          percent;
                        });
                        break;
                      case 12:
                        if(optionTwelve.isEmpty){
                          percent = percent + 0.055;
                        }
                        setState(() {
                          optionTwelve = value!;
                          backoptionTwelve = jsonResponse['data'][12]
                                  ['responses'][index]['id']
                              .toString();
                          percent;
                        });
                        break;
                      case 13:
                        if(optionThirteen.isEmpty){
                          percent = percent + 0.055;
                        }
                        setState(() {
                          optionThirteen = value!;
                          backoptionThirteen = jsonResponse['data'][13]
                                  ['responses'][index]['id']
                              .toString();
                          percent;
                        });
                        break;
                      case 14:
                        if(optionFourteen.isEmpty){
                          percent = percent + 0.055;
                        }
                        setState(() {
                          optionFourteen = value!;
                          backoptionFourteen = jsonResponse['data'][14]
                                  ['responses'][index]['id']
                              .toString();
                          percent;
                        });
                        break;
                      case 15:
                        if(optionFifteen.isEmpty){
                          percent = percent + 0.055;
                        }
                        setState(() {
                          optionFifteen = value!;
                          backoptionFifteen = jsonResponse['data'][15]
                                  ['responses'][index]['id']
                              .toString();
                          percent;
                        });
                        break;
                      case 16:
                        if(optionSixteen.isEmpty){
                          percent = percent + 0.055;
                        }
                        setState(() {
                          optionSixteen = value!;
                          backoptionSixteen = jsonResponse['data'][16]
                                  ['responses'][index]['id']
                              .toString();
                          percent;
                        });
                        break;
                      case 17:
                        if(optionSeventeen.isEmpty){
                          percent = percent + 0.055;
                        }
                        setState(() {
                          optionSeventeen = value!;
                          backoptionSeventeen = jsonResponse['data'][17]
                                  ['responses'][index]['id']
                              .toString();
                          percent;
                        });
                        break;
                    }
                  },
                ),
              );
            }),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.07,
        ),
      ],
    );
  }
}
