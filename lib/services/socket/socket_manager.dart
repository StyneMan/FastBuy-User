import 'package:customer/constant/constant.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketManager {
  static final SocketManager _instance = SocketManager._internal();
  late IO.Socket socket;

  factory SocketManager() {
    return _instance;
  }

  SocketManager._internal() {
    // Initialize the Socket.IO instance here
    // socket = IO.io('your_socket_server_url');
    socket = IO.io(Constant.baseURL2, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false
    });

    socket.connect();
  }
}
