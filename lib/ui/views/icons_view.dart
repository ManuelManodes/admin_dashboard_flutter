import 'package:admin_dashboard/ui/cards/white_card.dart';
import 'package:admin_dashboard/ui/labels/custom_labels.dart';
import 'package:flutter/material.dart';

class IconsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Text('Icons', style: CustomLabels.h1),

          SizedBox(height: 10),

          Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            direction: Axis.horizontal,
            children: [
              WhiteCard(
                title: 'ac_unit_outlined',
                child: Center(child: Icon(Icons.ac_unit_outlined)),
                width: 170,
              ),
              WhiteCard(
                title: 'access_alarms_outlined',
                child: Center(child: Icon(Icons.access_alarms_outlined)),
                width: 170,
              ),
              WhiteCard(
                title: 'access_time_rounded',
                child: Center(child: Icon(Icons.access_time_rounded)),
                width: 170,
              ),
              WhiteCard(
                title: 'all_inbox',
                child: Center(child: Icon(Icons.all_inbox)),
                width: 170,
              ),
              WhiteCard(
                title: 'sd_card_alert_sharp',
                child: Center(child: Icon(Icons.sd_card_alert_sharp)),
                width: 170,
              ),
              WhiteCard(
                title: 'tab_unselected_outlined',
                child: Center(child: Icon(Icons.tab_unselected_outlined)),
                width: 170,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
