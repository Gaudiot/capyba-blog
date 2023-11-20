import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:capyba_blog/services/firebase/ifirebase_service.dart';
import 'package:capyba_blog/services/firebase/implementations/firebase_service.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class DrawerLayout extends StatelessWidget {
  DrawerLayout({super.key, required this.routeName, required this.child});
  final GlobalKey<SliderDrawerState> _sliderKey = GlobalKey<SliderDrawerState>();

  final Widget child;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return SliderDrawer(
      slider: _SliderView(sliderKey: _sliderKey),
      key: _sliderKey,
      appBar: SliderAppBar(
        title: Text(routeName, style: GoogleFonts.lobster(
          textStyle: Theme.of(context).textTheme.displaySmall,
          color: const Color(0xFF01A247)
        )),
        appBarColor: const Color(0xFFDEDEDE),
        drawerIconColor: const Color(0xFF01A247),
      ),
      child: Container(
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          child: child
        )
      )
    );
  }
}

class _SliderView extends StatelessWidget {
  _SliderView({super.key, required this.sliderKey});
  final IFirebaseService firebaseService = FirebaseService();
  final GlobalKey<SliderDrawerState> sliderKey;

  Future<void> logout(BuildContext context) async {
    await firebaseService.logout();
    if(context.mounted){
      sliderKey.currentState!.closeSlider();
      context.goNamed("welcome");
    }
  }

  Future<void> sendValidationEmail(BuildContext context) async {
    final isEmailSent = await firebaseService.sendValidationEmail();
    if(context.mounted){
      if(!isEmailSent){
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            message: "Failed to send email, try again in a few seconds."
          )
        );
      }else{
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
            message: "Account verification email sent!"
          )
        );
      }
    }
  }

  bool isUserVerified(){
    return firebaseService.isUserVerified();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _SliderTile(
          text: "Home",
          icon: FontAwesomeIcons.house,
          onTap: (){
            sliderKey.currentState!.closeSlider();
            context.pushNamed("home");
          }
        ),
        isUserVerified() ? _SliderTile(
          text: "Restricted",
          icon: FontAwesomeIcons.lock,
          onTap: (){
            sliderKey.currentState!.closeSlider();
            context.pushNamed('restricted');
          }
        ) : const SizedBox.shrink(),
        _SliderTile(
          text: "Profile",
          icon: FontAwesomeIcons.user,
          onTap: (){
            sliderKey.currentState!.closeSlider();
            context.pushNamed("profile");
          }
        ),
        _SliderTile(
          text: "Log out",
          icon: FontAwesomeIcons.rightFromBracket,
          onTap: () => logout(context)
        ),
        !isUserVerified() ? _SliderTile(
          text: "Validate Email",
          icon: FontAwesomeIcons.envelopeCircleCheck,
          onTap: () => sendValidationEmail(context)
        ) : const SizedBox.shrink(),
      ],
    );
  }
}

class _SliderTile extends StatelessWidget {
  const _SliderTile({super.key, required this.text, required this.icon, required this.onTap});

  final String text;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text),
      leading: Icon(icon),
      onTap: onTap,
    );
  }
}