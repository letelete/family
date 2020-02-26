import 'package:family/base/base_view.dart';
import 'package:family/core/models/family.dart';
import 'package:family/core/models/user.dart';
import 'package:family/core/viewmodels/family_model.dart';
import 'package:family/ui/view/family_view/family_view_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FamilyView extends StatelessWidget {
  final Family family;

  const FamilyView(this.family, {Key key})
      : assert(family != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return BaseView<FamilyModel>(
      builder: (context, model, _) => StreamProvider.value(
        value: model.streamFamily(user.id, family.id),
        initialData: family,
        child: Consumer<Family>(
          builder: (_, family, __) {
            return FamilyViewBody(model, family);
          },
        ),
      ),
    );
  }
}
