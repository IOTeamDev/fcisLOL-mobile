import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/modules/admin/bloc/admin_cubit.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
        backgroundColor: Colors.blueAccent,
      ),
      body: TextButton(
          onPressed: () async {
            await BlocProvider.of<AdminCubit>(context).sendFCMNotification(
                title: "new one",
                body: "new two",
                token:
                    "chUAaG_7Tu68jnmU8UpxSN:APA91bHgHAocyXqRhWLeSw7NFepQMKaefT1i0ust8oQVvYsS1kt4OGk0wXHAqD3U6Erciw1IyPS5FUPNwxgkeNEXF4Q5W76GbTS-NZSexTaZNdLQCq1SZZzDkh23RHktWgqd7vBZLRRn");
          },
          child: Text("Press")),
    );
  }
}
  // Simple team member card with name and role