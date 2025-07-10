import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'post_list.dart';
import 'post_detail.dart';
import 'comment_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'UTS Post - Comment',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const PostListScreen()),
        GetPage(name: '/detail/:id', page: () => const PostDetailScreen()),
        GetPage(name: '/comment/:id', page: () => const CommentPage()),
      ],
    );
  }
}
