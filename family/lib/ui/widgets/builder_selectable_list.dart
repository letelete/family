import 'package:family/core/models/selectable_list_tile.dart';
import 'package:family/ui/shared/colors.dart';
import 'package:family/ui/shared/styles.dart';
import 'package:family/ui/utils/ui_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectableBuilderListWidget<T> extends StatefulWidget {
  /// Neither of indexes are selected.
  static const int noSelection = -1;

  final List<SelectableListTile> children;

  /// Executes on one of given [children] click.
  /// Passes [SelectableListTile] value of [T] as a parameter.
  ///
  /// If tile has been unselected, function passes null.
  final Function(dynamic) onSelected;

  final int initialSelection;

  const SelectableBuilderListWidget({
    Key key,
    this.children,
    this.onSelected,
    this.initialSelection,
  })  : assert(onSelected != null),
        assert(children != null),
        super(key: key);
  @override
  _SelectableBuilderListState createState() => _SelectableBuilderListState();
}

class _SelectableBuilderListState extends State<SelectableBuilderListWidget> {
  int _currentlySelectedIndex = SelectableBuilderListWidget.noSelection;

  @override
  void initState() {
    if (widget.initialSelection != null) {
      _currentlySelectedIndex = widget.initialSelection;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void onTileSelected(SelectableListTile tile) {
      final int tileIndex = widget.children.indexOf(tile);
      final bool tileUnselected = tileIndex == _currentlySelectedIndex;
      final returnValue = tileUnselected ? null : tile.value;
      final int newSelectionIndex =
          tileUnselected ? SelectableBuilderListWidget.noSelection : tileIndex;

      setState(() {
        _currentlySelectedIndex = newSelectionIndex;
      });

      widget.onSelected(returnValue);
    }

    Widget buildListTileWidget(SelectableListTile tile, bool isSelected) {
      final Color textColor =
          isSelected ? AppColors.textPrimary : AppColors.textSecondary;
      return InkWell(
        onTap: () => onTileSelected(tile),
        child: Container(
          padding: EdgeInsets.all(4.0),
          child: Text(
            tile.label,
            textAlign: TextAlign.center,
            style: AppStyles.menuActiveContentText.copyWith(color: textColor),
          ),
        ),
      );
    }

    List<Widget> tileWidgets = widget.children
        .asMap()
        .map((index, item) {
          final SelectableListTile listTile = widget.children.elementAt(index);
          final bool isSelected = _currentlySelectedIndex == index;
          return MapEntry(index, buildListTileWidget(listTile, isSelected));
        })
        .values
        .toList();

    tileWidgets = UiUtils.getSpacedWidgets(
      children: tileWidgets,
      spacing: SizedBox(height: 16.0),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: tileWidgets,
    );
  }
}
