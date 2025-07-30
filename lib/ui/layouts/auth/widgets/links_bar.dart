import 'package:admin_dashboard/ui/buttons/link_text.dart';
import 'package:flutter/material.dart';

class LinksBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      color: Colors.black,
      width: double.infinity, // Siempre ocupa todo el ancho
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 12.0,
          runSpacing: 12.0,
          children: [
            LinkText(text: 'About', onPressed: () => print('About')),
            LinkText(
              text: 'Help center',
              onPressed: () => print('Help center'),
            ),
            LinkText(
              text: 'Terms of Service',
              onPressed: () => print('Terms of Service'),
            ),
            LinkText(
              text: 'Privacy Policy',
              onPressed: () => print('Privacy Policy'),
            ),
            LinkText(
              text: 'Cookies Policy',
              onPressed: () => print('Cookies Policy'),
            ),
            LinkText(text: 'Ads info', onPressed: () => print('Ads info')),
            LinkText(text: 'Blog', onPressed: () => print('Blog')),
            LinkText(text: 'Status', onPressed: () => print('Status')),
            LinkText(text: 'Careers', onPressed: () => print('Careers')),
            LinkText(
              text: 'Brand Resources',
              onPressed: () => print('Brand Resources'),
            ),
            LinkText(
              text: 'Advertising',
              onPressed: () => print('Advertising'),
            ),
            LinkText(text: 'Marketing', onPressed: () => print('Marketing')),
          ],
        ),
      ),
    );
  }
}
