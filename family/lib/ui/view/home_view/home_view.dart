import 'package:family/base/base_view.dart';
import 'package:family/core/models/family.dart';
import 'package:family/core/models/user.dart';
import 'package:family/core/viewmodels/home_model.dart';
import 'package:family/ui/view/home_view/home_view_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
      onModelReady: (model) => model.fetchTodayDate(),
      builder: (context, model, child) {
        return StreamProvider<List<Family>>.value(
          initialData: <Family>[],
          value: model.streamFamilies(Provider.of<User>(context).id),
          child: Consumer<List<Family>>(
            builder: (_, List<Family> families, __) {
              return HomeViewBody(model, families);
            },
          ),
        );
      },
    );
  }
}
