import 'package:flutter/material.dart';

class ComplaintFilter extends StatelessWidget {
  const ComplaintFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [],
      ),
    );
  }
}


// ListTile(
//                       contentPadding: const EdgeInsets.all(10),
//                       leading: IconButton(
//                         onPressed: () {
//                           // SHOW COMPLAINT
//                           complaintService.selectedComplaint =
//                               complaintsListFilter[index].copy();
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ComplaintShow(
//                                 complaint: complaintService.selectedComplaint,
//                               ),
//                             ),
//                           );
//                         },
//                         icon: const Icon(Icons.remove_red_eye_sharp),
//                       ),
//                       title: Text(
//                         complaintsListFilter[index].title,
//                         style: const TextStyle(fontWeight: FontWeight.w500),
//                       ),
//                       subtitle: Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                         child: Badge(
//                           label: Text(
//                             complaintsListFilter[index].state,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w700,
//                               letterSpacing: 2,
//                               fontSize: 12,
//                             ),
//                           ),
//                           backgroundColor: _badgeStateColor(
//                               complaintsListFilter[index].state),
//                         ),
//                       ),
//                       trailing: SizedBox(
//                         width: 100,
//                         child: Row(
//                           children: [
//                             Visibility(
//                               visible: complaintsListFilter[index].state !=
//                                       'rechazado' &&
//                                   complaintsListFilter[index].state !=
//                                       'aceptado',
//                               child: IconButton(
//                                 icon: const Icon(Icons.edit),
//                                 onPressed: () {
//                                   // EDIT COMPLAINT
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => ComplaintCard(
//                                         complaint:
//                                             complaintsListFilter[index].copy(),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                             Visibility(
//                               visible: complaintsListFilter[index].state !=
//                                       'rechazado' &&
//                                   complaintsListFilter[index].state !=
//                                       'aceptado',
//                               child: IconButton(
//                                 onPressed: () {
//                                   //Delete
//                                   showDialog(
//                                     context: context,
//                                     builder: (context) => AlertDialog(
//                                       title: const Text(
//                                           'Esta seguro de eliminar la denuncia?'),
//                                       actions: [
//                                         TextButton(
//                                           onPressed: () {
//                                             Navigator.of(context).pop();
//                                           },
//                                           child: const Text('Cancelar'),
//                                         ),
//                                         TextButton(
//                                           onPressed: () async {
//                                             final response = await complaintService
//                                                 .deleteComplaint(
//                                                     '${complaintsListFilter[index].id}');

//                                             if (response
//                                                 .containsKey('message')) {
//                                               // ignore: use_build_context_synchronously
//                                               showDialog(
//                                                   context: context,
//                                                   builder: (_) => AlertDialog(
//                                                         title: Text(response[
//                                                             'message']),
//                                                       ));
//                                               return;
//                                             }
//                                             // ignore: use_build_context_synchronously
//                                             Navigator.of(context).pop();
//                                           },
//                                           child: const Text(
//                                             'Si eliminar',
//                                             style: TextStyle(color: Colors.red),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                                 icon: const Icon(Icons.delete),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),






// ------------------------------------------

// return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: BorderRadius.circular(8),
//           // border: Border.all(color: Colors.grey.shade300),
//         ),
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Falta de iluminacion en la avenida principal, provoca inseguridad y peligros inminentes.',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Padding(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                     child: Text(
//                       'pendiente',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                         letterSpacing: 1,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),

//             //buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 // SHOW
//                 Column(
//                   children: [
//                     // Show complaint
//                     IconButton(
//                         color: Colors.grey[700],
//                         onPressed: () {},
//                         icon: Icon(Icons.remove_red_eye_sharp)),
//                     Text('Ver'),
//                   ],
//                 ),

//                 // EDIT
//                 Column(
//                   children: [
//                     // Edit complaint
//                     IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
//                     Text('Editar'),
//                   ],
//                 ),

//                 Column(
//                   children: [
//                     // Edit complaint
//                     IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
//                     Text('Eliminar'),
//                   ],
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );