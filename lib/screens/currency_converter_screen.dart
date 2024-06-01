import 'package:flutter/material.dart';
import '/view-models/currency_converter_viewmodel.dart';

class CurrencyConverterScreen extends StatefulWidget {
  final CurrencyConverterViewModel viewModel;

  CurrencyConverterScreen({required this.viewModel});

  @override
  _CurrencyConverterScreenState createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  late TextEditingController _toAmountController;

  @override
  void initState() {
    super.initState();
    // Initialize TextEditingController with initial value from viewModel
    _toAmountController =
        TextEditingController(text: widget.viewModel.toAmount);
    // Listen for changes in the toAmount and update the TextEditingController accordingly
    widget.viewModel.addListener(_onToAmountChanged);
  }

  @override
  void dispose() {
    // Dispose TextEditingController and remove listener to prevent memory leaks
    _toAmountController.dispose();
    widget.viewModel.removeListener(_onToAmountChanged);
    super.dispose();
  }

  void _onToAmountChanged() {
    // Update TextEditingController when toAmount changes
    setState(() {
      _toAmountController.text = widget.viewModel.toAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_image.jpg'), // Set your background image here
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                onChanged: (value) =>
                    widget.viewModel.fromAmountChanged(value),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount to Convert',
                  hintText: 'Enter amount to convert',
                  filled: true,
                  fillColor: Colors.green[200], // Green color for input field
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                onChanged: (value) =>
                    widget.viewModel.fromCurrencyChanged(value),
                decoration: InputDecoration(
                  labelText: 'Initial Currency',
                  hintText: 'Enter currency code (e.g., USD)',
                  filled: true,
                  fillColor: Colors.green[200], // Green color for input field
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                onChanged: (value) =>
                    widget.viewModel.toCurrencyChanged(value),
                decoration: InputDecoration(
                  labelText: 'Target Currency',
                  hintText: 'Enter currency code (e.g., EUR)',
                  filled: true,
                  fillColor: Colors.blue[200], // Blue color for input field
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _toAmountController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Converted Amount',
                  hintText: 'Converted amount will be displayed here',
                  filled: true,
                  fillColor: Colors.blue[200], // Blue color for input field
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () => widget.viewModel.convert(),
                child: Text('Convert'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Blue color for button
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context); // Navigate back to the HomeScreen
        },
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}
