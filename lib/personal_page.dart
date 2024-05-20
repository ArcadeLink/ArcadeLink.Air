import 'package:aircade/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonalPage extends StatelessWidget {
  const PersonalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    userService.getUserInfo();
    final user = userService.getCurrentUser();

    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Column(
        children:[
          UserNicknameHeadline(nickName: user['nickname']!),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children:[
                  UserInformation(informationName: "登录名", informationValue: user['username']!),
                  UserInformation(informationName: "昵称", informationValue: user['nickname']!),
                ]
              ),
            ),
          ),
          const UserOperation()
        ]
      ),
    );
  }
}

class UserNicknameHeadline extends StatelessWidget {
  const UserNicknameHeadline({
    super.key,
    required this.nickName,
  });

  final String nickName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children:[
          Text(nickName, style: Theme.of(context).textTheme.headlineLarge!),
        ]
      ),
    );
  }
}

class UserInformation extends StatelessWidget {
  const UserInformation({
    super.key,
    required this.informationValue, required this.informationName,
  });

  final String informationValue;
  final String informationName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
        Row(
            children:[
              Text(informationName, style: Theme.of(context).textTheme.titleMedium!),
            ]
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
            children:[
              Text(informationValue, style: Theme.of(context).textTheme.bodyMedium!),
            ]
        ),
        const SizedBox(
          height: 20,
        ),
      ]
    );
  }
}

class UserOperation extends StatelessWidget {
  const UserOperation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(onPressed: () => print("234"), child: const Text("修改密码")),
            ElevatedButton(onPressed: () => print("234"), child: const Text("修改昵称")),
            ElevatedButton(onPressed: () => print("123"), child: const Text("退出登录")),
          ],
        ),
      ),
    );
  }
}