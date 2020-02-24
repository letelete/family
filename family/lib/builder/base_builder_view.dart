import 'package:family/core/enums/build_responses.dart';
import 'package:family/core/models/builder/build_progress.dart';
import 'package:family/core/models/builder/build_response.dart';
import 'package:family/core/models/builder/builder_page.dart';
import 'package:family/ui/shared/colors.dart';
import 'package:family/ui/shared/gradients.dart';
import 'package:family/ui/shared/sizes.dart';
import 'package:family/ui/widgets/simple_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A duration of the transition animation between two views.
const Duration _pageAnimationDuration = Duration(milliseconds: 580);

/// Describes a configuration-splitted-into-sequence view.
///
/// [BaseBuilderView] is a reusable widget over the app which should be used to
/// create configurational views which main target is to build a particular data model
/// by fulfilling its fields within separated stages.
///
/// [T] is a generic class for holding a data class of created model inside the builder view.
///
/// Stages are specified as [children] and are simply consecutive stages of the creational process.
/// Each [children] should define particular configurational behavior.
///
/// Example: {
/// with given Dog data model,
/// ```dart
/// class Dog {
///   String name;
///   int age;
/// }
/// ```
/// [children] should consist of 2 views.
/// The first one should be a TextField to fill the [name] data
/// and the second, a TextField to fill the [age] data.
/// The second view is the last, so the [finalStepButtonLabel] will be used
/// instead of a [nextStepButtonLabel], and its onTap action triggers [onFinishBuild] function, which returns [BuilderResponse] model
/// which is simply a data created during the builder view process.
/// }
class BaseBuilderView<T> extends StatefulWidget {
  /// The list of views specifying particular configurational behavior.
  final List<BuilderPageData> children;

  /// The label visible on the action button for all sub [children].
  final String nextStepButtonLabel;

  /// The label visible on the action button if the last [children] is displayed.
  final String finalStepButtonLabel;

  /// Triggers when view has changed.
  final Function onViewChange;

  /// Triggers when builder is on the last screen and next step button has been clicked.
  final BuilderResponse Function() onFinishBuild;

  const BaseBuilderView({
    Key key,
    this.children,
    this.nextStepButtonLabel,
    this.finalStepButtonLabel,
    this.onViewChange,
    this.onFinishBuild,
  })  : assert(children != null, 'Length of pages must be a positive number'),
        assert(finalStepButtonLabel != null),
        assert(nextStepButtonLabel != null),
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

  BuilderPageData _currentPageData() {
    int currentIndex = buildProgress.currentIndex;
    return widget.children.elementAt(currentIndex);
  }

  _BaseBuilderViewState({this.buildProgress}) : assert(buildProgress != null);

  @override
  Widget build(BuildContext context) {
    const double buttonHeight = 48.0;
    const String cancelButtonLabel = 'Cancel';
    final BuilderPageData currentPage = _currentPageData();
    final bool isViewValidated = currentPage.validated;
    final bool isProgressVisible = !buildProgress.hasReachedEnd();
    final String pageTitle = currentPage.title;
    final String progressTitle =
        '(${buildProgress.lastIndex - buildProgress.currentIndex})';
    final String nextStepButtonLabel = buildProgress.hasReachedEnd()
        ? widget.finalStepButtonLabel
        : widget.nextStepButtonLabel;
    final bool isNextStepButtonEnabled = isViewValidated;

    final appBar = AppBar(
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

    final discardAndLeaveDialog = SimpleAlertDialog(
      title: 'Discard all changes and leave?',
      description: 'This will cancel your current build process',
      confirmingAction: DialogAction(
        label: 'Discard and leave',
        onTap: _closeBuilder,
      ),
    );

    final cancelButton = Expanded(
      child: InkWell(
        onTap: () => showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => discardAndLeaveDialog,
        ),
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

    final progress = Container(
      margin: EdgeInsets.only(left: 4.0),
      child: Text(
        progressTitle,
        style: TextStyle(
          fontSize: TextSizes.menuButton,
          color: AppColors.textSecondary,
        ),
      ),
    );

    final nextStepButton = Expanded(
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

    final bodyMain = PageView(
      controller: controller,
      physics: NeverScrollableScrollPhysics(),
      children: widget.children.map((data) => data.view).toList(),
    );

    final bodyFooter = Positioned(
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

    final bodyContent = Stack(
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

  void _closeBuilder() {
    FocusScope.of(context).requestFocus(FocusNode());
    final response = BuilderResponse<T>(response: BuildResponse.cancel);
    Navigator.of(context).pop<BuilderResponse<T>>(response);
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
    final BuilderResponse<T> response = widget.onFinishBuild();
    Navigator.of(context).pop(response);
  }

  void _openNextPage() {
    if (widget.onViewChange != null) widget.onViewChange();
    setState(() => ++buildProgress.currentIndex);
    controller.nextPage(
      duration: _pageAnimationDuration,
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }
}
