import 'package:family/base/builder/base_page_view.dart';
import 'package:family/core/viewmodels/family_builder_model.dart';
import 'package:family/ui/widgets/builder_text_field_widget.dart';
import 'package:flutter/material.dart';

class FamilyNamePage extends StatefulWidget {
  static const String title = 'Give your family a name';

  final FamilyBuilderModel model;

  const FamilyNamePage({
    Key key,
    this.model,
  })  : assert(model != null),
        super(key: key);

  @override
  _FamilyNamePageState createState() => _FamilyNamePageState();
}

class _FamilyNamePageState extends State<FamilyNamePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    final String passedName = widget.model?.family?.name;
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
        onChanged: widget.model.validateNameAndSave,
        hintText: 'Spotify',
      ),
    );
  }
}
