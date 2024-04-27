import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetEvents extends StatelessWidget {
  final String documentId;
  GetEvents({required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference event = FirebaseFirestore.instance.collection('event');
    return FutureBuilder<DocumentSnapshot>(
      future: event.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          
          Map<String, dynamic>? data =
              snapshot.data?.data() as Map<String, dynamic>?;

          if (data != null) {
            String? title = data['title'];
            String? location = data['location'];
            String? description = data['description'];
            String? dateTime = data['dateTime'];
            String? attendanceLimit = data['attendanceLimit'];
            List<dynamic>? imageUrls = data['imageUrls']; // Lista de URLs de imagens

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrls != null) // Verifique se há URLs de imagens
                  Wrap(
                    children: List.generate(
                      imageUrls.length,
                      (index) => Image.network(
                        imageUrls[index],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                Text('Event: ${title ?? ''}'),
                Text('Location: ${location ?? ''}'),
                Text('Description: ${description ?? ''}'),
                Text('Date Time: ${dateTime ?? ''}'),
                Text('Attendance Limit: ${attendanceLimit ?? ''}'),
              ],
            );
          } else {
            return Text('Data not found');
          }
        }
        return Text('Loading...');
      },
    );
  }
}
