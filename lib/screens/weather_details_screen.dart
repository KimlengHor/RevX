import 'package:flutter/material.dart';
import 'package:rev_x/widgets/go_back_button.dart';
import '../constants/font_constants.dart';
import '../models/weather.dart';
import 'package:intl/intl.dart';

import 'home_screen.dart';

class WeatherDetailsScreen extends StatefulWidget {

  const WeatherDetailsScreen({super.key, required this.weathers, required this.selectedCity});

  final List<Weather?> weathers;
  final String selectedCity;

  @override
  State<WeatherDetailsScreen> createState() => _WeatherDetailsScreenState();
}

class _WeatherDetailsScreenState extends State<WeatherDetailsScreen> {

  String? _convertDateTime(String dateTimeString) {
    DateTime? dateTime = DateTime.tryParse(dateTimeString)?.subtract(const Duration(hours: 5));

    if (dateTime != null) {
      return DateFormat('hh:mm a').format(dateTime);
    }

    return null;
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GoBackButton(onTap: () {
                  Navigator.pop(context);
                }),
                const SizedBox(height: 29,),
                Text(widget.selectedCity, style: kThirtySixBoldTextStyle),
                const SizedBox(height: 8,),
                Text('Today Weather Information', style: kSixteenBoldTextStyle),
                const SizedBox(height: 36,),
                Text(widget.weathers.first?.iconPhrase ?? '', style: kSixteenBoldTextStyle,),
                const SizedBox(height: 6,),
                Text("The percentage of raining: ${widget.weathers.first?.rainProbability}%", style: kFourteenRegTextStyle.copyWith(color: Colors.grey),),
                const SizedBox(height: 12,),
                MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_convertDateTime(widget.weathers[index]?.dateTime ?? '') ?? '', style: kSixteenBoldTextStyle,),
                              WeatherElement(weather: widget.weathers[index]),
                            ],
                          ),
                        ),
                        const Divider()
                      ],
                    );
                  }, itemCount: widget.weathers.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


