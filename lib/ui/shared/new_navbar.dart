import 'package:flutter/material.dart';
import 'package:admin_dashboard/ui/shared/widgets/top_header_bar.dart';
import 'package:admin_dashboard/ui/shared/widgets/horizontal_navigation.dart';

class NewNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top header with user info, search, and project identifier
        TopHeaderBar(),

        // Horizontal navigation with views
        HorizontalNavigation(),
      ],
    );
  }
}
