import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import 'package:project_topics_movil/src/models/index.dart';
import 'package:project_topics_movil/src/widgets/index.dart';
import 'package:project_topics_movil/src/utils/index.dart';

class ComplaintItem extends StatelessWidget {
  const ComplaintItem({super.key, required this.complaint, this.delay});

  final Complaint complaint;
  final int? delay;

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      delay: Duration(milliseconds: 85 * (delay ?? 1)),
      child: Container(
        width: 350,
        height: 170,
        decoration: BoxDecoration(
          color: StateColors.stateColors(complaint.state),
          // gradient: LinearGradient(
          //   colors: [Colors.blue.shade700, Colors.blue.shade900],
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          // ),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Stack(
          children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(10),
            //   child: ColorFiltered(
            //     colorFilter:
            //         const ColorFilter.mode(Colors.black38, BlendMode.darken),
            //     child: SizedBox(
            //       width: 355,
            //       height: 170,
            //       child: Image.asset(
            //         'assets/fondos/fondo$randomNumber.jpg',
            //         fit: BoxFit.cover,
            //         alignment: Alignment.center,
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title and State
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              complaint.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            // Description
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                complaint.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ACTIONS (SHOW, EDIT, DELETE)
                      PopupMenuButton(
                        padding: const EdgeInsets.only(bottom: 30),
                        // icon: const Icon(Icons.arrow_drop_down_circle),
                        color: Colors.white,
                        iconSize: 30,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'ver',
                            child: Row(
                              children: [
                                Icon(Icons.remove_red_eye),
                                SizedBox(width: 10),
                                Text('Ver'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            enabled: complaint.state != 'rechazado' &&
                                complaint.state != 'aceptado',
                            value: 'editar',
                            child: const Row(
                              children: [
                                Icon(Icons.edit),
                                SizedBox(width: 10),
                                Text('Editar'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            enabled: complaint.state != 'rechazado' &&
                                complaint.state != 'aceptado',
                            value: 'eliminar',
                            child: const Row(
                              children: [
                                Icon(Icons.delete),
                                SizedBox(width: 10),
                                Text('Eliminar'),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (value) => _onSelect(context, value),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // State
                      Badge(
                        backgroundColor:
                            StateColors.badgeStateColor(complaint.state),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        label: Text(
                          complaint.state,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      // Date
                      Row(
                        children: [
                          const Icon(Icons.date_range, color: Colors.white),
                          const SizedBox(width: 5),
                          Text(
                            complaint.createdAt.toString().substring(0, 10),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onSelect(BuildContext context, String value) {
    // Verificar que la contrasena ha sido cambiado en 30 dias
    final expired = isExpired();
    if (expired) {
      showPasswordExpiredMessage(context);
      return;
    }

    if (value == 'ver') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ComplaintShow(complaint: complaint.copy()),
        ),
      );
      return;
    }

    if (value == 'editar') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ComplaintCard(complaint: complaint.copy()),
        ),
      );
      return;
    }
    // value == eliminar
    showDeleteMessage(context, '${complaint.id}');
  }
}
