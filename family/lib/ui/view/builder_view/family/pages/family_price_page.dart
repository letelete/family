import 'package:family/base/builder/base_page_view.dart';
import 'package:family/core/models/price.dart';
import 'package:family/core/viewmodels/family_builder_model.dart';
import 'package:family/ui/formatters/max_length_formatter.dart';
import 'package:family/ui/formatters/upper_case_text_formatter.dart';
import 'package:family/ui/shared/colors.dart';
import 'package:family/ui/shared/styles.dart';
import 'package:family/ui/widgets/builder_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FamilyPricePage extends StatefulWidget {
  static const String title = 'How much do you pay?';

  final FamilyBuilderModel model;

  const FamilyPricePage({
    Key key,
    this.model,
  })  : assert(model != null),
        super(key: key);

  @override
  _FamilyPricePageState createState() => _FamilyPricePageState();
}

class _FamilyPricePageState extends State<FamilyPricePage> {
  final _priceController = TextEditingController();
  final _currencyController = TextEditingController();

  final _currencyFocusNode = FocusNode();

  @override
  void initState() {
    final Price passedPrice = this.widget.model.family?.price;

    if (passedPrice != null) {
      _priceController.text = passedPrice.toString();
      _currencyController.text = passedPrice.currency;
    }

    _priceController.addListener(_onAnyOfInputsChange);
    _currencyController.addListener(_onAnyOfInputsChange);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _priceController.dispose();
    _currencyController.dispose();
  }

  void _onAnyOfInputsChange() {
    var price = _priceController.text;
    var currency = _currencyController.text;
    this.widget.model.validatePriceAndSave(price, currency);
  }

  @override
  Widget build(BuildContext context) {
    const int integersRange = 4;
    const int decimalsRange = 2;
    const int maxCurrencyRange = 3;

    Widget priceInput = Expanded(
      child: TextField(
        inputFormatters: [
          PriceInputFormatter(
            maxIntegersLength: integersRange,
            maxDecimalsLength: decimalsRange,
          ),
        ],
        autofocus: true,
        controller: this._priceController,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.end,
        style: AppStyles.menuActiveContentText,
        cursorColor: AppColors.primaryAccent,
        onEditingComplete: () {
          FocusScope.of(context).requestFocus(_currencyFocusNode);
        },
        decoration: InputDecoration(
          hintText: '0,00',
          border: InputBorder.none,
          hintStyle: AppStyles.menuDisabledContentText,
        ),
      ),
    );

    Widget currencyInput = Expanded(
      child: BuilderTextFieldWidget(
        hintText: 'USD',
        focusNode: _currencyFocusNode,
        inputFormatters: [
          LengthLimitingTextInputFormatter(maxCurrencyRange),
          UpperCaseTextFormatter(),
        ],
        controller: _currencyController,
        textAlign: TextAlign.left,
      ),
    );

    return BaseBuilderPageView<FamilyBuilderModel>(
      builder: (context) {
        return Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              priceInput,
              SizedBox(width: 12.0),
              currencyInput,
            ],
          ),
        );
      },
    );
  }
}
