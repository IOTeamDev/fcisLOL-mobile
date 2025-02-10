import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:lol/core/utils/resources/fonts_manager.dart';
import 'package:lol/core/utils/resources/icons_manager.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit.dart';
import 'package:lol/features/admin/presentation/view_model/admin_cubit/admin_cubit_states.dart';
import 'package:lol/features/admin/presentation/view/announcements/announcement_detail.dart';
import 'package:lol/features/admin/presentation/view/announcements/edit_announcement.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/core/utils/webview_screen.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '../../../../../core/cubits/main_cubit/main_cubit.dart';
import '../../../../../core/utils/resources/colors_manager.dart';
import '../../../../../core/utils/resources/strings_manager.dart';
import '../../../../../core/utils/resources/values_manager.dart';
import '../../../../../main.dart';
import '../../../../../core/utils/components.dart';

class AddAnnouncement extends StatefulWidget {
  final String semester;
  const AddAnnouncement({super.key, required this.semester});

  @override
  State<AddAnnouncement> createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends State<AddAnnouncement> {
  double _height = AppSizesDouble.s80;
  bool _isExpanded = false;
  bool _showContent = false;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? dueDateFormatted;
  String dueDateWord = StringsManager.dueDate.split(StringsManager.dash).join(StringsManager.space);
  String? _selectedItem;
  IconData datePickerIcon = IconsManager.datePickerIcon;
  final Map<TextEditingController, TextDirection> _textDirections = {};
  final List<String> _items = ['Faculty','Summer_Training','Workshop','Final','Practical','Assignment', 'Quiz', 'Other'];



  @override
  void initState() {
    _addDirectionListener(_titleController);
    _addDirectionListener(_descriptionController);
    _dateController.text = dueDateWord;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  return BlocConsumer<AdminCubit, AdminCubitStates>(
      listener: (context, state) {
        if (state is AdminSaveAnnouncementSuccessState) {
          showToastMessage(
              message: StringsManager.announcementAdded,
              states: ToastStates.SUCCESS);
        } else if (state is AdminSaveAnnouncementsErrorState) {
          showToastMessage(
              message: StringsManager.errorOccurred + StringsManager.colon + state.error,
              states: ToastStates.ERROR);
        }

        if (state is AdminDeleteAnnouncementSuccessState) {
          showToastMessage(
              message: StringsManager.announcementDeleted, states: ToastStates.WARNING);
        }
        if (state is AdminDeleteAnnouncementErrorState) {
          showToastMessage(
              message: StringsManager.errorOccurred + StringsManager.colon + state.error,
              states: ToastStates.ERROR);
        }
      },
      builder: (context, state) {
        var cubit = AdminCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(StringsManager.announcements, style: Theme.of(context).textTheme.displayMedium,),
            centerTitle: true,
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: AppSizesDouble.s5),
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = true; // Toggle the expansion
                        _height = AppSizesDouble.s430;
                      });
                      Future.delayed(
                        const Duration(milliseconds: AppSizes.s250), () {
                          setState(() {
                            _showContent = true;
                          });
                        }
                      );
                    },
                    child: AnimatedContainer(
                      margin: const EdgeInsets.symmetric(
                        vertical: AppSizesDouble.s30,
                        horizontal: AppSizesDouble.s10
                      ),
                      duration: const Duration(milliseconds: AppSizes.s380),
                      width: double.infinity,
                      height: _height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSizesDouble.s20),
                        color: MainCubit.get(context).isDark
                            ? ColorsManager.darkPrimary
                            : ColorsManager.lightGrey
                      ),
                      curve: Curves.fastEaseInToSlowEaseOut,
                      child: _isExpanded && _showContent ?
                      Padding(
                        padding: const EdgeInsets.all(AppSizesDouble.s10),
                        child: Form(
                          key: _formKey,
                          child: AnimatedOpacity(
                            opacity: _isExpanded ? AppSizesDouble.s1 : AppSizesDouble.s0,
                            duration: const Duration(milliseconds: AppSizes.s250),
                            curve: Curves.easeInOut,
                            child: Directionality(
                              textDirection: isArabicLanguage(context)?TextDirection.rtl : TextDirection.ltr,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Title Text Input
                                  TextFormField(
                                    controller: _titleController,
                                    textDirection: getTextDirection(_titleController),
                                    validator: _titleValidator,
                                    decoration: InputDecoration(
                                      hintText: StringsManager.title[AppSizes.s0].toUpperCase() + StringsManager.title.substring(AppSizes.s1),
                                      hintStyle: TextStyle(
                                        fontSize: AppSizesDouble.s20,
                                        color: MainCubit.get(context).isDark ? ColorsManager.lightGrey1 : ColorsManager.lightGrey2
                                      ),
                                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: MainCubit.get(context).isDark ? ColorsManager.grey : ColorsManager.white)),
                                    ),
                                    style: TextStyle(color: ColorsManager.white),
                                  ),
                                  const SizedBox(
                                    height: AppSizesDouble.s10,
                                  ),
                                  //Description Input text Field
                                  TextFormField(
                                    controller: _descriptionController,
                                    textDirection: getTextDirection(_descriptionController),
                                    minLines: AppSizes.s5,
                                    maxLines: AppSizes.s5,
                                    decoration: InputDecoration(
                                      hintText: StringsManager.description,
                                      hintStyle: TextStyle(
                                        fontSize: AppSizesDouble.s20,
                                        color: MainCubit.get(context).isDark ? ColorsManager.lightGrey1 : ColorsManager.lightGrey2
                                      ),
                                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: MainCubit.get(context).isDark ? ColorsManager.grey : ColorsManager.white)),),
                                    style: const TextStyle(color: ColorsManager.white),
                                  ),
                                  const SizedBox(height: AppSizesDouble.s15,),
                                  //DatePicker
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () => _datePicker(),
                                          child: Container(
                                            height: AppSizesDouble.s50,
                                            decoration: BoxDecoration(
                                              color: ColorsManager.white,
                                              borderRadius: BorderRadius.circular(AppSizesDouble.s10)
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(_dateController.text, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: ColorsManager.black),),
                                                SizedBox(width: AppSizesDouble.s5,),
                                                InkWell(
                                                  onTap: (){
                                                    if(_dateController.text != dueDateWord){
                                                      setState(() {
                                                        datePickerIcon = IconsManager.datePickerIcon;
                                                        _dateController.text = dueDateWord;
                                                      });
                                                    }
                                                    else{
                                                      _datePicker();
                                                    }
                                                  },
                                                  child: Icon(datePickerIcon, color: ColorsManager.black,)
                                                ),
                                              ],
                                            )
                                          ),
                                        ),
                                      ), //Due Date Picker
                                      SizedBox(width: AppSizesDouble.s10,),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(vertical: AppSizesDouble.s15),
                                            backgroundColor: ColorsManager.white,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizesDouble.s10))
                                          ),
                                          onPressed: (){
                                            setState(() {
                                              cubit.announcementImageFile = null;
                                              cubit.pickerIcon = IconsManager.imageIcon;
                                              cubit.imageName = StringsManager.selectImage;
                                              _getAnnouncementImage(cubit);
                                            });
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                cubit.imageName,
                                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: ColorsManager.black),
                                              ),
                                              SizedBox(
                                                width: AppSizesDouble.s5,
                                              ),
                                              InkWell(
                                                onTap: (){
                                                  if(cubit.announcementImageFile != null) {
                                                    setState(() {
                                                      cubit.announcementImageFile = null;
                                                      cubit.pickerIcon = IconsManager.imageIcon;
                                                      cubit.imageName = StringsManager.selectImage;
                                                    });
                                                  }else{
                                                    _getAnnouncementImage(cubit);
                                                  }
                                                },
                                                child: Icon(
                                                  cubit.pickerIcon,
                                                  color: ColorsManager.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ), // Image Picker
                                    ],
                                  ),
                                  SizedBox(height: AppSizesDouble.s20,),
                                  //Announcement type Drop Down menu
                                  DropdownButton<String>(
                                    hint: const Text(
                                      StringsManager.announcementType,
                                      style: TextStyle(color: ColorsManager.white),
                                    ),
                                    value: _selectedItem,
                                    dropdownColor: ColorsManager.white, // Background color for the dropdown list
                                    iconEnabledColor: ColorsManager.white, // Color of the dropdown icon
                                    style: const TextStyle(color: ColorsManager.white), // Style for the selected item outside the list
                                    items: _items.map((String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(color: ColorsManager.black), // Always black for the list items
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedItem = newValue;
                                      });
                                    },
                                    selectedItemBuilder: (BuildContext context) {
                                      return _items.map((String item) {
                                        return DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(color: ColorsManager.white,),
                                          ),
                                        );
                                      }).toList();
                                    },
                                  ),
                                  const Spacer(),
                                  divider(
                                    color: ColorsManager.lightGrey
                                  ),
                                  //Cancel and Submit buttons
                                  Padding(
                                    padding: const EdgeInsets.all(AppSizesDouble.s10),
                                    child: Row(
                                      children: [
                                        //cancel button
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _titleController.clear();
                                              _dateController.text = dueDateWord;
                                              _descriptionController.clear();
                                              _isExpanded = false; // Toggle the expansion
                                              _height = AppSizesDouble.s80;
                                              _showContent = false;
                                              dueDateFormatted = null;
                                              cubit.announcementImageFile = null;
                                              cubit.imageName = StringsManager.selectImage;
                                              cubit.pickerIcon = IconsManager.imageIcon;
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizesDouble.s13)),
                                            padding: EdgeInsetsDirectional.symmetric(horizontal: AppQueries.screenWidth(context) / AppSizes.s10),
                                            backgroundColor: ColorsManager.white,
                                            foregroundColor: ColorsManager.black,
                                            textStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize:  AppQueries.screenWidth(context) / AppSizes.s17),
                                          ),
                                          child: const Text(StringsManager.cancel,),
                                        ),
                                        const Spacer(),
                                        //submit button
                                        ElevatedButton(
                                          onPressed: () async {
                                            if (_formKey.currentState!.validate()) {
                                              if (_selectedItem == null) {
                                                showToastMessage(
                                                  textColor: ColorsManager.black,
                                                  message: StringsManager.selectAnnouncementTypeWarning,
                                                  states: ToastStates.WARNING
                                                );
                                              } else {
                                                setState(() {
                                                  _isExpanded = false;
                                                  _showContent = false;
                                                  _height = AppSizesDouble.s80;
                                                });

                                                await cubit.uploadPImage(image: cubit.announcementImageFile);
                                                print('adding announcement');
                                                cubit.addAnnouncement(
                                                  title: _titleController.text,
                                                  dueDate: dueDateFormatted,
                                                  type: _selectedItem,
                                                  description: _descriptionController.text,
                                                  image: cubit.announcementImageFile ?? AppConstants.defaultImage,
                                                  currentSemester: widget.semester
                                                );
                                                setState(() {
                                                  _titleController.clear();
                                                  _descriptionController.clear();
                                                  _dateController.text = dueDateWord;
                                                  _selectedItem = null;
                                                  dueDateFormatted = null;
                                                  cubit.announcementImageFile = null;
                                                  cubit.imageName = StringsManager.selectImage;
                                                  cubit.pickerIcon = IconsManager.imageIcon;
                                                  datePickerIcon = IconsManager.datePickerIcon;
                                                });
                                              }
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizesDouble.s13)),
                                            padding: EdgeInsetsDirectional.symmetric(horizontal: AppQueries.screenWidth(context) / AppSizes.s10),
                                            backgroundColor: ColorsManager.lightPrimary,
                                            foregroundColor: ColorsManager.white,
                                            textStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize:  AppQueries.screenWidth(context) / AppSizes.s17),
                                          ),
                                          child: const Text(StringsManager.submit)
                                        ),
                                      ],
                                    ),
                                  ),
                                ]
                              ),
                            ),
                          ),
                        )
                      ) :
                      !_isExpanded ?
                      Padding(
                        padding: EdgeInsetsDirectional.symmetric(
                          vertical: AppSizesDouble.s10,
                          horizontal: AppSizesDouble.s15
                        ),
                        child: Row(
                          children: [
                            Text(
                              StringsManager.addNew,
                              style: TextStyle(
                                fontSize: FontSize.size30,
                                color: ColorsManager.white
                              ),
                            ),
                            Spacer(),
                            Icon(
                              IconsManager.addIcon,
                              color: ColorsManager.white,
                              size: AppSizesDouble.s40,
                            ),
                          ],
                        ),
                      )
                    : null,
                    ),
                  ),
                  ConditionalBuilder(
                    condition: state is! AdminGetAnnouncementLoadingState &&
                        cubit.announcements != null &&
                        cubit.announcements!.isNotEmpty,
                    builder: (context) => ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => announcementBuilder(
                          widget.semester,
                          // cubit.announcements![index].id,
                          context,
                          index,
                          cubit.announcements![index].title,
                          cubit.announcements![index].content,
                          cubit.announcements![index].dueDate,
                          cubit.announcements![index].type),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: AppSizesDouble.s10,
                      ),
                      itemCount: cubit.announcements!.length,
                    ),
                    fallback: (context) {
                      if (state is AdminGetAnnouncementLoadingState) {
                        return SizedBox(
                          height: AppQueries.screenHeight(context) /
                              AppSizesDouble.s1_5,
                          child:
                              const Center(child: CircularProgressIndicator()),
                        );
                      } else {
                        return SizedBox(
                          height: AppQueries.screenHeight(context) / AppSizesDouble.s1_5,
                          child: Center(
                            child: Text(
                              StringsManager.noAnnouncementsYet,
                              style: TextStyle(
                                fontSize: AppSizesDouble.s30,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String? _titleValidator(value) {
    if (value == null || value.isEmpty) {
      return StringsManager.emptyFieldWarning;
    }
    return null;
  }

  _datePicker() => showDatePicker(
        context: context,
        initialDate: DateTime.now().add(Duration(days: AppSizes.s1)),
        firstDate: DateTime.now().add(Duration(days: AppSizes.s1)),
        lastDate: DateTime.parse(StringsManager.endDate),
      ).then((value) {
        if (value != null) {
          setState(() {
            DateTime selectedDate = DateTime(value.year, value.month, value.day);
            dueDateFormatted = DateTime.utc(selectedDate.year, selectedDate.month, selectedDate.day).toIso8601String();
            _dateController.text = intl.DateFormat(StringsManager.dateFormat).format(value);
            datePickerIcon = IconsManager.closeIcon;
          });
        }
      });

  _getAnnouncementImage(cubit) {
    showToastMessage(
      message: StringsManager.imagePickingWarning,
      states: ToastStates.WARNING,
    );
    cubit.getAnnouncementImage();
  }

  void _addDirectionListener(TextEditingController controller) {
    controller.addListener(() {
      if (controller.text.isNotEmpty && !_textDirections.containsKey(controller)) {
        final firstChar = controller.text[0];
        final isArabic = RegExp(r'^[\u0600-\u06FF]').hasMatch(firstChar);

        setState(() {
          _textDirections[controller] = isArabic ? TextDirection.rtl : TextDirection.ltr;
        });
      }
    });
  }

  TextDirection getTextDirection(TextEditingController controller) {
    return _textDirections[controller] ?? TextDirection.ltr; // Default LTR
  }

  Widget announcementBuilder(semester, context, index, title, content, date, selectedItem) {
    var cubit = AdminCubit.get(context).announcements![index];
    print(cubit.type);
    return GestureDetector(
      onTap: () {
        navigate(
          context,
          AnnouncementDetail(
            semester: semester,
            title: cubit.title,
            description: cubit.content,
            date: cubit.dueDate,
            // id: ID,
          )
        );
      },
      child: Container(
        margin: const EdgeInsetsDirectional.symmetric(horizontal: AppMargins.m10),
        padding: const EdgeInsetsDirectional.symmetric(horizontal: AppPaddings.p10),
        height: AppSizesDouble.s80,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppSizesDouble.s20), color: ColorsManager.lightPrimary),
        child: Row(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: AppQueries.screenWidth(context) - AppSizes.s150),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(color: ColorsManager.white),
                maxLines: AppSizes.s1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Spacer(),
            //Edit button
            MaterialButton(
              onPressed: () async {
                print(cubit.id);
                String refresh = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditAnnouncement(
                      semester: semester,
                      title: cubit.title,
                      content: cubit.content,
                      date: cubit.dueDate,
                      id: cubit.id,
                      index: index,
                      imageLink: cubit.image,
                    )
                  ),
                );

                if (refresh == StringsManager.refresh) {
                  AdminCubit.get(context).getAnnouncements(semester);
                }
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizesDouble.s10)),
              color: ColorsManager.white,
              minWidth: AppSizesDouble.s10,
              padding: const EdgeInsets.all(AppPaddings.p6),
              child: const Icon(
                Icons.edit_outlined,
                color: Colors.black,
              ), // Padding for icon
            ),
            //Delete Icon
            MaterialButton(
              onPressed: () {
                AdminCubit.get(context).deleteAnnouncement(cubit.id, semester);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizesDouble.s10)
              ),
              minWidth: AppSizesDouble.s10,
              color: Colors.white,
              padding: const EdgeInsets.all(AppPaddings.p6),
              child: const Icon(
                Icons.delete_sharp,
                color: ColorsManager.imperialRed,
              ), // Padding for icon
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.removeListener(() {});
    _descriptionController.removeListener(() {});
    _titleController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
