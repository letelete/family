import 'package:family/core/enums/build_responses.dart';
import 'package:family/core/models/build_data.dart';
import 'package:family/core/models/build_progress.dart';
import 'package:family/ui/shared/colors.dart';
import 'package:family/ui/shared/gradients.dart';
import 'package:family/ui/shared/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A duration of the transition animation between two views.
const Duration _pageAnimationDuration = Duration(milliseconds: 580);

/// Describes a configuration-splitted-into-sequence view.
///
/// [BaseBuilderView] is a reusable widget over the app which should be used to
/// create configurational views which main's target is to build particular data model
/// by fulfilling its fields in stages.
///
/// Stages are specified as [children] and are simply consecutive stages of the creational process.
/// Each [children] should define particular configurational behavior.
///
/// For example, with given [Dog] data model:
/// ```dart
/// class Dog {
///   String name;
///   int age;
/// }
/// ```
/// [T] is a generic class for holding a data class of created model inside the builder view.
///
/// [children] should consist of 2 views.
/// The first one should be a TextField to fill the [name] field.
/// The second one could be a TextField as well, which would fill the [age] field.
/// The second view is the last given view, which means the [finalStepButtonLabel] would be used for
/// a next step button, and its onTap action would trigger [onFinishBuild] function, which returns [BuildData] model
/// which is simply a data created during the builder view runtime.
///
/// [BaseBuilderView] consist of 3 main elements.
/// 1. Header - A view title (one of the [titles] strings),
/// 2. Body - A configurational view itself (one of the [children] widgets),
/// 3. Footer, which consists of 2 buttons:
/// a) A cancel button:
///    Closes builder view,
/// b) The next step button:
///    Controls a flow of the configuration.
///    Depending of [viewValidated] can be either enabled or disabled.
class BaseBuilderView<T> extends StatefulWidget {
  /// The list of views specifying particular configurational behavior.
  final List<Widget> children;

  /// The list of titles for [children] at given index.
  final List<String> titles;

  /// The label visible on the action button for all sub [children].
  final String nextStepButtonLabel;

  /// The label visible on the action button if the last [children] is displayed.
  final String finalStepButtonLabel;

  /// The flag which controls enability of the action button.
  /// If true: next actions are available,
  /// else: next actions are disabled.
  final bool viewValidated;

  /// Triggers when view has changed.
  final Function onViewChange;

  /// Triggers when builder is on the last screen and next step button has been clicked.
  final BuildData Function() onFinishBuild;

  const BaseBuilderView({
    Key key,
    this.children,
    this.titles,
    this.nextStepButtonLabel,
    this.finalStepButtonLabel,
    this.viewValidated,
    this.onViewChange,
    this.onFinishBuild,
  })  : assert(children != null && children.length > 0,
            'Length of pages must be a positive number'),
        assert(titles != null),
        assert(titles.length == children.length,
            'Each given page must have its own title'),
        assert(finalStepButtonLabel != null),
        assert(nextStepButtonLabel != null),
        assert(viewValidated != null),
        assert(onFinishBuild != null),
        super(key: key);

  @override
  _BaseBuilderViewState createState() {
    return _BaseBuilderViewState<T>(
      buildProgress: BuildProgress(
        currentIndex: 0,
        lastIndex: children.length - 1,
      ),
    );
  }
}

class _BaseBuilderViewState<T> extends State<BaseBuilderView> {
  final controller = PageController(initialPage: 0);
  final BuildProgress buildProgress;

  _BaseBuilderViewState({this.buildProgress}) : assert(buildProgress != null);

  @override
  Widget build(BuildContext context) {
    const double buttonHeight = 48.0;
    const String cancelButtonLabel = 'Cancel';
    final bool isProgressVisible = !buildProgress.hasReachedEnd();
    final String pageTitle =
        this.widget.titles.elementAt(buildProgress.currentIndex);
    final String progressTitle =
        '(${buildProgress.lastIndex - buildProgress.currentIndex})';
    final String nextStepButtonLabel = buildProgress.hasReachedEnd()
        ? this.widget.finalStepButtonLabel
        : this.widget.nextStepButtonLabel;
    final bool isNextStepButtonEnabled = this.widget.viewValidated;

    Widget appBar = AppBar(
      toolbarOpacity: 0.0,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Text(
        pageTitle,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: TextSizes.menuCardTitle,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    Widget exitAndDiscardChangesDialog = AlertDialog(
      title: Text('Exit and discard all changes?'),
      actions: <Widget>[
        FlatButton(
          child: Text('No'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
          child: Text('Yes'),
          onPressed: () {
            Navigator.of(context).pop();
            _closeBuilder();
          },
        ),
      ],
    );

    Widget cancelButton = Expanded(
      child: InkWell(
        onTap: () => _showDialog(exitAndDiscardChangesDialog),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            cancelButtonLabel.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: TextSizes.menuButton,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );

    Widget progress = Container(
      margin: EdgeInsets.only(left: 4.0),
      child: Text(
        progressTitle,
        style: TextStyle(
          fontSize: TextSizes.menuButton,
          color: AppColors.textSecondary,
        ),
      ),
    );

    Widget nextStepButton = Expanded(
      child: Opacity(
        opacity: isNextStepButtonEnabled ? 1.0 : 0.3,
        child: InkWell(
          onTap: isNextStepButtonEnabled ? _nextStep : null,
          child: Container(
            alignment: Alignment.center,
            height: buttonHeight,
            decoration: BoxDecoration(
              color: AppColors.primaryAccent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(buttonHeight),
                bottomLeft: Radius.circular(buttonHeight),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  nextStepButtonLabel.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: TextSizes.menuButton,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                isProgressVisible ? progress : Container(),
              ],
            ),
          ),
        ),
      ),
    );

    Widget bodyMain = PageView(
      controller: controller,
      physics: NeverScrollableScrollPhysics(),
      children: widget.children,
    );

    Widget bodyFooter = Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            cancelButton,
            SizedBox(width: 32.0),
            nextStepButton,
          ],
        ),
      ),
    );

    Widget bodyContent = Stack(
      alignment: Alignment.center,
      children: <Widget>[
        bodyMain,
        bodyFooter,
      ],
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Container(
        decoration: BoxDecoration(gradient: AppGradients.backgroundSolid),
        child: bodyContent,
      ),
    );
  }

  void _showDialog(AlertDialog dialog) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  void _closeBuilder() {
    FocusScope.of(context).requestFocus(FocusNode());

    final BuildData data = BuildData<T>(response: BuildResponses.cancel);
    Navigator.of(context).pop(data);
  }

  void _nextStep() {
    FocusScope.of(context).requestFocus(FocusNode());

    if (buildProgress.hasReachedEnd()) {
      _finishBuild();
    } else {
      _openNextPage();
    }
  }

  void _finishBuild() {
    final BuildData<T> builtData = this.widget.onFinishBuild();
    Navigator.of(context).pop(builtData);
  }

  void _openNextPage() {
    this.widget.onViewChange();
    setState(() => ++buildProgress.currentIndex);
    controller.nextPage(
      duration: _pageAnimationDuration,
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }
}
