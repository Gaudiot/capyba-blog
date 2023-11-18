import 'package:flutter/material.dart';

import 'package:capyba_blog/shared/components/drawer_layout.dart';
import 'package:capyba_blog/shared/components/message_text_field.dart';
import 'package:capyba_blog/shared/components/messages_list_view.dart';

class RestrictedRoute extends StatelessWidget {
  const RestrictedRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerLayout(
      routeName: "Restricted",
      child: const Column(
        children: [
          MessageTextField(isRestricted: true),
          Expanded(
            child: MessagesListView(isRestricted: true)
          ),
        ],
      )
    );
  }
}