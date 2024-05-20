import 'package:flutter/material.dart';

class PersonalPage extends StatelessWidget {
  final String userName;
  final String nickName;
  final String registerTime;

  const PersonalPage({Key? key, required this.userName, required this.nickName, required this.registerTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Column(
        children:[
          UserNicknameHeadline(nickName: nickName),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children:[
                  UserInformation(informationName: "登录名", informationValue: userName),
                  UserInformation(informationName: "昵称", informationValue: nickName),
                  UserInformation(informationName: "注册时间", informationValue: registerTime),
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