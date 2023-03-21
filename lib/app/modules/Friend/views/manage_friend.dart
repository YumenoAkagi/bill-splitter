import 'package:bill_splitter/app/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ManageFriendView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Friend'),
          centerTitle: true,
          bottom: TabBar(
              indicatorColor: getColorFromHex(COLOR_5),
              unselectedLabelColor: getColorFromHex(COLOR_1),
              indicator: BoxDecoration(color: getColorFromHex(COLOR_1)),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(
                  text: 'Request',
                ),
                Tab(
                  text: 'Pending',
                )
              ]),
        ),
        body: const TabBarView(children: [
          Center(
            child: Text('Tab Request'),
          ),
          Center(
            child: Text('Tab Pending'),
          )
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          margin: const EdgeInsets.symmetric(
              vertical: SAFEAREA_CONTAINER_MARGIN_V,
              horizontal: SAFEAREA_CONTAINER_MARGIN_H),
          child:
              FilledButton(onPressed: () {}, child: const Text('Add Friend')),
        ),
      ),
    );
  }
}
