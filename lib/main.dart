import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PixabayPage(),
    );
  }
}

class PixabayPage extends StatefulWidget {
  const PixabayPage({super.key});

  @override
  State<PixabayPage> createState() => _PixabayPageState();
}

class _PixabayPageState extends State<PixabayPage> {
  List imageList = [];

  Future<void> fetchImages(String text) async {
    Response response = await Dio().get(
      'https://pixabay.com/api/?key=48037664-fa3e31e932f813dc930fb2625&q=$text&image_type=photo&per_page=100&pretty=true',
    );
    imageList = response.data['hits'];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // 最初に一度だけ画像データを取得
    fetchImages('花');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
          ),
          onFieldSubmitted: (text) {
            // ignore: avoid_print
            print(text);
            fetchImages(text);
          },
        ),
        backgroundColor: Colors.blue,
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 横に並べる数
        ),
        itemCount: imageList.length, // 要素数
        itemBuilder: (context, index) {
          Map<String, dynamic> image = imageList[index];
          // URLをつかった画像表示は Image.network(表示したいURL) 
          return Stack(
            children: [
              Image.network(image['previewURL']),
              Container(
                color: Colors.white,
                child: Text('${image['likes']}'),
              ),
            ],
          );
        },
      ),
    );
  }
}