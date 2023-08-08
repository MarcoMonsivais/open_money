import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '/src/indicator.dart';
import 'global_functions.dart';
import 'globals.dart';
import 'package:http/http.dart' as http;

class WelcomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WelcomePageState();
  }
}

class WelcomePageState extends State<WelcomePage> {

  bool value = false;
  int val = -1;
  String? responseGlobal = '';
  String? accessToken = '';
  String name = '';
  int touchedIndex = 0;
  var jsonResponse;

  List<String>? itemIngreso = [];
  final List<String> itemEgreso = [];
  final Map<String, String> categoryIngreso = {};
  final Map<String, String> categoryEgreso = {};
  final Map<String, String> categoryIngresoBuild = {};
  final Map<String, String> categoryEgresoBuild = {};
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String? selectedIngreso;
  String? selectedEgreso;

  List<String> listMonth = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre'
  ];

  PageController _pvController = PageController(initialPage: 0);

  final curfor = NumberFormat("#,##0", "en_US");

  bool newMonth = false;

  late String selectMonth = '';

  List<dynamic> item = [''];

  getShared() async {

    print('Get shared 0');

    try{
      accessToken = await prefs?.getString('lastaccesstoken');
      responseGlobal = await prefs?.getString('lastresponeGlobal');
      name = json.decode(responseGlobal!)['data']['name'];
      if(name.isEmpty) {
        setState((){name;});
      }
    } catch(onError){
      accessToken = 'sin access token';
      name = '-';
    }

    try{

      final response = await http.get(Uri.parse('http://143.198.128.13/api/categories/ingresos'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
      );

      var valueMap = jsonDecode(response.body)['data'];

      if(categoryIngreso.isEmpty) {
        for (var i = 0; i < valueMap.length; i++) {
          categoryIngreso.addAll({valueMap[i]['name'] : valueMap[i]['id'].toString()});
          categoryIngresoBuild.addAll({valueMap[i]['id'].toString() : valueMap[i]['name']});
          itemIngreso!.add(valueMap[i]['name']);
        }
      }

    } catch(onerr){
      print('error en ingreso: ' + onerr.toString());
    }

    try{

      final response = await http.get(Uri.parse('http://143.198.128.13/api/categories/egresos'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
      );

      var valueMap = jsonDecode(response.body)['data'];

      if(itemEgreso.isEmpty) {
        for (var i = 0; i < valueMap.length; i++) {
          categoryEgreso.addAll( {valueMap[i]['name'] : valueMap[i]['id'].toString()});
          categoryEgresoBuild.addAll({valueMap[i]['id'].toString() : valueMap[i]['name']});
          itemEgreso.add(valueMap[i]['name']);
        }
      }

    } catch(onerr){
      print('error en egreso: ' + onerr.toString());
    }

    if(!(newMonth)){

      try{
        selectMonth = 'Agosto';
      } catch(onerr){
        print('error mes: ' + onerr.toString());
      }

      try{

        final response = await http.get(Uri.parse('http://143.198.128.13/api/balance/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $accessToken'
          },
        );

        jsonResponse = jsonDecode(response.body);

      } catch(onerror){
        print('error json: ' +  onerror.toString());
      }
    }

    print('Get shared 1');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: appBar(context, 'Balance        '),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: floatActionButton(context),
      bottomNavigationBar: bottomApp(context),
      drawer: menuLateral(context),
      body: FutureBuilder(
        future: getShared(),
        builder: (context2, snapshot) {

          if(snapshot.connectionState == ConnectionState.done){

            List<TableRow> rows = [];

            try {

              if(jsonResponse['data'].toString().isNotEmpty){
                print(0);
                item = jsonResponse['data'];
              } else {
                print('json vacío');
              }

              for (int i = 0; i < item.length; ++i) {
                print(3);
                String type = item[i]['type'];
                String name = 'UNKNOWN';

                try{
                  print(4);
                  if(type == 'INGRESO'){
                    name = categoryIngresoBuild[item[i]['category_id'].toString()]!;
                  } else {
                    name = categoryEgresoBuild[item[i]['category_id'].toString()]!;
                  }

                } catch(onerr){
                  print(5);
                  print('error category: ' + onerr.toString());
                  print('item: ' + i.toString());
                  print(categoryIngresoBuild);
                }

                print(6);
                rows.add(TableRow(children: [
                  type == 'EGRESO' ?
                  const Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(Icons.money_off, color: Colors.red,),
                  ) :
                  const Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(Icons.attach_money_rounded, color: Colors.green,),
                  ),
                  Text(name),
                  type == 'EGRESO' ? Text('-\$' + curfor.format(item[i]['amount']), style: const TextStyle(color: Colors.red),) : Text('\$' + curfor.format(item[i]['amount']), style: const TextStyle(color: Colors.green),),
                  Text(item[i]['created_at'].toString().substring(0, item[i]['created_at'].toString().indexOf('T')), style: const TextStyle(color: Colors.grey, fontSize: 10),),
                ]));
              }

            } catch (onerr){
              Future.delayed(const Duration(seconds: 3), () {
                final snackBar = SnackBar(
                  content: const Text('Cargando...'),
                  backgroundColor: (Colors.black12),
                  // action: SnackBarAction(
                  //   label: 'dismiss',
                  //   onPressed: () {
                  //   },
                  // ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                // setState(() {
                //   jsonResponse;
                // });
              });
              print(jsonResponse);
              print('error general: ' + onerr.toString());
            }

            return SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Container(
                      color: Colors.blue[100],
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [

                          const SizedBox(height: 15,),

                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.30,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                hint: Text(
                                  selectMonth,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                                items: listMonth!.map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item, style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                )).toList(),
                                onChanged: (value) async {

                                  final response = await http.get(Uri.parse('http://143.198.128.13/api/balance/' + (listMonth.indexOf(value.toString()) + 1).toString()),
                                    headers: <String, String>{
                                      'Content-Type': 'application/json; charset=UTF-8',
                                      'Accept': 'application/json; charset=UTF-8',
                                      'Authorization': 'Bearer $accessToken'
                                    },
                                  );

                                  setState((){
                                    selectMonth = value as String;
                                    newMonth = true;
                                    jsonResponse = jsonDecode(response.body);
                                  });

                                },
                                selectedItemHighlightColor: Colors.green[100],
                                dropdownMaxHeight: 180,
                                isExpanded: true,
                                value: selectMonth,
                                buttonHeight: 40,
                                buttonWidth: 200,
                                itemHeight: 40,
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: Text('\$' + curfor.format(jsonResponse['total_balance']) , style: const TextStyle(fontSize: 36),),
                          ),

                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: Row(
                              children: [

                                Expanded(child: GestureDetector(
                                  onTap: () {

                                    if((listMonth.indexOf(selectMonth) + 1) == DateTime.now().month) {
                                      TextEditingController _quantity = TextEditingController();

                                      Alert(
                                          context:
                                              scaffoldKey.currentContext!,
                                          title: 'AGREGAR INGRESO',
                                          content: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.09,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.70,
                                            child: PageView(
                                              controller: _pvController,
                                              scrollDirection:
                                                  Axis.vertical,
                                              children: <Widget>[
                                                DropdownButtonHideUnderline(
                                                  child: DropdownButton2(
                                                    hint: Text(
                                                      'Selecciona una categoría',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Theme.of(
                                                                context)
                                                            .hintColor,
                                                      ),
                                                    ),
                                                    items: itemIngreso!
                                                        .map((item) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                              value: item,
                                                              child: Text(
                                                                item,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize:
                                                                      14,
                                                                ),
                                                              ),
                                                            ))
                                                        .toList(),
                                                    onChanged: (value) {
                                                      _pvController.nextPage(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      400),
                                                          curve: Curves
                                                              .easeIn);
                                                      setState(() {
                                                        selectedIngreso =
                                                            value as String;
                                                      });
                                                    },
                                                    value: selectedIngreso,
                                                    buttonHeight: 40,
                                                    buttonWidth: 200,
                                                    itemHeight: 40,
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    TextField(
                                                      controller: _quantity,
                                                      keyboardType:
                                                          TextInputType
                                                              .number,
                                                      decoration:
                                                          const InputDecoration(
                                                        icon: Icon(
                                                          Icons
                                                              .attach_money_rounded,
                                                          color:
                                                              Colors.green,
                                                        ),
                                                        labelText:
                                                            'Cantidad',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          buttons: [
                                            DialogButton(
                                              onPressed: () async {
                                                await http.post(
                                                  Uri.parse('http://143.198.128.13/api/balance/'),
                                                  headers: <String, String>{
                                                    'Content-Type': 'application/json; charset=UTF-8',
                                                    'Accept': 'application/json; charset=UTF-8',
                                                    'Authorization': 'Bearer $accessToken'
                                                  },
                                                  body: jsonEncode(<String, String>{
                                                    "amount": _quantity.text,
                                                    "category_id": categoryIngreso[selectedIngreso]!,
                                                    "type": 'INGRESO'
                                                  }),
                                                ).then((value) async {
                                                  await http.get(Uri.parse('http://143.198.128.13/api/balance/'),
                                                    headers: <String,
                                                        String>{
                                                      'Content-Type': 'application/json; charset=UTF-8',
                                                      'Accept': 'application/json; charset=UTF-8',
                                                      'Authorization': 'Bearer $accessToken'
                                                    },
                                                  ).then((value) {
                                                    jsonResponse = jsonDecode(value.body);
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      jsonResponse;
                                                    });
                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ingreso agregado'),),);
                                                  });
                                                });
                                              },
                                              child: const Text(
                                                "AGREGAR",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                            )
                                          ]).show();
                                    } else{
                                      showMyDialog('El ingreso no puede ser agregado ya que no estas en el mes actual', context);
                                    }

                                  },
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(right: 15),
                                        child: Icon(Icons.attach_money_rounded, color: Colors.green, size: 33,),
                                      ),
                                      Expanded(child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Ingresos', style: TextStyle(fontSize: 20, color: Colors.green),),
                                          Text('\$' + curfor.format(jsonResponse['total_ingreso']), style: TextStyle(fontSize: 18, color: Colors.green),),
                                        ],
                                      ))
                                    ],
                                  ),
                                )),
                                const SizedBox(width: 40,),
                                Expanded(child: GestureDetector(
                                  onTap: () {

                                    if((listMonth.indexOf(selectMonth) + 1) == DateTime.now().month) {
                                      TextEditingController _quantity = TextEditingController();

                                      Alert(
                                          context: context,
                                          title: "AGREGAR EGRESO",
                                          content: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.09,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.70,
                                            child: PageView(
                                              controller: _pvController,
                                              scrollDirection:
                                                  Axis.vertical,
                                              children: <Widget>[
                                                DropdownButtonHideUnderline(
                                                  child: DropdownButton2(
                                                    hint: Text(
                                                      'Selecciona una categoría',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Theme.of(
                                                                context)
                                                            .hintColor,
                                                      ),
                                                    ),
                                                    items: itemEgreso!
                                                        .map((item) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                              value: item,
                                                              child: Text(
                                                                item,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize:
                                                                      14,
                                                                ),
                                                              ),
                                                            ))
                                                        .toList(),
                                                    onChanged: (value) {
                                                      _pvController.nextPage(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      400),
                                                          curve: Curves
                                                              .easeIn);
                                                      setState(() {
                                                        selectedEgreso =
                                                            value as String;
                                                      });
                                                    },
                                                    value: selectedEgreso,
                                                    buttonHeight: 40,
                                                    buttonWidth: 200,
                                                    itemHeight: 40,
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    TextField(
                                                      controller: _quantity,
                                                      keyboardType:
                                                          TextInputType
                                                              .number,
                                                      decoration:
                                                          const InputDecoration(
                                                        icon: Icon(
                                                          Icons
                                                              .attach_money_rounded,
                                                          color:
                                                              Colors.green,
                                                        ),
                                                        labelText:
                                                            'Cantidad',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          buttons: [
                                            DialogButton(
                                              onPressed: () async {
                                                await http
                                                    .post(
                                                  Uri.parse(
                                                      'http://143.198.128.13/api/balance/'),
                                                  headers: <String, String>{
                                                    'Content-Type':
                                                        'application/json; charset=UTF-8',
                                                    'Accept':
                                                        'application/json; charset=UTF-8',
                                                    'Authorization':
                                                        'Bearer $accessToken'
                                                  },
                                                  body: jsonEncode(<String,
                                                      String>{
                                                    "amount":
                                                        _quantity.text,
                                                    "category_id":
                                                        categoryEgreso[
                                                            selectedEgreso]!,
                                                    "type": 'EGRESO'
                                                  }),
                                                )
                                                    .then((value) async {
                                                  await http.get(
                                                    Uri.parse(
                                                        'http://143.198.128.13/api/balance/'),
                                                    headers: <String,
                                                        String>{
                                                      'Content-Type':
                                                          'application/json; charset=UTF-8',
                                                      'Accept':
                                                          'application/json; charset=UTF-8',
                                                      'Authorization':
                                                          'Bearer $accessToken'
                                                    },
                                                  ).then((value) {
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      jsonResponse =
                                                          jsonDecode(
                                                              value.body);
                                                    });
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Egreso agregado'),
                                                      ),
                                                    );
                                                  });
                                                });
                                              },
                                              child: const Text(
                                                "AGREGAR",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                            )
                                          ]).show();
                                    } else {
                                      showMyDialog('El egreso no puede ser agregado ya que no estas en el mes actual', context);
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(right: 15),
                                        child: Icon(Icons.money_off, color: Colors.red, size: 33,),
                                      ),
                                      Expanded(child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Egresos', style: TextStyle(fontSize: 20, color: Colors.red),),
                                          Text('\$' + curfor.format(jsonResponse['total_egreso']), style: TextStyle(fontSize: 18, color: Colors.red),),
                                        ],
                                      ))
                                    ],
                                  ),
                                )),

                              ],
                            ),
                          ),

                          const SizedBox(height: 30,),

                        ],
                      ),
                    ),


                    AspectRatio(
                      aspectRatio: 1.4,
                      child: Card(
                        color: Colors.white,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 18,
                            ),
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: PieChart(
                                  PieChartData(
                                    borderData: FlBorderData(
                                      show: false,
                                    ),
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 0,
                                    sections: showingSections()),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                Indicator(
                                  color: Color(0xff0293ee),
                                  text: 'Mayor ingreso',
                                  isSquare: true,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Indicator(
                                  color: Color(0xfff8b250),
                                  text: 'Mayor gasto',
                                  isSquare: true,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Indicator(
                                  color: Colors.green,
                                  text: 'Menor gasto',
                                  isSquare: true,
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 28,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10,),

                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                      child: SingleChildScrollView(
                        child: Table(
                          columnWidths: const {
                            0: FixedColumnWidth(80.0),
                            1: FixedColumnWidth(100.0),
                            2: FixedColumnWidth(100.0),
                            3: FixedColumnWidth(100.0),
                          },
                          children: rows
                        ),
                      ),
                    ),

                  ],),
              ),
            );

          }

          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }

          return const SizedBox.shrink();

        }
      )
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final fontSize = 16.0;
      final radius = 100.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: double.parse(jsonResponse['grafica'][i][0].toString()),
            title: jsonResponse['grafica'][i][0].toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff)
            ),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: double.parse(jsonResponse['grafica'][i][0].toString()),
            title: jsonResponse['grafica'][i][0].toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff)
            ),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: double.parse(jsonResponse['grafica'][i][0].toString()),
            title: jsonResponse['grafica'][i][0].toString(),
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff)
            ),
          );
        default:
          throw 'Oh no';
      }
    });
  }

}

