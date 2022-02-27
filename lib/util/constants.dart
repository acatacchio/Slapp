//FirebaseKeys
import 'package:flutter/material.dart';
import 'package:slapp/model/color_theme.dart';

String uidKey = "uid";
String nameKey = "name";
String surnameKey = "surname";
String imageUrlKey = "imageUrl";
String followersKey = "followers";
String followingKey = "following";
String refKey = "ref";
String documentIdKey = "documentId";
String descriptionKey = "description";
String likeKey = "likes";
String commentKey = "comments";
String dateKey = "date";
String textKey = "text";
String postIdKey = "PostId";
String seenKey = "seen";
String memberRef = "member";
String typeKey = "type";
String like = "Like";
String follow = "Follow";
String comment = "Comment";
String showPost = "ShowPost";


Icon homeIcon = const Icon(Icons.house_rounded);
Icon friendsIcon = const Icon(Icons.search_outlined);
Icon writePost = const Icon(Icons.add_box_outlined, size: 35,);
Icon organizationIcon = const Icon(Icons.group);
Icon profileIcon = const Icon(Icons.account_circle_outlined);
Icon cameraIcon = const Icon(Icons.camera_alt_outlined);
Icon libraryIcon = const Icon(Icons.photo_library_outlined);
Icon likeIcon = Icon(Icons.favorite, color: ColorTheme().textGrey(),size: 20,);
Icon unlikeIcon = Icon(Icons.favorite_border, color: ColorTheme().textGrey(),size: 20,);
Icon commentIcon = Icon(Icons.message_rounded, color: ColorTheme().textGrey(),size: 20,);