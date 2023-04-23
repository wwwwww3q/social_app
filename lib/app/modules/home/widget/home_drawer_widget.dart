import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/core/constants/translate_key_constant.dart';
import 'package:social_app/app/core/services/translation_service.dart';
import 'package:social_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:social_app/app/widget/check_radio_listtitle.dart';

class HomeDrawerWidget extends StatelessWidget {
  const HomeDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          ...buildClipOvalColor(context),
          ListView(
            padding: EdgeInsets.zero, //remove padding SafeArea
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background-3.png'),
                    fit: BoxFit.cover,
                    opacity: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    buildAvatarEdit(context),
                    const SizedBox(width: 15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'UserName',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'email@gmail.com',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                        const Text(
                          '012938797',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                style: ListTileStyle.drawer,
                leading: const Icon(Icons.favorite_outline),
                title: Text(TranslateKeys.Favorite.tr()),
                trailing: const Icon(Icons.navigate_next_outlined),
              ),
              //download
              const ListTile(
                style: ListTileStyle.drawer,
                leading: Icon(Icons.download_outlined),
                title: Text('Download'),
                trailing: Icon(Icons.navigate_next_outlined),
              ),

              //location
              const ListTile(
                style: ListTileStyle.drawer,
                leading: Icon(Icons.location_on_outlined),
                title: Text('Location'),
                trailing: Icon(Icons.navigate_next_outlined),
              ),
              //display
              const ListTile(
                style: ListTileStyle.drawer,
                leading: Icon(Icons.display_settings_outlined),
                title: Text('Display'),
                trailing: Icon(Icons.navigate_next_outlined),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(),
              ),
              //language

              ExpansionTile(
                leading: const Icon(Icons.language_outlined),
                title: Text(TranslateKeys.Language.tr()),
                children: TranslationService.locales
                    .map((e) => CheckRadioListTile<Locale>(
                          value: e,
                          title: Text(
                            e.toString().tr(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          groupValue: context.locale,
                          onChanged: (value) => TranslationService.changeLocale(value!),
                        ))
                    .toList(),
              ),
              //settings
              ListTile(
                style: ListTileStyle.drawer,
                leading: const Icon(Icons.settings_outlined),
                title: Text(TranslateKeys.Setting.tr()),
                trailing: const Icon(Icons.navigate_next_outlined),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: ElevatedButton.icon(
                  onPressed: () => context.read<AuthenticationController>().onSignOut(),
                  icon: const Icon(Icons.logout_outlined),
                  label: Text(TranslateKeys.LogOut.tr()),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent)),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildClipOvalColor(BuildContext context) => [
        Positioned(
          bottom: -100,
          right: -75,
          child: ClipOval(
            child: Container(
              width: 250,
              height: 250,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          right: 75,
          child: ClipOval(
            child: Container(
              width: 300,
              height: 300,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: -75,
          child: ClipOval(
            child: Container(
              width: 350,
              height: 350,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
        ),
      ];

  Widget buildAvatarEdit(BuildContext context) => Stack(
        children: [
          const CircleAvatar(radius: 50),
          Positioned(
            right: 5,
            bottom: 5,
            child: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                //neu dang hoat dong thi` them cai bo tron` nho? nho?
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green, width: 1),
              ),
              child: const Icon(
                Icons.camera_alt_outlined,
                size: 15,
              ),
            ),
          )
        ],
      );
}