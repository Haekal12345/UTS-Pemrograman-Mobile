import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model_post.dart';

class CommentPage extends StatelessWidget {
  const CommentPage({super.key});

  Future<(Post, List<Comment>)> fetchPostAndComments(String postId) async {
    final postRes = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId'));
    final commentRes = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId/comments'));

    if (postRes.statusCode == 200 && commentRes.statusCode == 200) {
      final post = Post.fromJson(jsonDecode(postRes.body));
      final comments = (jsonDecode(commentRes.body) as List)
          .map((e) => Comment.fromJson(e))
          .toList();
      return (post, comments);
    } else {
      throw Exception('Gagal mengambil data post atau komentar');
    }
  }

  @override
  Widget build(BuildContext context) {
    final postId = Get.parameters['id']!;

    return Scaffold(
      appBar: AppBar(title: const Text('Comment Post')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<(Post, List<Comment>)>(
          future: fetchPostAndComments(postId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final post = snapshot.data!.$1;
              final comments = snapshot.data!.$2;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name: ${comment.name}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text("User ID: ${comment.id}"),
                                Text("Email: ${comment.email}"),
                                const SizedBox(height: 8),
                                const Text("Comment:"),
                                Text(
                                  comment.body,
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('Tidak ada komentar'));
            }
          },
        ),
      ),
    );
  }
}