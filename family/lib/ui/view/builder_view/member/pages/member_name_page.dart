import 'package:family/base/builder/base_page_view.dart';
import 'package:family/core/viewmodels/family_builder_model.dart';
import 'package:family/core/viewmodels/member_builder_model.dart';
import 'package:family/ui/widgets/builder_text_field_widget.dart';
import 'package:flutter/material.dart';

class MemberNamePage extends StatefulWidget {
  static const String title = 'What\'s your member name?';

  final MemberBuilderModel model;

  const MemberNamePage(this.model, {Key key}) : super(key: key);

  @override
  _MemberNamePageState createState() => _MemberNamePageState();
}

class _MemberNamePageState extends State<MemberNamePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    final String passedName = widget.model.member?.name;
    _controller.text = passedName;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseBuilderPageView<FamilyBuilderModel>(
      builder: (context) => BuilderTextFieldWidget(
        controller: _controller,
        onChanged: (String newName) {
          bool isNewNameValid = widget.model.validateName(newName);
          if (isNewNameValid) widget.model.saveName(newName);
        },
        hintText: 'John Doe',
      ),
    );
  }
}
