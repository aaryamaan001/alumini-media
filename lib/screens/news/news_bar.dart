import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/utils/constants.dart';
import 'dart:ui' as ui;

import 'package:social_media_app/models/article.dart';
import 'package:social_media_app/utils/global_variables.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsBar extends StatefulWidget {
  const NewsBar({super.key});

  @override
  State<NewsBar> createState() => _NewsBarState();
}

class _NewsBarState extends State<NewsBar> {
  final Dio dio = Dio();

  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    _getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "News",
        ),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    final width = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return Container(
          margin: EdgeInsets.symmetric(
              horizontal: width > webScreenSize ? width * 0.3 : 0,
              vertical: width > webScreenSize ? 15 : 0),
          child: ListTile(
            onTap: () {
              _launchUrl(
                Uri.parse(article.url ?? ""),
              );
            },
            leading: Image.network(
              article.urlToImage ?? PLACEHOLDER_IMAGE_LINK,
              height: 250,
              width: 100,
              fit: BoxFit.cover,
            ),
            title: Text(
              article.title ?? "",
            ),
            subtitle: Text(
              article.publishedAt ?? "",
            ),
          ),
        );
      },
    );
  }

  Future<void> _getNews() async {
    final response = await dio.get(
      'https://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=$news_api_key',
    );
    final articlesJson = response.data["articles"] as List;
    setState(() {
      List<Article> newsArticle =
          articlesJson.map((a) => Article.fromJson(a)).toList();
      newsArticle = newsArticle.where((a) => a.title != "[Removed]").toList();
      articles = newsArticle;
    });
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
