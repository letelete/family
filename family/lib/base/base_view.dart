import 'package:family/base/base_model.dart';
import 'package:family/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class BaseView<T extends BaseModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget child) builder;
  final Function(T) onModelReady;
  final Function(T) onModelDispose;

  /// Additional providers other than the base one ([T])
  final List<SingleChildWidget> providers;

  const BaseView({
    this.builder,
    this.onModelReady,
    this.onModelDispose,
    this.providers = const [],
  });

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
  void dispose() {
    if (widget.onModelDispose != null) {
      widget.onModelDispose(model);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modelProvider = ChangeNotifierProvider<T>(create: (_) => model);
    List<SingleChildWidget> providers = [modelProvider];
    providers.addAll(widget.providers);
    return MultiProvider(
      providers: providers,
      child: Consumer<T>(builder: widget.builder),
    );
  }
}
