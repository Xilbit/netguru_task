import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:todo_app/layout/todo_layout.dart';
import 'package:todo_app/shared/bloc_observer.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';
import 'package:todo_app/shared/network/local/cache_helper.dart';
import 'package:todo_app/shared/styles/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  bool? isDark = CacheHelper.getData(key: 'isDark');
  runApp(EasyDynamicThemeWidget(
    child: MyApp(
      isDark: isDark,
    ),
  ));
}

class MyApp extends StatelessWidget {
  final bool? isDark;

  MyApp({
    this.isDark,
  });
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => AppCubit()
              ..changeAppMode(
                fromShared: isDark,
              ),
          ),
        ],
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return  MaterialApp(
                      debugShowCheckedModeBanner: false,
                      theme: lightTheme,
                      darkTheme: darkTheme,
                      themeMode: EasyDynamicTheme.of(context).themeMode,
                      home: SplashScreen(
                          seconds: 2,
                          navigateAfterSeconds: HomeLayout(),
                          title: new Text(
                            'Netguru Values',
                            style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.white),
                          ),
                          image: new Image.asset('assets/logo.png'),
                          photoSize: 100.0,
                          backgroundColor: Colors.grey,
                          styleTextUnderTheLoader: new TextStyle(),
                          loaderColor: Colors.white
                      )
                    );
          },
        ));
  }
}
