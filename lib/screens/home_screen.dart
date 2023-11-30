import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rev_x/models/weather.dart';
import 'package:rev_x/screens/weather_details_screen.dart';
import 'package:rev_x/view_models/weather_vm.dart';
import 'package:rev_x/widgets/rounded_corner_container.dart';
import '../constants/font_constants.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final WeatherVM _weatherVM = WeatherVM();

  List<Weather?> _weathers = [];
  String _selectedCity = 'College Station';
  String? _fileName;

  Future<void> _getWeatherData(String city) async {
    String? locationKey = await _weatherVM.getLocationKey(city);
    if (locationKey != null) {
      List<Weather?> weathers = await _weatherVM.getForecasts(locationKey);
      setState(() {
        _weathers = weathers;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getWeatherData('College Station');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Rev X', style: kThirtySixBoldTextStyle),
                const SizedBox(height: 37,),
                Text('Add your data', style: kSixteenBoldTextStyle),
                const SizedBox(height: 20,),
                GestureDetector(
                  onTap: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles();
                    if (result != null) {
                      PlatformFile file = result.files.first;
                      setState(() {
                        _fileName = file.name;
                      });
                    }
                  },
                  child: RoundedCornerContainer(
                    color: const Color(0xffD9D9D9),
                    height: 196,
                    child: _fileName != null ? Center(child: Text(_fileName ?? '', style: kTwentyBoldTextStyle,)) : Image.asset('assets/images/plus.png'),
                  ),
                ),
                const SizedBox(height: 24,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Weather data', style: kSixteenBoldTextStyle),
                    SizedBox(
                      height: 50,
                      width: 160,
                      child: DropdownButton(value: _selectedCity, items: const [
                        DropdownMenuItem<String>(value: 'College Station', child: Text('College Station',)),
                        DropdownMenuItem<String>(value: 'Houston', child: Text('Houston')),
                        DropdownMenuItem<String>(value: 'Austin', child: Text('Austin')),
                      ], hint: const Text('Select Location'), onChanged: (value) {
                        _selectedCity = value ?? '';
                        _getWeatherData(value ?? '');
                      },),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                _weathers.isEmpty ? const SizedBox() : GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WeatherDetailsScreen(weathers: _weathers, selectedCity: _selectedCity,)),
                    );
                  },
                  child: RoundedCornerContainer(
                    color: const Color(0xffD9D9D9),
                    height: 196,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: RoundedCornerContainer(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_weathers.first?.iconPhrase ?? '', style: kSixteenBoldTextStyle,),
                              const SizedBox(height: 6,),
                              Text("The percentage of raining: ${_weathers.first?.rainProbability}%", style: kFourteenRegTextStyle.copyWith(color: Colors.grey),),
                              const SizedBox(height: 15,),
                              WeatherElement(weather: _weathers.first, showRain: false,),
                              const SizedBox(height: 15,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(),
                                  RoundedCornerContainer(
                                    width: 102,
                                    height: 30,
                                    color: Colors.black,
                                    child: Center(child: Text('View Details', style: kFourteenMediumTextStyle.copyWith(color: Colors.white),))
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WeatherElement extends StatelessWidget {
  const WeatherElement({
    super.key, this.weather, this.showRain = true,
  });

  final Weather? weather;
  final bool? showRain;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Image.network('https://developer.accuweather.com/sites/default/files/${(weather?.weatherIcon ?? 0) > 9 ? weather?.weatherIcon : "0${weather?.weatherIcon}"}-s.png'),
            const SizedBox(width: 5,),
            Text("${weather?.temperature?.value?.toInt()} \u2109", style: kTwentyFourBoldTextStyle,),
            const SizedBox(width: 15,),
            Text('Feels like ${weather?.realFeelTemperature?.value?.toInt()} \u2109', style: kTwelveMediumTextStyle,)
          ],
        ),
        const SizedBox(width: 5,),
        showRain == true ? Text("Rain: ${weather?.rainProbability}%", style: kTwelveMediumTextStyle,) : const SizedBox(),
      ],
    );
  }
}


