import 'package:rev_x/models/weather.dart';

import '../services/networking.dart';

class WeatherVM {
  Future<String?> getLocationKey(String cityName) async {
    try {
      NetworkHelper networkHelper = NetworkHelper(url: 'http://dataservice.accuweather.com/locations/v1/cities/search', parameters: {
        'apikey': 'rGusLNyhubJxAtSRjAknlHJCQkCgiQe1',
        'q': cityName,
      });
      var data = await networkHelper.getData();
      return data.first['Key'];
    } catch (e) {
      return null;
    }
  }

  Future<List<Weather?>> getForecasts(String locationKey) async {
    try {
      NetworkHelper networkHelper = NetworkHelper(url: 'http://dataservice.accuweather.com/forecasts/v1/hourly/12hour/$locationKey', parameters: {
        'apikey': 'rGusLNyhubJxAtSRjAknlHJCQkCgiQe1',
        'details': 'true',
      });
      var data = await networkHelper.getData();
      // print("The data is $data");
      final weatherList = WeatherList.fromJson(data);
      return weatherList.weathers;
    } catch (e) {
      return [];
    }
  }
}