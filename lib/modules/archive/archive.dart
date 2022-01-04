import 'package:flutter/material.dart';
import 'package:netguru_values/shared/components/componets.dart';
import 'package:netguru_values/shared/cubit/cubit.dart';
import 'package:netguru_values/shared/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Archive extends StatelessWidget {

  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {

        var tasks=AppCubit.get(context).archivedTasks;
        return taskBuilder(tasks: tasks);
      },
    );
  }
}