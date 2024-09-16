import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lol/admin/screens/announcements/announcement_detail.dart';
import 'package:lol/constants/constants.dart';
import 'package:lol/utilities/navigation.dart';

import '../../../shared/components/components.dart';

class AddAnouncment extends StatefulWidget {

  @override
  State<AddAnouncment> createState() => _AddAnouncmentState();
}

class _AddAnouncmentState extends State<AddAnouncment> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  double _height = 80;
  bool isExpanded = false;
  bool showContent = false;

  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var descriptionController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: drawerBuilder(context),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          backgroundEffects(),
          Container
          (
            margin: const EdgeInsetsDirectional.only(top: 50),
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column
              (
                children:
                [
                  //back button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children:
                      [
                        MaterialButton(onPressed: (){Navigator.pop(context);}, child: Icon(Icons.arrow_back, color: Colors.white, size: 30,), padding: EdgeInsets.zero,),
                      ],
                    ),
                  ),
                  adminTopTitleWithDrawerButton(scaffoldKey: scaffoldKey, title: 'Announcements', size: 32, hasDrawer: true),
                  GestureDetector(
                    onTap: ()
                    {
                        isExpanded = true; // Toggle the expansion
                        _height = 370 ;
                      Future.delayed(Duration(milliseconds: 300), (){setState(() {
                        showContent = true;
                      });});
                    },
                    child: AnimatedContainer(
                      margin: EdgeInsetsDirectional.symmetric(vertical: 20, horizontal: 10),
                      duration: Duration(milliseconds: 500),
                      width: double.infinity,
                      height: _height,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: HexColor('B8A8F9').withOpacity(0.20)),
                      curve: Curves.fastEaseInToSlowEaseOut,
                      child: isExpanded && showContent ?  Padding(
                        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10.0, vertical: 10),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children:
                           [
                             //Title Text Input
                             TextFormField
                             (
                               controller: titleController,
                               validator: (value){
                                 if( value == null || value.isEmpty )
                                 {
                                   return 'This field must not be Empty';
                                 }
                                 return null;
                               },
                               decoration: InputDecoration
                               (
                                 hintText: 'Title',
                                 hintStyle: TextStyle(fontSize: 20, color: Colors.grey[400]),
                                 border: InputBorder.none,
                               ),
                               style: TextStyle(color: Colors.white),
                             ),
                             divider(),
                             SizedBox(height: 10,),
                             //Link Input text Field
                             TextFormField
                             (
                               controller: descriptionController,
                               minLines: 5,
                               maxLines: 5,
                               decoration: InputDecoration
                               (
                                 hintText: 'Description',
                                 hintStyle: TextStyle(fontSize: 20, color: Colors.grey[400]),
                                 border: InputBorder.none,
                               ),
                               style: TextStyle(color: Colors.white),
                               validator: (value){
                                 if( value == null || value.isEmpty )
                                 {
                                   return 'This field must not be Empty';
                                 }
                                 return null;
                               },
                             ),
                             const SizedBox(height: 10,),
                             divider(),
                             const SizedBox(height: 10,),
                             //Link Input text Field
                             TextFormField
                             (
                               controller: dateController,
                               keyboardType: TextInputType.datetime,
                               onTap: () => showDatePicker(
                                 context: context,
                                 initialDate: DateTime.now(),
                                 firstDate: DateTime.now(),
                                 lastDate: DateTime.parse('2030-12-31'),
                               ).then((value)
                               {
                                 if (value != null)
                                 {
                                   //print(DateFormat.YEAR_MONTH_DAY);
                                   dateController.text = DateFormat.yMMMd().format(value);
                                 }
                               }
                               ),
                               validator: (value)
                               {
                                 if (value == null || value.isEmpty)
                                 {
                                   return 'Date must not be EMPTY!!';
                                 }
                                 return null;
                               },
                               decoration: InputDecoration
                               (
                                 suffixIcon: Icon(Icons.date_range, color: Colors.grey,),
                                 hintText: 'Due Date',
                                 hintStyle: TextStyle(fontSize: 20, color: Colors.grey[400]),
                                 border: InputBorder.none,
                               ),
                               style: TextStyle(color: Colors.white),
                             ),
                             divider(),
                             Spacer(),
                             //Cancel and Submit buttons
                             Padding(
                               padding: const EdgeInsetsDirectional.symmetric( horizontal: 10.0),
                               child: Row(
                                 children: [
                                   ElevatedButton(onPressed: ()
                                   {
                                     setState(()
                                     {
                                       titleController.text = '';
                                       dateController.text = '';
                                       descriptionController.text = '';
                                        isExpanded = false; // Toggle the expansion
                                        _height = 80;
                                        showContent = false;
                                      });
                                   },
                                   child: Text('Canel'), style: ElevatedButton.styleFrom(padding: EdgeInsetsDirectional.symmetric(horizontal: 35),  backgroundColor: HexColor('D9D9D9').withOpacity(0.2), foregroundColor: Colors.white, textStyle: TextStyle(fontSize: 15),),),
                                   Spacer(),
                                   ElevatedButton(onPressed: (){
                                     if(formKey.currentState!.validate())
                                     {
                                         print('nigga');
                                     }
                                   }, child: Text('Submit'), style: ElevatedButton.styleFrom(padding: EdgeInsetsDirectional.symmetric(horizontal: 40), backgroundColor: HexColor('B8A8F9'), foregroundColor: Colors.white, textStyle: TextStyle(fontSize: 15),)),
                                 ],
                               ),
                             )
                           ],
                          ),
                        ),
                      ) : Padding(
                        padding: EdgeInsetsDirectional.symmetric(vertical: 10, horizontal: 15),
                        child: Row(
                          children: [
                            Text('Add New', style: TextStyle(fontSize: 30, color: Colors.white),),
                            Spacer(),
                            Icon(Icons.add, color: Colors.white, size: 40,),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) => announcementBuilder(context),
                    separatorBuilder: (context, index) =>  const SizedBox(height: 10,),
                    itemCount: 10,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget announcementBuilder(context)
  {
    return GestureDetector(
      onTap: () => navigate(context, AnnouncementDetail('Nigga', 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOjUsImlhdCI6MTcyNjQ5MjkxNSwiZXhwIjoxNzU3NTk2OTE1fQ.BeJ5fUKn50WDF8N4BU3ifWFFsLJG3e4FeSpkBAh3PNc\n \n Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOjUsImlhdCI6MTcyNjQ5MjkxNSwiZXhwIjoxNzU3NTk2OTE1fQ.BeJ5fUKn50WDF8N4BU3ifWFFsLJG3e4FeSpkBAh3PNc', '1/2/3300',)),
      child: Container
      (
        margin: EdgeInsetsDirectional.symmetric(horizontal: 10),
        padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
        height: 80,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: HexColor('B8A8F9')),
        child: Row(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: screenWidth(context) - 140),
                child: Text('Lorem Ipsum dollor ad;fkajd;lfkja;ldfjsad;lfk', style: TextStyle(fontSize: 20, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis,),
            ),
            MaterialButton(
              onPressed: () {
                // Add action for X button
              },
              shape: const CircleBorder(), // X icon
              minWidth: 0, // Reduce min width to make it smaller
              padding: const EdgeInsets.all(5), // Circular button
              child: const Icon(Icons.edit, color: Colors.green,), // Padding for icon
            ),
            MaterialButton(
              onPressed: () {
                // Add action for X button
              },
              shape: const CircleBorder(), // X icon
              minWidth: 0, // Reduce min width to make it smaller
              padding: const EdgeInsets.all(5), // Circular button
              child: const Icon(Icons.delete_sharp, color: Colors.red,), // Padding for icon
            ),
          ],
        ),
      ),
    );
  }
}
