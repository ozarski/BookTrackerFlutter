import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class BookCoverImage extends StatefulWidget {
  final String url;
  final Widget noConnectionIcon;

  const BookCoverImage({
    super.key,
    required this.url,
    required this.noConnectionIcon,
  });

  @override
  State<BookCoverImage> createState() => _BookCoverImageState();
}

class _BookCoverImageState extends State<BookCoverImage> {
  late Future<bool> _isConnected;

  @override
  void initState() {
    super.initState();
    _isConnected = checkConnection();
  }

  Future<bool> checkConnection() async {
    var connection = await (Connectivity().checkConnectivity());
    return (connection.contains(ConnectivityResult.wifi) ||
        connection.contains(ConnectivityResult.mobile) ||
        connection.contains(ConnectivityResult.ethernet) ||
        connection.contains(ConnectivityResult.bluetooth));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isConnected,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.noConnectionIcon;
        } else if (snapshot.hasError) {
          return widget.noConnectionIcon;
        } else {
          bool isConnected = snapshot.data ?? false;
          if (isConnected) {
            return Image.network(
              widget.url,
              errorBuilder: (context, error, stackTrace) {
                return widget.noConnectionIcon;
              },
              fit: BoxFit.cover,
            );
          } else {
            return widget.noConnectionIcon;
          }
        }
      },
    );
  }
}
