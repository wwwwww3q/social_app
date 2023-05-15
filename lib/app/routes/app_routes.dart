// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';
// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart

abstract class Routes {
  // subroute not start & end with "/"

  static String MESSAGE() => '/message';
  static String MESSAGE_SEARCH() => '/message/search';
  static String MESSAGE_DETAIL(String id) => '/message/detail/$id';
  static String MESSAGE_SETTING_PROFILE(String id) => '/message/settingProfile/$id';
  static String MESSAGE_SETTING_PROFILE_MEMBERS(String id) => '${MESSAGE_SETTING_PROFILE(id)}/members';
  //
  static String GROUP(String id) => '/group/$id';
  static String GROUP_INFOMATION(String id) => '${GROUP(id)}/infomation';
  static String GROUP_INFOMATION_MEMBERS(String id) => '${GROUP_INFOMATION(id)}/members';
  //
  static String USER(String id) => '/user/$id';
}
