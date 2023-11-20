import 'package:flutter/material.dart';

import 'package:capyba_blog/shared/components/drawer_layout.dart';
import 'package:capyba_blog/shared/components/message_text_field.dart';
import 'package:capyba_blog/shared/components/messages_list_view.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerLayout(
      routeName: "Home",
      child: const Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            MessageTextField(),
            Expanded(
              child: MessagesListView()
            ),
          ],
        ),
      )
    );
  }
}