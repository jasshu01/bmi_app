import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

TextEditingController weightController = TextEditingController();
TextEditingController heightControllerCm = TextEditingController();
TextEditingController heightControllerFt = TextEditingController();
TextEditingController heightControllerInch = TextEditingController();
String selectedWeightUnit = "kg";
String selectedHeightUnit = "cm";
bool InvalidData = false;
String results = "";
Color bgColor = Colors.white;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            "BMI App",
          ),
        ),
        body: Container(
          color: bgColor,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyWeightDropdownWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    MyHeightDropdownWidget(),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        CalculateBMI();
                        setState(() {});
                      },
                      child: Text("Calculate"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      results,
                      style: TextStyle(
                          color: InvalidData ? Colors.red : Colors.black,
                          fontSize: 18),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

void CalculateBMI() {
  double weight = 0;
  double heightCm = 0;
  double heightFt = 0;
  double heightInch = 0;

  try {
    weight = double.parse(weightController.text.toString());
    if (selectedHeightUnit == "cm") {
      heightCm = double.parse(heightControllerCm.text.toString());
    } else {
      heightFt = double.parse(heightControllerFt.text.toString());
      heightInch = double.parse(heightControllerInch.text.toString());
    }

    double weight_in_KG = weight;
    if (selectedWeightUnit == "lbs") {
      weight_in_KG /= 2.20462;
    }

    double height_in_cm = heightCm;
    if (selectedHeightUnit != "cm") {
      height_in_cm = heightFt * 30.48 + heightInch * 2.54;
    }
    double bmi = weight_in_KG * 100 * 100 / (height_in_cm * height_in_cm);

    Color backgroundColor;
    String interpretation;
    if (bmi < 18.5) {
      backgroundColor = Colors.yellow; // Underweight
      interpretation = 'Underweight';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      backgroundColor = Colors.green; // Normal Weight
      interpretation = 'Normal Weight';
    } else if (bmi >= 25 && bmi < 29.9) {
      backgroundColor = Colors.orange; // Overweight
      interpretation = 'Overweight';
    } else if (bmi >= 30 && bmi < 34.9) {
      backgroundColor = Colors.red; // Obesity Class 1
      interpretation = 'Obesity Class 1 (Moderate)';
    } else if (bmi >= 35 && bmi < 39.9) {
      backgroundColor = Colors.red; // Obesity Class 2 (Severe)
      interpretation = 'Obesity Class 2 (Severe)';
    } else {
      backgroundColor = Colors.red; // Obesity Class 3 (Very Severe or Morbid)
      interpretation = 'Obesity Class 3 (Very Severe or Morbid)';
    }

    bgColor = backgroundColor;
    results = " BMI is ${bmi.toStringAsFixed(2)} \n You are ${interpretation}";
    InvalidData = false;
  } catch (e) {
    InvalidData = true;
    results = "Invalid Data";
    return;
  }
}

class MyWeightDropdownWidget extends StatefulWidget {
  @override
  _MyWeightDropdownWidgetState createState() => _MyWeightDropdownWidgetState();
}

class _MyWeightDropdownWidgetState extends State<MyWeightDropdownWidget> {
  String _selectedUnit = 'kg'; // Set "kg" as the default value
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Select a Unit for Weight",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(width: 20),
              Container(
                width: 50,
                child: DropdownButton<String>(
                  value: _selectedUnit,
                  items: <String>['kg', 'lbs'].map((String unit) {
                    return DropdownMenuItem<String>(
                      value: unit,
                      child: Text(unit),
                    );
                  }).toList(),
                  onChanged: (selectedUnit) {
                    setState(() {
                      _selectedUnit = selectedUnit!;
                      selectedWeightUnit = _selectedUnit;
                    });
                  },
                ),
              ),
            ],
          ),
          Text(
            'Selected Unit: ${_selectedUnit ?? "None"}',
            style: TextStyle(fontSize: 0),
          ),
          Container(
            width: 100,
            child: TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  labelText: selectedWeightUnit,
                  // hintText: "Enter your Weight (${_selectedUnit})",
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyHeightDropdownWidget extends StatefulWidget {
  @override
  _MyHeightDropdownWidgetState createState() => _MyHeightDropdownWidgetState();
}

class _MyHeightDropdownWidgetState extends State<MyHeightDropdownWidget> {
  String _selectedUnit = 'cm'; // Set "kg" as the default value
  bool heightInCm = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Select a Unit for height",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(width: 20),
              Container(
                width: 120,
                child: DropdownButton<String>(
                  value: _selectedUnit,
                  items: <String>['cm', 'ft & inches'].map((String unit) {
                    return DropdownMenuItem<String>(
                      value: unit,
                      child: Text(unit),
                    );
                  }).toList(),
                  onChanged: (selectedUnit) {
                    setState(() {
                      _selectedUnit = selectedUnit!;
                      if (_selectedUnit == "cm") {
                        heightInCm = true;
                      } else {
                        heightInCm = false;
                      }
                      selectedHeightUnit = _selectedUnit;
                      setState(() {});
                    });
                  },
                ),
              ),
            ],
          ),
          Text(
            'Selected Unit: ${_selectedUnit ?? "None"}',
            style: TextStyle(fontSize: 0),
          ),
          Container(
            width: 300,
            child: Column(
              children: [
                Visibility(
                  visible: heightInCm,
                  child: Container(
                    width: 100,
                    child: TextField(
                      controller: heightControllerCm,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        labelText: "cm",
                        // hintText: "Enter your Height (cm)",
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !heightInCm,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        child: TextField(
                          controller: heightControllerFt,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: "feet",
                            // hintText: "Enter your Height (ft)",
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 100,
                        child: TextField(
                          controller: heightControllerInch,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: "Inches",
                            // hintText: "Enter your Height (inches)",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
