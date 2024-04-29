import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class PerfilEvent extends StatelessWidget {
  const PerfilEvent({Key? key}) : super(key: key);

  Future<List<String>> getEventsImages() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('event').get();
    List<String> imageUrls = [];
    querySnapshot.docs.forEach((doc) {
      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('imageUrls')) {
          List<dynamic> urls = data['imageUrls'];
          imageUrls.addAll(urls.map((url) => url.toString()));
        }
      }
    });
    return imageUrls;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getEventsImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          List<String> imageUrls = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: imageUrls.map((url) => Image.network(url)).toList(),
            ),
          );
        } else {
          return Text('No data');
        }
      },
    );
  }
}