import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_topics_movil/src/services/complaint_service.dart';

class ShowMessage {
  static Future<dynamic> messageSimple(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  static Future<dynamic> showDeleteMessage(BuildContext context, String id) {
    final navigator = Navigator.of(context);
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alerta!'),
        content: const Text('Esta seguro de eliminar la denuncia?'),
        actions: [
          TextButton(
            onPressed: () => navigator.pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              ComplaintService complaintService =
                  Provider.of<ComplaintService>(context, listen: false);
              final response = await complaintService.deleteComplaint(id);
              if (response.containsKey('message')) {
                // ignore: use_build_context_synchronously
                messageSimple(context, response['message']);
                return;
              }
              navigator.pop();
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
