import 'package:ckc_social_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:ckc_social_app/app/modules/user/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../core/utils/utils.dart';
import '../../../routes/app_pages.dart';

class UserView extends GetView<UserController> {
  const UserView({super.key});

  @override
  String? get tag => '${int.tryParse(Get.parameters['id'] ?? '') ?? 0}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Column(
            children: <Widget>[
              controller.obx((state) => Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          Container(
                            height: 200.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(controller.state!.coverImage!),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 100.0,
                            child: Container(
                              height: 190.0,
                              width: 190.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(state!.avatar!),
                                  ),
                                  border: Border.all(color: Theme.of(context).colorScheme.inversePrimary, width: 6.0)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 100),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            state.displayName!,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                          ),
                          const SizedBox(width: 5.0),
                          Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'Mo ta ve ban than...',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  )),
              const SizedBox(height: 10.0),
              _buildColumnActionIcon(),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Column(
                  children: <Widget>[
                    controller.obx((state) => buildInfomation(controller)),
                    const Divider(),
                    // Photo & Friend nen viet base TabView
                    _buildPhotos(),
                    const Divider(),
                    _buildFriends(),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void _showMoreOption(BuildContext context) {
    showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (controller.userId == AuthenticationController.userAccount!.id!) ...[
                      ListTile(
                        onTap: () => Get.toNamed(Routes.USER_EDITING('${controller.userId}')),
                        contentPadding: EdgeInsets.zero,
                        // minVerticalPadding: 10,
                        // visualDensity: VisualDensity.compact,
                        leading: const Icon(Icons.edit_outlined),
                        title: Text(LocaleKeys.UpdateMyProfile.tr),
                        // isThreeLine: true,
                      ),
                      ListTile(
                        onTap: () {
                          final _formKey = GlobalKey<FormBuilderState>();
                          showDialog<String>(
                              //barrierDismissible: false,
                              context: context,
                              builder: (context) => AlertDialog(
                                    scrollable: true,
                                    title: Text(LocaleKeys.Overview.tr),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    content: FormBuilder(
                                      key: _formKey,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          FormBuilderTextField(
                                              name: 'currentPassword',
                                              decoration: InputDecoration(
                                                iconColor: Colors.red,
                                                icon: const Icon(Icons.key_outlined),
                                                labelText: LocaleKeys.OldPassword.tr,
                                              ),
                                              validator: FormBuilderValidators.compose([
                                                FormBuilderValidators.required(),
                                                FormBuilderValidators.minLength(6),
                                              ])),
                                          FormBuilderTextField(
                                              name: 'password',
                                              decoration: InputDecoration(
                                                iconColor: Colors.green,
                                                icon: const Icon(Icons.vpn_key_outlined),
                                                labelText: LocaleKeys.NewPassword.tr,
                                              ),
                                              validator: FormBuilderValidators.compose([
                                                FormBuilderValidators.required(),
                                                FormBuilderValidators.minLength(6),
                                              ])),
                                          FormBuilderTextField(
                                              name: 'confirmPassword',
                                              decoration: InputDecoration(
                                                iconColor: Colors.blue,
                                                icon: const Icon(Icons.vpn_key_outlined),
                                                labelText: LocaleKeys.ConfirmNewPassword.tr,
                                              ),
                                              validator: FormBuilderValidators.compose([
                                                FormBuilderValidators.required(),
                                                FormBuilderValidators.minLength(6),
                                                (value) => (value != _formKey.currentState!.fields['password']!.value)
                                                    ? LocaleKeys.PasswordNotMatch.tr
                                                    : null,
                                              ])),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      OutlinedButton(onPressed: () => Navigator.of(context).maybePop(), child: Text(LocaleKeys.Cancel.tr)),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!.saveAndValidate()) {
                                            controller.call_updatePasswordUser(_formKey.currentState!.value);
                                          }
                                        },
                                        // style: ElevatedButton.styleFrom(backgroundColor: Get.theme.colorScheme.secondary),
                                        child: Text(LocaleKeys.Confirm.tr),
                                      ),
                                    ],
                                  ));
                        },
                        contentPadding: EdgeInsets.zero,
                        iconColor: Colors.grey,
                        textColor: Colors.grey,
                        // minVerticalPadding: 10,
                        // visualDensity: VisualDensity.compact,
                        leading: const Icon(Icons.lock_outline),
                        title: Text(LocaleKeys.ChangePassword.tr),
                        // isThreeLine: true,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        });
  }

  static Widget buildInfomation(UserController controller) {
    final data = [
      {
        'title': LocaleKeys.DisplayName.tr,
        'value': 'displayName',
        'icon': Icons.visibility_outlined,
        'format': 'text',
      },
      {
        'title': LocaleKeys.Email.tr,
        'value': 'email',
        'icon': Icons.mail_outline,
        'format': 'text',
      },
      {
        'title': LocaleKeys.WentFrom.tr,
        'value': 'went_to',
        'icon': Icons.place_outlined,
        'format': 'text',
      },
      {
        'title': LocaleKeys.LiveIn.tr,
        'value': 'live_in',
        'icon': Icons.home_outlined,
        'format': 'text',
      },
      {
        'title': LocaleKeys.Relationship.tr,
        'value': 'relationship',
        'icon': Icons.favorite_outline,
        'format': 'Relationship',
      },
      {
        'title': LocaleKeys.Phone.tr,
        'value': 'phone',
        'icon': Icons.phone_outlined,
        'format': 'text',
      },
      {
        'title': LocaleKeys.Birthday.tr,
        'value': 'date_of_birth',
        'icon': Icons.date_range_outlined,
        'format': 'date',
      },
      {
        'title': LocaleKeys.Address.tr,
        'value': 'address',
        'icon': Icons.location_city_outlined,
        'format': 'text',
      },
    ];

    final userJson = controller.state!.toJson();

    return Builder(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...Helper.listGenerateSeparated(
            data.length,
            generator: (index) {
              final item = data[index];

              final String text;
              switch (item['format']) {
                case 'date':
                  text = Helper.tryFormatDateTime(userJson[item['value']] ?? '');
                  break;
                case 'Relationship':
                  text = Relationship.fromValue(userJson[item['value']]).title;
                  break;
                default:
                  text = userJson[item['value']] ?? '';
              }
              return SizedBox(
                width: double.infinity,
                child: Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(child: Icon(item['icon'] as IconData)),
                      const WidgetSpan(child: SizedBox(width: 5.0)),
                      TextSpan(text: "${item['title']}: "),
                      TextSpan(
                        text: text,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  // overflow: TextOverflow.ellipsis,
                ),
              );
            },
            separator: (index) => const SizedBox(width: 5.0),
          ),
          // const SizedBox(height: 10.0),
          // SizedBox(
          //   width: double.infinity,
          //   child: ElevatedButton(
          //     onPressed: () {},
          //     child: const Text('see more about Mohsin'),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildColumnActionIcon() => Builder(
      builder: (context) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.collections, color: Theme.of(context).colorScheme.primary),
                  ),
                  Text(
                    'following',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(MdiIcons.facebookMessenger),
                  ),
                  Text(
                    LocaleKeys.Message.tr,
                    // style: TextStyle(color: Colors.black),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      _showMoreOption(context);
                    },
                  ),
                  const Text(
                    'More',
                    // style: TextStyle(color: Colors.black),
                  )
                ],
              )
            ],
          ));

  Widget _buildPhotos() => Builder(
        builder: (context) => Column(
          children: [
            Row(
              children: [
                Text(
                  LocaleKeys.Photo.tr,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                _buildViewMoreButton(() => Get.toNamed(Routes.USER_PHOTO('${controller.userId}'))),
              ],
            ),
            controller.listImageUploadOfUser.obx(
              (state) => HelperWidget.buildGridViewImage(
                listData: state!,
                fieldName: 'media_file_name',
                maxLength: state.length > 6 ? 6 : state.length,
              ),
            ),
          ],
        ),
      );

  Widget _buildFriends() => Builder(
      builder: (context) => Column(
            children: [
              Row(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.Friend.tr,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Obx(() => Text('${controller.listFriendOfUser.length} ${LocaleKeys.Friend.tr}')),
                  ],
                ),
                const Spacer(),
                _buildViewMoreButton(() => Get.toNamed(Routes.USER_FRIEND('${controller.userId}'))),
              ]),
              ObxValue(
                  (listFriendOfUser) => GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 20),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: listFriendOfUser.length > 6 ? 6 : listFriendOfUser.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: 0.75,
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (context, index) {
                          final item = listFriendOfUser[index];
                          return Column(
                            children: [
                              InkWell(
                                onTap: () => Get.toNamed(Routes.USER('${item.id}')),
                                child: Ink(
                                  // width: 100,
                                  height: 125,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(item.avatar!),
                                      )),
                                ),
                              ),
                              Text(
                                item.displayName ?? '',
                                maxLines: 2,
                              ),
                            ],
                          );
                        },
                      ),
                  controller.listFriendOfUser)
            ],
          ));

  Widget _buildViewMoreButton(VoidCallback onPressed) => Directionality(
        textDirection: TextDirection.rtl,
        child: TextButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.navigate_before_outlined),
          label: Text(LocaleKeys.ViewMore.tr),
        ),
      );
}
