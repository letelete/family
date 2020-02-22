import 'package:family/builder/base_page_view.dart';
import 'package:family/builder/builder_page_contract.dart';
import 'package:family/core/viewmodels/family_builder_model.dart';
import 'package:family/core/viewmodels/member_builder_model.dart';
import 'package:family/ui/widgets/builder_text_field_widget.dart';
import 'package:flutter/material.dart';

class MemberNamePage extends StatefulWidget
    implements BuilderPageContract<MemberBuilderModel> {
  final MemberBuilderModel model;

  const MemberNamePage(this.model, {Key key}) : super(key: key);

  @override
  String get title => 'What\'s your member name?';

  @override
  _MemberNamePageState createState() => _MemberNamePageState();
}

class _MemberNamePageState extends State<MemberNamePage> {
  final _controller = TextEditingController();
  @override
  void initState() {
    final passedName = widget.model.member?.name;
    _controller.text = passedName;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseBuilderPageView<FamilyBuilderModel>(
      builder: (context) => BuilderTextFieldWidget(
        controller: _controller,
        onChanged: widget.model.onNameChange,
        hintText: 'John Doe',
      ),
    );
  }
}
