import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PerfilEvent extends StatelessWidget {

  const PerfilEvent({Key? key, }) : super(key: key);

  Future<List<String>> getEventsImages(String documentId) async {
    DocumentSnapshot docSnapshot =
        await FirebaseFirestore.instance.collection('event').doc(documentId).get();
    
    List<String> imageUrls = [];

    if (docSnapshot.exists && docSnapshot.data() != null) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      if (data.containsKey('imageUrls')) {
        List<dynamic> urls = data['imageUrls'];
        imageUrls.addAll(urls.map((url) => url.toString()));
      }
    }

    return imageUrls; 
  }

  @override
  Widget build(BuildContext context) {
    String documentId = "3oJwBkQ5ZDIuTFuPBGq8"; // Coloque o ID do documento aqui
    return FutureBuilder<List<String>>(
      future: getEventsImages(documentId),
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
