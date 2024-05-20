import 'package:aircade/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class PersonalPage extends StatefulWidget {
  const PersonalPage({Key? key}) : super(key: key);

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    return FutureBuilder(
      future: userService.getUserInfo(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var user = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
                children:[
                  UserNicknameHeadline(nickName: user['nickname']),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                          children:[
                            UserInformation(informationName: "登录名", informationValue: user['user_id']),
                            UserInformation(informationName: "昵称", informationValue: user['nickname']),
                          ]
                      ),
                    ),
                  ),
                  UserOperation(refresh: () => setState(() {}))
                ]
            ),
          );
        }
      },
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

// 用户操作按钮
class UserOperation extends StatelessWidget {
  final VoidCallback refresh;

  const UserOperation({
    required this.refresh,
    Key? key,
  }) : super(key: key);


  Future<void> _changePassword(BuildContext context) async {
    final userService = Provider.of<UserService>(context, listen: false);
    final formKey = GlobalKey<FormState>();
    String oldPassword = '';
    String newPassword = '';

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('修改密码'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: '旧密码'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入旧密码';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    oldPassword = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: '新密码'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入新密码';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    newPassword = value!;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('确认'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  userService.changePassword(oldPassword, newPassword);
                  refresh();
                  Navigator.of(context).pop();
                }
              },
            ),

          ],
        );
      },
    );
  }

  Future<void> _changeNickname(BuildContext context) async {
    final userService = Provider.of<UserService>(context, listen: false);
    final _formKey = GlobalKey<FormState>();
    String newNickname = '';

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('修改昵称'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: '新昵称'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入新昵称';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    newNickname = value!;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('确认'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  userService.changeUsername(newNickname);
                  Navigator.of(context).pop();
                  refresh();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    final userService = Provider.of<UserService>(context, listen: false);
    userService.logout();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => _changePassword(context), child: const Text("修改密码"))),
            const SizedBox(height: 10,),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => _changeNickname(context), child: const Text("修改昵称"))),
            const SizedBox(height: 10,),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => _logout(context), child: const Text("退出登录"))),
          ],
        ),
        ),
      );
  }
}