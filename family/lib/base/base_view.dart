import 'package:family/base/base_model.dart';
import 'package:family/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class BaseView<T extends BaseModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget child) builder;
  final Function(T) onModelReady;

  const BaseView({this.builder, this.onModelReady});

  @override
  State<StatefulWidget> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseModel> extends State<BaseView<T>> {
  T model = locator<T>();

  @override
  void initState() {
    if (widget.onModelReady != null) {
      widget.onModelReady(model);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<T>(
        create: (BuildContext context) => model,
        child: Consumer<T>(builder: widget.builder),
      );
}
