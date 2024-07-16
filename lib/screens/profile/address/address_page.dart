import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../../models/Address.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AddressPage(),
  ));
}

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  String? _selectedCity;
  String? _selectedState;

  final List<String> _cities = ['City1', 'City2', 'City3'];
  final List<String> _states = ['State1', 'State2', 'State3'];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Address addressModel = Address(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        address: _addressController.text,
        phoneNumber: _phoneNumberController.text,
        city: _selectedCity ?? '',
        state: _selectedState ?? '',
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SummaryPage(addressModel: addressModel),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADDRESS', style: TextStyle(color: Color(0xFFDC143C))),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFFDC143C),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField('First Name', controller: _firstNameController),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildTextField('Last Name', controller: _lastNameController),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildTextField('Address', controller: _addressController),
                      const SizedBox(height: 10),
                      _buildTextField('Phone Number', controller: _phoneNumberController, keyboardType: TextInputType.phone),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown('City', _cities, (value) {
                              setState(() {
                                _selectedCity = value;
                              });
                            }, _selectedCity),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildDropdown('State', _states, (value) {
                              setState(() {
                                _selectedState = value;
                              });
                            }, _selectedState),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFFDC143C),
                  ),
                  child: const Text('SUBMIT'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, {TextEditingController? controller, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Color(0xFFDC143C)),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFDC143C)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFDC143C)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }

  Widget _buildDropdown(String labelText, List<String> items, ValueChanged<String?> onChanged, String? value) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Color(0xFFDC143C)),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFDC143C)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFDC143C)),
        ),
      ),
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select $labelText';
        }
        return null;
      },
    );
  }
}

class SummaryPage extends StatelessWidget {
  final Address addressModel;

  const SummaryPage({Key? key, required this.addressModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary', style: TextStyle(color: Color(0xFFDC143C))),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFFDC143C),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryText('First Name', addressModel.firstName),
            const SizedBox(height: 10),
            _buildSummaryText('Last Name', addressModel.lastName),
            const SizedBox(height: 10),
            _buildSummaryText('Address', addressModel.address),
            const SizedBox(height: 10),
            _buildSummaryText('Phone Number', addressModel.phoneNumber),
            const SizedBox(height: 10),
            _buildSummaryText('City', addressModel.city),
            const SizedBox(height: 10),
            _buildSummaryText('State', addressModel.state),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryText(String label, String value) {
    return Row(
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFDC143C))),
        Text(value, style: const TextStyle(color: Color(0xFFDC143C))),
      ],
    );
  }
}
