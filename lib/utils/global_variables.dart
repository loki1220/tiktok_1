import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:tiktok/screens/feed_screen.dart';
import 'package:tiktok/screens/notify.dart';
import 'package:tiktok/screens/profile_screen.dart';
import 'package:tiktok/screens/upload_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  FeedScreen(),
  Text("search"),
  UploadPost(),
  Notify(),
  ProfileScreen(),
];
