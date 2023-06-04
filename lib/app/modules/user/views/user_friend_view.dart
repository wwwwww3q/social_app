// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_app/app/custom/widget/search_widget.dart';
import 'package:social_app/app/models/users_model.dart';
import 'package:social_app/app/modules/user/controllers/user_controller.dart';

import '../../../core/utils/utils.dart';
import '../widget/user_friend_card_widget.dart';

class UserFriendView extends StatefulWidget {
  const UserFriendView({super.key});

  @override
  State<UserFriendView> createState() => _UserFriendViewState();
}

class _UserFriendViewState extends State<UserFriendView> with TickerProviderStateMixin {
  late final UserController controller;
  late final TabController tabBarController;
  late final List<Map<String, dynamic>> tabBarWidget;
  final searchText = TextEditingController();

  void onChangedSearchTextUser(String value) {
    HelperReflect.search(
      listOrigin: tabBarWidget[tabBarController.index]['ValueNotifier'],
      listSearch: tabBarWidget[tabBarController.index]['ValueNotifierSearch'],
      nameModel: 'displayName',
      keywordSearch: value,
    );
  }

  @override
  void initState() {
    super.initState();
    controller = Get.find<UserController>(tag: '${int.tryParse(Get.parameters['id'] ?? '') ?? 0}');

    tabBarWidget = [
      {
        'Key': LocaleKeys.SuggetionsForYou,
        'ValueNotifier': controller.listFriendSuggest,
        'ValueNotifierSearch': RxList.from(controller.listFriendSuggest),
        'onChanged': onChangedSearchTextUser,
      },
      {
        'Key': LocaleKeys.YourFriend,
        'ValueNotifier': controller.listFriendOfUser,
        'ValueNotifierSearch': RxList.from(controller.listFriendOfUser),
        'onChanged': onChangedSearchTextUser,
      },
      {
        'Key': LocaleKeys.FriendRequests,
        'ValueNotifier': controller.listFriendRequest,
        'ValueNotifierSearch': RxList.from(controller.listFriendRequest),
        'onChanged': onChangedSearchTextUser,
      },
    ];
    //do call api sau nên lúc đầu mảng sẽ rỗng
    tabBarWidget.forEach((element) {
      (element['ValueNotifier'] as RxList).listen((p0) {
        //update lại biến search khi api call thành công
        element.update('ValueNotifierSearch', (valueNotifierSearch) => (valueNotifierSearch as RxList)..value = p0);
      });
    });

    tabBarController = TabController(length: tabBarWidget.length, vsync: this);

    controller.onInitDataUserFriend();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //huy keyboard khi bam ngoai man hinh
      onTap: () => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // extendBody: true,
        extendBodyBehindAppBar: true,
        body: RefreshIndicator(
          onRefresh: () async {},
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                floating: true, //giuu lau bottom
                pinned: true, //giuu lai bottom
                snap: true,
                title: Text(
                  LocaleKeys.Friend.tr,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 30,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight + 48),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TabBar(
                        controller: tabBarController,
                        tabs: tabBarWidget.map((e) => Tab(text: (e['Key'] as String).tr)).toList(),
                        isScrollable: true,
                        indicatorColor: Theme.of(context).colorScheme.secondary,
                        // indicatorSize: TabBarIndicatorSize.label,
                        //duong` vien`
                        indicatorPadding: const EdgeInsets.all(8),
                        splashBorderRadius: BorderRadius.circular(100),
                        indicator: ShapeDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          shape: const StadiumBorder(),
                        ),
                        labelColor: Theme.of(context).colorScheme.primary,
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                        // unselectedLabelColor: Theme.of(context).colorScheme.secondary,
                      ),
                      AnimatedBuilder(
                        animation: tabBarController,
                        builder: (context, child) => SearchWidget(
                          controller: searchText,
                          onChanged: tabBarWidget[tabBarController.index]['onChanged'] as Function(String)?,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            body: TabBarView(
              controller: tabBarController,
              children: [
                ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    Obx(() => Column(
                          children: (tabBarWidget[0]['ValueNotifierSearch'] as RxList).map((e) {
                            e as UsersModel;
                            return UserFriendCardWidget(
                              title: e.displayName!,
                              image: NetworkImage(e.avatar!),
                              action1: (
                                LocaleKeys.AddFriend.tr,
                                () => controller.call_requestAddFriend(e.id!),
                              ),
                              action2: (
                                LocaleKeys.Remove.tr,
                                () {},
                              ),
                            );
                          }).toList(),
                        )),
                  ],
                ),
                //
                ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    Obx(() => Column(
                          children: (tabBarWidget[1]['ValueNotifierSearch'] as RxList).map((e) {
                            e as UsersModel;
                            return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(e.avatar!),
                                ),
                                title: Text(e.displayName ?? ''),
                                trailing: IconButton(
                                  icon: const Icon(Icons.more_horiz),
                                  onPressed: () => showBottomSheetOptionFriend(e),
                                ));
                          }).toList(),
                        )),
                  ],
                ),
                //
                ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    Obx(() => Column(
                          children: (tabBarWidget[2]['ValueNotifierSearch'] as RxList).map((e) {
                            e as Map<String, dynamic>;
                            return UserFriendCardWidget(
                              title: e['displayName'] ?? '',
                              image: NetworkImage(e['avatar'] ?? ''),
                              action1: (
                                LocaleKeys.Accept.tr,
                                () => controller.call_acceptFriendRequest(e['user_request']), //
                              ),
                              action2: (
                                LocaleKeys.Remove.tr,
                                () {},
                              ),
                            );
                          }).toList(),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
        //Footer
      ),
    );
  }

  void showBottomSheetOptionFriend(UsersModel usersModel) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          // <-- SEE HERE
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        isScrollControlled: true,
        builder: (context) {
          return SizedBox(
            // height: MediaQuery.of(context).size.height * 0.5,
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(usersModel.avatar!),
                  ),
                  title: Text(usersModel.displayName!),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(MdiIcons.facebookMessenger),
                  title: Text(LocaleKeys.Message.tr),
                  trailing: const Icon(Icons.navigate_next_outlined),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(MdiIcons.accountMinusOutline),
                  title: Text(LocaleKeys.UnFollow.tr),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(MdiIcons.accountCancelOutline),
                  title: Text(LocaleKeys.Block.tr),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(MdiIcons.accountOffOutline, color: Colors.red),
                  title: Text(
                    LocaleKeys.UnFriend.tr,
                    style: const TextStyle(color: Colors.red),
                  ),
                  onTap: () async{
                    await controller.call_unFriend(usersModel.id!);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }
}