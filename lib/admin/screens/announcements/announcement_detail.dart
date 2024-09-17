import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:linkify/linkify.dart';
import 'package:lol/admin/bloc/admin_cubit_states.dart';
import 'package:lol/constants/constants.dart';
import 'package:lol/shared/components/components.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../main/screens/webview_screen.dart';
import '../../bloc/admin_cubit.dart';

class AnnouncementDetail extends StatelessWidget {

  final int id;
  final String title;
  final String description;
  final dynamic date;


  AnnouncementDetail(this.title,  this.description,  this.date, this.id);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminCubit()..getAnnouncements(),
      child: BlocConsumer<AdminCubit, AdminCubitStates>(
        listener: (context, state){
          if(state is AdminDeleteAnnouncementSuccessState)
          {
            showToastMessage(message: 'Announcement Deleted Successfully!!', states: ToastStates.WARNING);
            Navigator.pop(context);
          }
        },
        builder:(context, state) => Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              backgroundEffects(),
              Container(
                margin: const EdgeInsetsDirectional.only(top: 50),
                width: double.infinity,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children:
                        [
                          MaterialButton(onPressed: (){Navigator.pop(context);}, child: Icon(Icons.arrow_back, color: Colors.white, size: 30,), padding: EdgeInsets.zero,),
                        ],
                      ),
                    ),
                    adminTopTitleWithDrawerButton(title: 'Announcement',size: 35, hasDrawer: false),
                    Container(
                      margin: const EdgeInsetsDirectional.symmetric(horizontal: 15, vertical: 20),
                      padding: const EdgeInsets.all(15),
                      width: double.infinity,
                      height: screenHeight(context)/1.45,
                      decoration: BoxDecoration(gradient: LinearGradient(colors: [HexColor('DA22FF').withOpacity(0.45), HexColor('9B35F3').withOpacity(0.45)], begin: Alignment.bottomRight, end: Alignment.topLeft), borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //pfp and name
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStCJpmc7wNF8Ti2Tuh_hcIRZUGOc23KBTx2A&s'), radius: 20,),
                              SizedBox(width: 10,),
                              Text('Name Very Long', style: TextStyle(fontSize: 14, color: Colors.white),),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          Text('$title',style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold),),
                          const SizedBox(height: 20,),
                          Container(
                            padding: const EdgeInsets.all(15),
                            width: double.infinity,
                            decoration: BoxDecoration(color: HexColor('D9D9D9').withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Linkify(
                                  onOpen: (link) => _onOpen(context, link),
                                  text: description,
                                  style: const TextStyle(color: Colors.white, ),
                                  linkStyle: const TextStyle(color: Colors.blue),
                                  linkifiers: [UrlLinkifier(), EmailLinkifier(), PhoneNumberLinkifier(), ],
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.symmetric(vertical: 25.0),
                                  child: Text('DeadLine: $date', style: const TextStyle(color: Colors.white, ),),
                                ),
                                if(true)
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(top: 10.0),
                                    child: Row
                                      (
                                      children: [
                                        ElevatedButton(onPressed: (){
                                          AdminCubit.get(context).deleteAnnouncement(AdminCubit.get(context).announcements![id].id);
                                        }, child: const Text('Remove', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),), style: ElevatedButton.styleFrom(backgroundColor: Colors.red.withOpacity(0.76), foregroundColor: Colors.white, padding: EdgeInsetsDirectional.symmetric(horizontal: 30)),),
                                        const Spacer(),
                                        ElevatedButton(onPressed: (){}, child: const  Text('Edit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),), style: ElevatedButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.35), foregroundColor: Colors.white, padding: EdgeInsetsDirectional.symmetric(horizontal: 40)),),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onOpen(BuildContext context, LinkableElement link) async {
    final url = link.url;

    // Check if the link is a Facebook link
    if (url.contains('facebook.com')) {
      // Open Facebook links directly using `url_launcher`
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    } else {
      // For other links, open them using WebView
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebviewScreen(url),
        ),
      );
    }
  }
}
