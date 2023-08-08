import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomepagePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomepagePageState();
  }
}

class _HomepagePageState extends State<HomepagePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
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

                  // Image.asset('assets/banner.jpeg', width: 120,),


                ],
              )
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Image.asset('assets/banner.jpeg', width: 360,),

                SizedBox(height: MediaQuery.of(context).size.height * 0.06,),

                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: const TextField(
                      autocorrect: false,
                      // autofocus: true,
                      // controller: _usernameController,
                      decoration: InputDecoration(
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
                        labelText: 'Correo',
                        labelStyle: TextStyle(
                            color: Colors.black
                        ),
                        // suffix: GestureDetector(
                        //     onTap: (){
                        //       _usernameController!.text = _usernameController!.text + '@hotmail.com';
                        //     },
                        //     child: const Icon(Icons.mail)),
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

                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: const TextField(
                      autocorrect: false,
                      autofocus: false,
                      // controller: _passwordController,
                      decoration: InputDecoration(
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
                        labelText: 'Contraseña',
                        labelStyle: TextStyle(
                            color: Colors.black
                        ),
                        // suffix: GestureDetector(
                        //     onTap: (){
                        //       setState(() {
                        //         _obscure = !_obscure;
                        //       });
                        //     },
                        //     child: Icon(Icons.remove_red_eye)),
                        // suffixIcon: IconButton(
                        //   color: Colors.black,
                        //   icon: const Icon(Icons.cancel),
                        //   onPressed: () => _passwordController!.clear(),
                        // ),
                      ),
                      keyboardType: TextInputType.text,
                      // obscureText: _obscure,
                      textCapitalization: TextCapitalization.none,
                      textInputAction: TextInputAction.next,
                      // onEditingComplete: () => _login(),
                    ),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: const Align(
                    alignment: Alignment.topRight,
                    child: Text('Olvide mi contraseña'),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

                GestureDetector(
                  onTap: (){

                  },
                  child: Container(
                      margin: const EdgeInsets.all(10.0),
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.75,
                      decoration: const BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ),
                      child: const Center(child: Text('Ingresar', style: TextStyle(color: Colors.black),))
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.01,),

                GestureDetector(
                  onTap: (){

                  },
                  child: Container(
                      margin: const EdgeInsets.all(10.0),
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.75,
                      decoration: const BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ),
                      child: const Center(child: Text('Crear cuenta', style: TextStyle(color: Colors.black),))
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }


}



