import 'package:flutter/material.dart';
import 'package:untitled/pages/register_page.dart';
import 'package:untitled/widgets/logo.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }

}

class LoginPageState extends State<LoginPage>{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LogoWidget(),
            const SizedBox(height: 40),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Đăng nhập vào',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white
                    )
                  ),
                  TextSpan(
                    text: ' MelodiFlow',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontStyle: FontStyle.italic
                    )
                  ),
                ]
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Email',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15)
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20
                )
              ),
            ),

            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
                child: Text('Mật khẩu',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // chuyển vào trang khi đăng nhập xong
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  minimumSize: const Size(262, 42)
              ),
              child: const Text('Đăng nhập', style: TextStyle(fontWeight: FontWeight.bold),),
            ),

            const SizedBox(height: 20,),
            TextButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: const Text(
                  'Quên mật khẩu của bạn ?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                )),

            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Opacity(
                    opacity: 0.72,
                  child: Text('Bạn chưa có tài khoản ?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white
                  ),),
                ),
                TextButton(
                    onPressed: (){
                      //Xử lý logic
                    },
                    child: const Text('Đăng ký ngay',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                    ),))
              ],
            ),

          ],
        ),


      ),

    );
  }
}