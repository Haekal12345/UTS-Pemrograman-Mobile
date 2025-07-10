import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'model_post.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key});

  Future<Post> fetchPost(String id) async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'));
    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Post tidak ditemukan');
    }
  }

  @override
  Widget build(BuildContext context) {
    final postId = Get.parameters['id'];

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Post')),
      body: FutureBuilder<Post>(
        future: fetchPost(postId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final post = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("ID Post: ${post.id}"),
                  const SizedBox(height: 10),
                  Text(post.body, textAlign: TextAlign.justify),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/comment/${post.id}');
                    },
                    child: const Text('View Comments'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Post tidak ditemukan'));
          }
        },
      ),
    );
  }
}