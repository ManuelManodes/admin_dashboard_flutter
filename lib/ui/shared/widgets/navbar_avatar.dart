import 'package:flutter/material.dart';

class NavbarAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        child: Image.network(
          'https://media.istockphoto.com/id/1218042637/photo/portrait-of-a-funny-cat-in-a-police-hat-and-tie.jpg?s=1024x1024&w=is&k=20&c=yUYBA9qAUQsj_MeWEdx2PCLsJkHPKP_7CXOWlbaOYUk=',
          width: 40,
          height: 40,
        ),
      ),
    );
  }
}
