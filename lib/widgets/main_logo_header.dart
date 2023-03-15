import 'package:flutter/material.dart';

class MainLogoHeader extends StatelessWidget {
  String headerName;

  MainLogoHeader(this.headerName);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 10.0),
          Text(
            headerName,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          SizedBox(height: 10.0),
          Image.network(
            "https://img.freepik.com/free-vector/video-conference-three-persons_603843-1780.jpg?w=826&t=st=1678844722~exp=1678845322~hmac=67677ec24f1ea926a75aee8b647e7e460f3c430d48048c1a0c2973d2e6f142ca",
            height: 200.0,
            width: 200.0,
          ),
          SizedBox(height: 10.0),
          
        ],
      ),
    );
  }
}
