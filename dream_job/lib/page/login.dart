

import 'package:dream_job/page/registration.dart';
import 'package:flutter/material.dart';

 class Login extends StatelessWidget{

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool _obscurePassword = true;


  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Padding(padding: EdgeInsets.all(16.00),

     child: Column(
       mainAxisAlignment: MainAxisAlignment.center,

       children: [
         TextField(
           controller: email,
           decoration: InputDecoration(
             labelText: 'example@gmail.com',
             border: OutlineInputBorder(),
             prefixIcon: Icon(Icons.email)),
         ),

         SizedBox(
           height: 20.0,
         ),

         TextField(
           controller: password,
           obscureText: _obscurePassword,
           decoration: InputDecoration(
             labelText: 'Password',
             border: OutlineInputBorder(),
             prefixIcon: Icon(Icons.password),
             suffixIcon: IconButton(
                  icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility),
             onPressed: (){
              _obscurePassword  = !_obscurePassword;

             },

             ),
           ),
         ),

         SizedBox(
           height: 20.0,
         ),


         ElevatedButton(
             onPressed: (){
             String em = email.text;
             String pass = password.text;
             print('Email: $em, Password: $pass');

             } ,
             child: Text(
               "Login",
               style: TextStyle(
                 fontSize: 20.0,
                 fontWeight: FontWeight.w800
               ),
             ),

             style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.purple,
                 foregroundColor: Colors.white

             )


         ),

         SizedBox(
           height: 20.0,
         ),

         TextButton(
           onPressed: () {
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => Registration()),
             );
           },
           child: Text(
             'Registration',
             style: TextStyle(
               color: Colors.blue,
               decoration: TextDecoration.underline,
             ),
           ),
         )
       ],
     ),
   ),
   );
  }
}