import 'package:family/builder/base_page_view.dart';
import 'package:family/builder/builder_page_contract.dart';
import 'package:family/core/viewmodels/family_builder_model.dart';
import 'package:family/ui/widgets/builder_text_field_widget.dart';
import 'package:flutter/material.dart';

class FamilyNamePage extends StatefulWidget
    implements BuilderPageContract<FamilyBuilderModel> {
  final FamilyBuilderModel model;

  const FamilyNamePage(this.model, {Key key}) : super(key: key);

  @override
  String get title => 'Give your family a name';
  
  @override
  _FamilyNamePageState createState() => _FamilyNamePageState();

}

class _FamilyNamePageState extends State<FamilyNamePage> {
  final _controller = TextEditingController();
  @override
  void initState() {
    _controller.text = widget.model.family?.name;
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
        hintText: 'Spotify',
      ),
    );
  }
}
