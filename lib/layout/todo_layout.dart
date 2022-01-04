import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/adaptive/adaptivw_indicator.dart';
import 'package:todo_app/shared/components/componets.dart';
import 'package:todo_app/shared/components/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  var titleController = TextEditingController();
  var percentageController = TextEditingController();
  var dateController = TextEditingController();

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()
        ..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDatabaseState) Navigator.pop(context);
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(cubit.title[cubit.currentIndex], style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),),
              actions: [
                IconButton(
                  icon: Icon(Icons.brightness_4_outlined),
                  onPressed: () {
                    EasyDynamicTheme.of(context).changeTheme();

                  },
                ),
              ],
            ),
            key: scaffoldKey,
            body: (state is! AppGetDatabaseLoadingState)
                ? cubit.screen[cubit.currentIndex]
                : Center(
                child: AdaptiveIndicator(
                  os: getOS(),
                )),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (value) {
                cubit.changeIndex(value);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.format_quote), label: 'Values'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite), label: 'Favourites'),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(cubit.iconChange),
              onPressed: () {
                if (cubit.isBottomShow!) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: percentageController.text,
                        date: dateController.text);
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultFormField(
                                    controller: titleController,
                                    keyboardType: TextInputType.text,
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'value text must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Value Text',
                                    prefix: Icons.title,
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultFormField(
                                    controller: percentageController,
                                    keyboardType: TextInputType.number,
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'importance percentage must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Importance Percentage',
                                    prefix: Icons.star,
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),

                                  defaultFormField(
                                    controller: dateController,
                                    keyboardType: TextInputType.datetime,
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'date must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Added Date',
                                    prefix: Icons.calendar_today_outlined,
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2025-10-10'),
                                      ).then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                        elevation: 20.0,
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                    titleController.clear();
                    percentageController.clear();

                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
