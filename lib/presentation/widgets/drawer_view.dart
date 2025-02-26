import 'package:flutter/material.dart';
import 'package:untitled/presentation/pages/login/login_screen.dart';
import 'package:untitled/presentation/widgets/avatar.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/image/album1.jpg'),
                ),
                title: Text('Trang Nguyễn'),
                subtitle: Text('Xem hồ sơ'),
                onTap: (){
                  print('Điều hướng vào trang Profile');
                },
              ),
              ListTile(
                leading: Icon(Icons.add_circle_outline_sharp),
                title: Text('Thêm tài khoản'),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                }
              ),
              ListTile(
                leading: Icon(Icons.lightbulb_outline_sharp),
                title: Text("Bản phát hành mới"),
                onTap: (){},
              ),
              ListTile(
                leading: Icon(Icons.settings_backup_restore_sharp),
                title: Text('Gần đây'),
                onTap: (){},
              ),
              ListTile(
                leading: Icon(Icons.settings_outlined),
                title: Text('Cài đặt và quyền riêng tư'),
              )
            ],
          ),
        ),
    );
  }
}
