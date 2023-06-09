import 'package:ckc_social_app/app/core/base/base_project.dart';
import 'package:ckc_social_app/app/modules/group/controllers/group_controller.dart';
import 'package:ckc_social_app/app/modules/post/controllers/post_controller.dart';
import 'package:ckc_social_app/app/modules/search_friend/controllers/search_tag_friend_mixin_controller.dart';
import 'package:ckc_social_app/app/modules/stories/controllers/stories_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../notification/controllers/notification_controller.dart';

class HomeController extends BaseController with SearchTagFriendMixinController {
  // final BaseSearchRequestModel searchRequestModel = BaseSearchRequestModel(pageSize: 10);
  late Map<Widget, Widget> tabBarWidget;
  late TabController tabBarController;
  Map<Widget, Widget>? subTabBarVideoWidget;
  Map<Widget, Widget>? subTabBarGroupWidget;
  TabController? subTabBarVideoController;
  TabController? subTabBarGroupController;

  final PostController postController = PostController();
  final GroupController groupController = GroupController();
  final StoriesController storiesController = StoriesController();
  final NotificationController notificationController = NotificationController();

  //bat event scroll chạm đáy sẽ load thêm api
  late GlobalKey<NestedScrollViewState> globalKeyScrollController;

  @override
  Future<void> onInitData() async {
    //reset data
    globalKeyScrollController = GlobalKey();

    //
    //sau khi RenderUI
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //lấy scrollController của NestedScrollView
      final scrollController = globalKeyScrollController.currentState?.innerController;
      //add event
      scrollController?.addListener(() {
        bool isScrollBottom = scrollController.position.pixels == scrollController.position.maxScrollExtent;
        //nếu đang ở trang HOME và scroll đến cuối danh sách
        if ((!postController.dataResponseIsMaximum) && (tabBarController.index == 0 && isScrollBottom)) {
          postController.loadMoreData();
        }
        //nếu đang ở trang GROUP và scroll đến cuối danh sách
        if ((!groupController.fetchPostGroupController.dataResponseIsMaximum) && (tabBarController.index == 2 && isScrollBottom)) {
          groupController.fetchPostGroupController.loadMoreData();
        }
      });
    });
    call_fetchFriendByUserId();
  }

  @override
  void onPresseSearchTagFriendDone() {
    Get.back();
  }
}
