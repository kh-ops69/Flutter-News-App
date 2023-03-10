import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:newsapp3/widget/NewsTile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = true;
  List<Map<String, dynamic>> articles = [];

  Future<void> getNews() async {
    String url =
        'http://newsapi.org/v2/top-headlines?country=us&excludeDomains=stackoverflow.com&sortBy=publishedAt&language=en&apiKey=805e3a6c1b404db5a481418ec3cffbbb';
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);
    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((element) {
        if (element['urlToImage'] != null &&
            element['description'] != null &&
            element['content'] != null) {
          articles.add(element);
        }
      });
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("GDSC UVCE News App")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "Latest News from All Over the World!",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            ListView.builder(
              itemCount: articles.length,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    padding: const EdgeInsets.all(8.0),
                    child: NewsTile(
                        articleUrl: articles[index]['url'],
                        title: articles[index]['title'],
                        description: articles[index]['description'],
                        imgUrl: articles[index]['urlToImage'],
                        content: articles[index]['content']));
              },
            ),
          ],
        ),
      ),
    );
  }
}
