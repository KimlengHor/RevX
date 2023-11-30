class WeatherList {
  final List<Weather?> weathers;

  WeatherList(this.weathers);

  factory WeatherList.fromJson(List<dynamic>? data) {
    print(data?.first);
    final weathers = data != null
        ? data.map((weatherData) => Weather.fromJson(weatherData))
        .toList()
        : <Weather>[];

    return WeatherList(weathers);
  }
}

class Weather {
  final int? weatherIcon;
  final String? iconPhrase;
  final String? dateTime;
  final Temperature? temperature;
  final Temperature? realFeelTemperature;
  final int? relativeHumidity;
  final int? rainProbability;

  Weather(this.weatherIcon, this.iconPhrase, this.dateTime, this.temperature, this.realFeelTemperature, this.relativeHumidity, this.rainProbability);

  factory Weather.fromJson(Map<String, dynamic>? data) {
    final weatherIcon = data?['WeatherIcon'] as int?;
    final iconPhrase = data?['IconPhrase'] as String?;
    final dateTime = data?['DateTime'] as String?;
    final temperatureData = data?['Temperature'];
    final temperature = temperatureData != null ? Temperature.fromJson(temperatureData) : null;
    final realFeelTemperatureData = data?['RealFeelTemperature'];
    final realFeelTemperature = realFeelTemperatureData != null ? Temperature.fromJson(realFeelTemperatureData) : null;
    final relativeHumidity = data?['RelativeHumidity'] as int?;
    final rainProbability = data?['RainProbability'] as int?;
    return Weather(weatherIcon, iconPhrase, dateTime, temperature, realFeelTemperature, relativeHumidity, rainProbability);
  }
}

class Temperature {
  final double? value;
  final String? unit;
  final String? phrase;

  Temperature(this.value, this.unit, this.phrase);

  factory Temperature.fromJson(Map<String, dynamic>? data) {
    final value = data?['Value'] as double?;
    final unit = data?['Unit'] as String?;
    final phrase = data?['Phrase'] as String?;
    return Temperature(value, unit, phrase);
  }
}