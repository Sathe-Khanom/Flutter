

import 'package:dream_job/jobseeker/jobseeker_profile.dart';
import 'package:dream_job/page/admin.dart';
import 'package:dream_job/page/registration.dart';
import 'package:dream_job/service/authservice.dart';
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

                 loginUser(context);

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

  Future<void> loginUser(BuildContext context) async{
    try{

      final response = await AuthService().login(email.text, password.text);

      // Successful login, role-based navigation
      final  role =await AuthService().getUserRole(); // Get role from AuthService


      if (role == 'ADMIN') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Admin()),
        );
      }
      else if (role == 'JOBSEEKER') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => JobSeekerProfile()),
        );
      }

      else {
        print('Unknown role: $role');
      }




    }
    catch(error){
      print('Login failed: $error');

    }


  }





}