import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../modules/authentication/controllers/authentication_controller.dart';
import '../utils/utils.dart';

class FireBaseService with ChangeNotifier {
  FireBaseService() {
    Printt.white('Create Service: ${runtimeType}');
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> call_getChatRoom(String chatRoomId) {
    return _firestore.collection('chatRoom/$chatRoomId/chats').orderBy('created_at', descending: false).snapshots();
  }

  Future<void> call_sendMessage({required String chatRoomId, required String data, required String type}) async {
    await _firestore.collection('chatRoom/$chatRoomId/chats').add({
      'type': type,
      'data': data,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'user': AuthenticationController.userAccount!.toJson(),
    });
  }

  Future<void> call_setStatusUserOnline(String status) async {
    await _firestore.collection('users').doc('${AuthenticationController.userAccount!.id!}').set({'status': status});
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> call_getUser(String id) {
    return _firestore.collection('users').doc(id).snapshots();
  }

  //get group
  Stream<QuerySnapshot<Map<String, dynamic>>> call_getGroupChatOfUser() {
    return _firestore.collection('users/${AuthenticationController.userAccount!.id!}/groups').snapshots();
  }

  //create group
  Future<void> call_createGroupChat({required String chatRoomId, required List<Map<String, dynamic>> members}) async {
    _firestore.collection('chatRoom').doc(chatRoomId).set({
      'updated_at': DateTime.now().millisecondsSinceEpoch,
      'members': members,
    });

    for (var element in members) {
      _firestore.collection('users/${element['id']}/groups').doc(chatRoomId).set({
        'name': 'groupName ' + StringExtension.randomString(5), //rename later
        'id': chatRoomId,
      });
    }

    _firestore.collection('chatRoom/$chatRoomId/chats').add({
      'data': '${AuthenticationController.userAccount!.displayName!} Created This Group.',
      'type': 'notify',
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
  }
}
