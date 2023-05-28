import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:project_topics_movil/src/services/index.dart';
import 'package:project_topics_movil/src/widgets/index.dart';
import 'package:project_topics_movil/src/models/index.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final complaintService = Provider.of<ComplaintService>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ComplaintCard(
                complaint: Complaint(title: '', description: '', photos: []),
              ),
            ),
          );
        },
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text(
              'Historial de denuncias',
              style: TextStyle(fontSize: 20, color: Colors.grey[700]),
            ),
            Text('Mi historial', style: GoogleFonts.bebasNeue(fontSize: 50)),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Divider(color: Colors.grey, thickness: 1),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: complaintService.complaitsList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            complaintService.complaitsList[index].photos[0],
                            height: 75,
                          ),
                        ),
                        title: Text(
                          complaintService.complaitsList[index].title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: const Text(
                          "Aceptado",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios),
                          onPressed: () {
                            complaintService.selectedComplaint =
                                complaintService.complaitsList[index].copy();
                            print(complaintService.selectedComplaint.title);
                            // Navigator.pushNamed(context, 'complaint/show');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ComplaintShow(
                                  complaint: complaintService.selectedComplaint,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
