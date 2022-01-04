
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:netguru_values/shared/cubit/cubit.dart';
import 'package:netguru_values/shared/styles/colors.dart';
import 'package:netguru_values/shared/styles/icon_broken.dart';
import 'package:slimy_card/slimy_card.dart';



Widget defaultButton(
        {Color background = defaultColor,
        double width = double.infinity,
        double radius = 0.0,
        required Function function,
        required String text,
        bool isUpperCase = true}) =>
    Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
          color: background, borderRadius: BorderRadius.circular(radius)),
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType keyboardType,
  ValueChanged<String>? onSubmit,
  ValueChanged<String>? onChange,
  VoidCallback? onTap,
  bool isPassword = false,
  FormFieldValidator<String>? validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  VoidCallback? suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      cursorColor: defaultColor,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(
                  suffix,
                ),
              )
            : null,
        border: OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text('${model['time']}'),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            IconButton(
                icon: Icon(
                  Icons.check_box,
                  color: Colors.green,
                ),
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'done', id: model['id']);
                }),
            IconButton(
                icon: Icon(Icons.archive),
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'archive', id: model['id']);
                })
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: model['id']);
      },
    );

Widget taskBuilder({
  required List<Map> tasks,
}) {

  if (tasks.length > 0) {
   return CarouselSlider(
       options: CarouselOptions(
         height: 400,
         aspectRatio: 16/9,
         viewportFraction: 0.8,
         initialPage: 0,
         enableInfiniteScroll: true,
         reverse: false,
         autoPlay: true,
         autoPlayInterval: Duration(seconds: 5),
         autoPlayAnimationDuration: Duration(milliseconds: 800),
         autoPlayCurve: Curves.fastOutSlowIn,
         enlargeCenterPage: true,
         scrollDirection: Axis.horizontal,
       ),
      items: tasks.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return ListView(
              children: <Widget>[
             SlimyCard(
                  color: Theme.of(context).primaryColor,
                  width: MediaQuery.of(context).size.width,
                  topCardHeight: 400,
                  bottomCardHeight: 200,
                  borderRadius: 15,
                  topCardWidget: CircularPercentIndicator(
                    radius: 120.0,
                    lineWidth: 13.0,
                    animation: true,
                    percent: (double.parse(i["time"]) / 100.00),
                    header:  IconButton(
                        icon:i['status'] == "done" ? Icon(Icons.favorite) : Icon(Icons.favorite_outline_outlined),
                        onPressed: () {
                          i['status'] == "done" ?
                          AppCubit.get(context)
                              .updateData(status: 'new', id: i['id']) : AppCubit.get(context)
                              .updateData(status: 'done', id: i['id']);
                        },
                      color: Theme.of(context).textTheme.bodyText1!.color,

                        ),
                    center: new Text(
                      "${i["time"]}%",
                      style:
                      new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Theme.of(context).textTheme.bodyText1!.color),
                    ),
                    footer: new Text(
                      '"${i["title"]}"',
                      style:
                      new TextStyle(fontSize: 21.0, fontWeight: FontWeight.w300, // light
                        fontStyle: FontStyle.italic, color: Theme.of(context).textTheme.bodyText1!.color),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: Theme.of(context).textTheme.bodyText1!.color,
                  ),

                  slimeEnabled: true,
                ),

              ],
            );

          },
        );
      }).toList()..shuffle(),
    );

    // return ListView.separated(
    //   physics: BouncingScrollPhysics(),
    //   itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
    //   separatorBuilder: (context, index) => myDivider(),
    //   itemCount: tasks.length,
    // );
  } else {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.format_quote_outlined,
            size: 100,
            color: Colors.grey,
          ),
          Text(
            'No Values Yet, Please Add Some values',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}

PreferredSizeWidget defaultAppBar({
  required BuildContext context,
  String? title,
  List<Widget>? actions,
}) =>
    AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          IconBroken.Arrow___Left_2,
        ),
      ),
      titleSpacing: 5.0,
      title: Text(
        title!,
      ),
      actions: actions,
    );

Widget myDivider() => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20.0,
      ),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    );

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndFinish(
  context,
  widget,
) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) {
        return false;
      },
    );

Widget defaultTextButton({
  required Function function,
  required String text,
}) =>
    TextButton(
      onPressed: () {
        function();
      },
      child: Text(
        text.toUpperCase(),
      ),
    );

void showToast({
  required String text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

// enum
enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }

  return color;
}
