import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetInfo extends StatelessWidget {
  final String docID;

  const GetInfo({Key? key, required this.docID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference events = FirebaseFirestore.instance.collection('event');
    return FutureBuilder<DocumentSnapshot>(
      future: events.doc(docID).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return Text('Document not found');
          }
          var data = snapshot.data!.data() as Map<String, dynamic>;
          var title = data['title'];
          var location = data['location'];
          var imageUrl = data['imageUrl'];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (imageUrl != null && imageUrl.isNotEmpty)
                    ClipOval(
                      child: Image.network(
                        imageUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  SizedBox(width: 10), 
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                          
                            SizedBox(width: 5), 
                            Text(
                              'Title: $title',
                              maxLines: 2, 
                              overflow: TextOverflow.ellipsis, 
                            ),
                          ],
                        ),
                        
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.location_on), 
                  SizedBox(width: 5), 
                  Text(
                    'Location: $location',
                    maxLines: 2, 
                    overflow: TextOverflow.ellipsis, 
                  ),
                ],
              ),
            ],
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
