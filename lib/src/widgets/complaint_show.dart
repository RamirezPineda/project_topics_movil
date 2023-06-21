import 'package:flutter/material.dart';

import 'package:project_topics_movil/src/models/index.dart';

class ComplaintShow extends StatelessWidget {
  const ComplaintShow({super.key, required this.complaint});

  final Complaint complaint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: complaint.photos.length,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 30),
                itemBuilder: (contex, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox(
                        height: 300,
                        width: 230,
                        child: FadeInImage(
                          fit: BoxFit.cover,
                          placeholder: const AssetImage('assets/loading.gif'),
                          image: NetworkImage(complaint.photos[index]),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                complaint.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 0.8),
                  color: Colors.grey[200],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    complaint.state,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                complaint.description,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Text(
                "Fecha: ${complaint.createdAt.toString()}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
