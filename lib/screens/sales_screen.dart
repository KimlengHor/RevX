import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:rev_x/widgets/rounded_corner_container.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../constants/font_constants.dart';

class Sale {
  String date;
  String time;
  String sale;
  String city;
  String state;

  Sale({
    required this.date,
    required this.time,
    required this.sale,
    required this.city,
    required this.state,
  });
}

class SalesScreen extends StatefulWidget {

  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {

  int _totalSales = 0;
  List<ChartSampleData>? _chartData;
  List<StackedLineSeries<ChartSampleData, String>> _lines = [];

  Map<String, List<Sale>> _salesByAustinWeek = {};
  Map<String, List<Sale>> _salesByHoustonWeek = {};
  Map<String, List<Sale>> _salesByCollegeStationWeek = {};

  Map<String, List<Sale>> _salesByAustinMonth = {};
  Map<String, List<Sale>> _salesByHoustonMonth = {};
  Map<String, List<Sale>> _salesByCollegeStationMonth = {};

  List<String> _filterByWeek = [];
  List<String> _filterByMonth = [];

  bool _isWeekly = true;

  String _timeOfTheDay = 'All';

  Future<void> _loadCsv() async {
    String data = await rootBundle.loadString('assets/sale_data.csv'); // Change the path to your CSV file
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(data);

    List<Sale> tempSales = [];

    for (var i = 1; i < rowsAsListOfValues.length; i++) {
      var row = rowsAsListOfValues[i];
      var sale = Sale(
        date: row[0].toString(),
        time: row[1].toString(),
        sale: row[2].toString(),
        city: row[3].toString(),
        state: row[4].toString(),
      );
      tempSales.add(sale);
    }

    _salesByAustinWeek = _groupSalesByWeek(tempSales, 'Austin');
    _salesByHoustonWeek = _groupSalesByWeek(tempSales, 'Houston');
    _salesByCollegeStationWeek = _groupSalesByWeek(tempSales, 'College Station');

    _salesByAustinMonth = _groupSalesByMonth(tempSales, 'Austin');
    _salesByHoustonMonth = _groupSalesByMonth(tempSales, 'Houston');
    _salesByCollegeStationMonth = _groupSalesByMonth(tempSales, 'College Station');

    _setupChartData();

    setState(() {
      _totalSales = tempSales.fold(0, (prev, curr) => prev + int.parse(curr.sale));
    });
  }

  void _setupChartData() {
      if (_isWeekly) {
        _chartData = _salesByCollegeStationWeek.entries.expand((entry) {
          if (_filterByWeek.isNotEmpty) {
            if (!_filterByWeek.contains(entry.key)) {
              return [];
            }
          }
          String week = entry.key;
          List<Sale> salesInWeek = entry.value;
          int totalSale = 0;

          if (_timeOfTheDay == 'All') {
            totalSale = salesInWeek.fold(
                0, (prev, curr) => prev + int.parse(curr.sale));
          } else {
            for (var sale in salesInWeek) {
              if (_timeOfTheDay == sale.time) {
                totalSale += int.parse(sale.sale);
              }
            }
          }

          return [ChartSampleData(
              x: week, // Combine date and time, modify as needed
              y: totalSale, // Use the sale amount as y value, modify as needed
            )
          ];
        }).cast<ChartSampleData>().toList();
        _chartData?.addAll(_salesByHoustonWeek.entries.expand((entry) {
          if (_filterByWeek.isNotEmpty) {
            if (!_filterByWeek.contains(entry.key)) {
              return [];
            }
          }
          String week = entry.key;
          List<Sale> salesInWeek = entry.value;
          int totalSale = 0;

          if (_timeOfTheDay == 'All') {
            totalSale = salesInWeek.fold(
                0, (prev, curr) => prev + int.parse(curr.sale));
          } else {
            for (var sale in salesInWeek) {
              if (_timeOfTheDay == sale.time) {
                totalSale += int.parse(sale.sale);
              }
            }
          }

          // return salesInWeek.map((sale) {
          return [ChartSampleData(
            x: week, // Combine date and time, modify as needed
            yValue: totalSale, // Use the sale amount as y value, modify as needed
            // If you have secondSeriesYValue and thirdSeriesYValue, add them here similarly
          )
          ];
          // });
        }).cast<ChartSampleData>().toList());
        _chartData?.addAll(_salesByAustinWeek.entries.expand((entry) {
          if (_filterByWeek.isNotEmpty) {
            if (!_filterByWeek.contains(entry.key)) {
            return [];
            }
          }
          String week = entry.key;
          List<Sale> salesInWeek = entry.value;
          int totalSale = 0;

          if (_timeOfTheDay == 'All') {
            totalSale = salesInWeek.fold(
                0, (prev, curr) => prev + int.parse(curr.sale));
          } else {
            for (var sale in salesInWeek) {
              if (_timeOfTheDay == sale.time) {
                totalSale += int.parse(sale.sale);
              }
            }
          }

          return [ChartSampleData(
            x: week, // Combine date and time, modify as needed
            secondSeriesYValue: totalSale, // Use the sale amount as y value, modify as needed
            // If you have secondSeriesYValue and thirdSeriesYValue, add them here similarly
          )
          ];
        }).cast<ChartSampleData>().toList());
      } else {
        _chartData = _salesByCollegeStationMonth.entries.expand((entry) {
          if (_filterByMonth.isNotEmpty) {
            if (!_filterByMonth.contains(entry.key)) {
              return [];
            }
          }
          String month = entry.key;
          List<Sale> salesInWeek = entry.value;
          int totalSale = 0;

          if (_timeOfTheDay == 'All') {
            totalSale = salesInWeek.fold(
                0, (prev, curr) => prev + int.parse(curr.sale));
          } else {
            for (var sale in salesInWeek) {
              if (_timeOfTheDay == sale.time) {
                totalSale += int.parse(sale.sale);
              }
            }
          }
          return [ChartSampleData(
            x: month, // Combine date and time, modify as needed
            y: totalSale, // Use the sale amount as y value, modify as needed
            // If you have secondSeriesYValue and thirdSeriesYValue, add them here similarly
          )
          ];
        }).cast<ChartSampleData>().toList();
        _chartData?.addAll(_salesByHoustonMonth.entries.expand((entry) {
          if (_filterByMonth.isNotEmpty) {
            if (!_filterByMonth.contains(entry.key)) {
              return [];
            }
          }
          String month = entry.key;
          List<Sale> salesInWeek = entry.value;
          int totalSale = 0;

          if (_timeOfTheDay == 'All') {
            totalSale = salesInWeek.fold(
                0, (prev, curr) => prev + int.parse(curr.sale));
          } else {
            for (var sale in salesInWeek) {
              if (_timeOfTheDay == sale.time) {
                totalSale += int.parse(sale.sale);
              }
            }
          }

          return [ChartSampleData(
            x: month, // Combine date and time, modify as needed
            yValue: totalSale, // Use the sale amount as y value, modify as needed
            // If you have secondSeriesYValue and thirdSeriesYValue, add them here similarly
          )
          ];
        }).cast<ChartSampleData>().toList());
        _chartData?.addAll(_salesByAustinMonth.entries.expand((entry) {
          if (_filterByMonth.isNotEmpty) {
            if (!_filterByMonth.contains(entry.key)) {
              return [];
            }
          }
          String month = entry.key;
          List<Sale> salesInWeek = entry.value;
          int totalSale = 0;

          if (_timeOfTheDay == 'All') {
            totalSale = salesInWeek.fold(
                0, (prev, curr) => prev + int.parse(curr.sale));
          } else {
            for (var sale in salesInWeek) {
              if (_timeOfTheDay == sale.time) {
                totalSale += int.parse(sale.sale);
              }
            }
          }

          return [ChartSampleData(
            x: month, // Combine date and time, modify as needed
            secondSeriesYValue: totalSale, // Use the sale amount as y value, modify as needed
            // If you have secondSeriesYValue and thirdSeriesYValue, add them here similarly
          )
          ];
        }).cast<ChartSampleData>().toList());
      }

    setState(() {
      _lines = _getStackedLineSeries();
    });
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  int _getWeekNumber(DateTime date) {
    DateTime monday = date.subtract(Duration(days: date.weekday - 1)); // Get Monday of the week
    DateTime firstDayOfYear = DateTime(date.year, 1, 1); // Get the first day of the year
    int weekNumber = ((monday.difference(firstDayOfYear).inDays) / 7).ceil();
    return weekNumber + 1;
  }

  Map<String, List<Sale>> _groupSalesByWeek(List<Sale> sales, String city) {
    Map<String, List<Sale>> salesByWeek = {};

    for (var sale in sales) {
      if (city == sale.city) {
        String dateStr = sale.date;
        List<String> parts = dateStr.split('/'); // Split the date string
        int year = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int day = int.parse(parts[2]);

        DateTime saleDate = DateTime(year, month, day); // Convert string date to DateTime object
        String week = _getWeekNumber(saleDate).toString(); // Get week number
        String key = 'Week $week'; // Create a key for the week

        if (!salesByWeek.containsKey(key)) {
          salesByWeek[key] = [];
        }

        salesByWeek[key]!.add(sale);
      }
    }

    return salesByWeek;
  }

  Map<String, List<Sale>> _groupSalesByMonth(List<Sale> sales, String city) {
    Map<String, List<Sale>> salesByMonth = {};

    for (var sale in sales) {
      String dateStr = sale.date;
      List<String> parts = dateStr.split('/'); // Split the date string
      int year = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int day = int.parse(parts[2]);

      DateTime saleDate = DateTime(year, month, day); // Convert string date to DateTime object
      String saleMonth = _getMonthName(saleDate.month); // Get month name
      String key = saleMonth; // Create a key for the month and year

      if (!salesByMonth.containsKey(key)) {
        salesByMonth[key] = [];
      }

      salesByMonth[key]!.add(sale);
    }

    return salesByMonth;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadCsv();
  }

  List<StackedLineSeries<ChartSampleData, String>> _getStackedLineSeries() {
    return <StackedLineSeries<ChartSampleData, String>>[
      StackedLineSeries<ChartSampleData, String>(
          dataSource: _chartData!,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: 'College Station',
          markerSettings: const MarkerSettings(isVisible: true, shape: DataMarkerType.diamond)),
      StackedLineSeries<ChartSampleData, String>(
          dataSource: _chartData!,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.yValue,
          name: 'Houston',
          markerSettings: const MarkerSettings(isVisible: true, shape: DataMarkerType.triangle)),
      StackedLineSeries<ChartSampleData, String>(
          dataSource: _chartData!,
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.secondSeriesYValue,
          name: 'Austin',
          markerSettings: const MarkerSettings(isVisible: true, shape: DataMarkerType.rectangle)),
    ];
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
                Text('Sales', style: kThirtySixBoldTextStyle),
                const SizedBox(height: 27,),
                Row(
                  children: [
                    SalesDateTypeButton(isSelected: _isWeekly, title: 'Weekly', onTap: () {
                      setState(() {
                        _isWeekly = true;
                      });
                      _setupChartData();
                    },),
                    const SizedBox(width: 13,),
                    SalesDateTypeButton(isSelected: !_isWeekly, title: 'Monthly', onTap: () {
                      setState(() {
                        _isWeekly = false;

                      });
                      _setupChartData();
                    },),
                    // const SizedBox(width: 13,),
                    // SalesDateTypeButton(title: 'Yearly', onTap: () {},),
                  ],
                ),
                const SizedBox(height: 27,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Sales', style: kFourteenRegTextStyle,),
                        const SizedBox(height: 9,),
                        Text('$_totalSales Tacos', style: kSixteenBoldTextStyle,),
                      ],
                    ),
                    Column(
                      children: [
                        DropdownButton(value: _timeOfTheDay, hint: Text('Select Time of the Day', style: kFourteenMediumTextStyle.copyWith(color: Colors.black),), items: [
                          DropdownMenuItem<String>(value: 'All', child: Text('All', style: kFourteenMediumTextStyle,),),
                          DropdownMenuItem<String>(value: 'Morning', child: Text('Morning', style: kFourteenMediumTextStyle,),),
                          DropdownMenuItem<String>(value: 'Afternoon', child: Text('Afternoon', style: kFourteenMediumTextStyle,),),
                          DropdownMenuItem<String>(value: 'Noon', child: Text('Noon', style: kFourteenMediumTextStyle,),),
                          DropdownMenuItem<String>(value: 'Midnight', child: Text('Midnight', style: kFourteenMediumTextStyle,),)
                        ], onChanged: (value) {
                          _timeOfTheDay = value ?? '';
                          _setupChartData();
                        }),
                        SizedBox(
                          width: 200,
                          child: _isWeekly ? MultiSelectDialogField(buttonText: Text('Select Weeks', style: kFourteenMediumTextStyle,), items: _salesByCollegeStationWeek.keys.map((week) {
                              return MultiSelectItem<String>(week, week);
                            }
                          ).toList(), onConfirm: (value) {
                            _filterByMonth.clear();
                            _filterByWeek = value;
                            _setupChartData();
                          },) : MultiSelectDialogField(buttonText: Text('Select Months', style: kFourteenMediumTextStyle,), items: _salesByCollegeStationMonth.keys.map((month) {
                            return MultiSelectItem<String>(month, month);
                          }
                          ).toList(), onConfirm: (value) {
                            _filterByWeek.clear();
                            _filterByMonth = value;
                            _setupChartData();
                          },),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30,),
                SizedBox(
                  height: 500,
                  child: Column(children: [
                    //Initialize the chart widget
                    SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        // Chart title
                        title: ChartTitle(text: '${_isWeekly ? 'Weekly' : 'Monthly'} sales analysis'),
                        // Enable legend
                        legend: const Legend(isVisible: true, position: LegendPosition.bottom),
                        // Enable tooltip
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: _lines),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SalesDateTypeButton extends StatelessWidget {
  const SalesDateTypeButton({
    super.key, this.onTap, required this.title, this.isSelected,
  });

  final Function()? onTap;
  final String title;
  final bool? isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RoundedCornerContainer(
        color: isSelected == true ? Colors.black : Colors.grey.shade300,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(title, style: kFourteenRegTextStyle.copyWith(color: isSelected == true ? Colors.white : Colors.black),),
        )
      ),
    );
  }
}

///Chart sample data
class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData(
      {this.x,
        this.y,
        this.xValue,
        this.yValue,
        this.secondSeriesYValue,
        this.thirdSeriesYValue,
        this.pointColor,
        this.size,
        this.text,
        this.open,
        this.close,
        this.low,
        this.high,
        this.volume});

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num? y;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num? yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num? secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num? thirdSeriesYValue;

  /// Holds point color of the datapoint
  final Color? pointColor;

  /// Holds size of the datapoint
  final num? size;

  /// Holds datalabel/text value mapper of the datapoint
  final String? text;

  /// Holds open value of the datapoint
  final num? open;

  /// Holds close value of the datapoint
  final num? close;

  /// Holds low value of the datapoint
  final num? low;

  /// Holds high value of the datapoint
  final num? high;

  /// Holds open value of the datapoint
  final num? volume;
}


