package io.flutter.plugins.firebasemessaging;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

public class FlutterFirebaseMessagingService extends FirebaseMessagingService {
    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        // Aquí puedes manejar la recepción de las notificaciones push y realizar acciones en consecuencia.
        // Por ejemplo, mostrar una notificación en la bandeja de notificaciones, actualizar la interfaz de usuario, etc.
    }

    @Override
    public void onNewToken(String token) {
        // Aquí puedes manejar la generación o actualización del token de registro de dispositivos.
        // Por ejemplo, enviar el token al servidor de backend para enviar notificaciones push específicas al dispositivo.
    }
}
