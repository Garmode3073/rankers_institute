import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rankers_institute/models/test.dart';
import 'package:rankers_institute/services/mlhelper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:rankers_institute/globals.dart' as g;

class StuAnalysis extends StatefulWidget {
  final Map testd;
  final int doubtCount;
  final int allM;

  const StuAnalysis({Key key, this.testd, this.doubtCount, this.allM})
      : super(key: key);
  @override
  _StuAnalysisState createState() => _StuAnalysisState();
}

class _StuAnalysisState extends State<StuAnalysis> {
  String dropdownValue3;
  int total;
  List icons = [
    FontAwesomeIcons.meh,
    FontAwesomeIcons.smile,
    FontAwesomeIcons.smileBeam,
    FontAwesomeIcons.laughBeam
  ];
  List compli = [
    'You can do it. Try harder',
    'Great efforts, can do better',
    'Very good. You are great',
    'Marvellous!! You are one of the best'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffcaf0f8),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: g.width * 0.05, right: g.width * 0.05),
          child: ListView(
            children: [
              Container(
                color: Colors.white.withOpacity(0.7),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: dropdownValue3,
                  elevation: 16,
                  hint: Text('Subject'),
                  style: g.loginpgstyles(
                    Color(0xff000000),
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue3 = newValue;
                      total = 0;
                      for (int i = 0; i < widget.testd[newValue].length; i++) {
                        total += widget.testd[newValue][i].marks;
                      }
                      total = MLHelper().studentSide([
                        widget.doubtCount,
                        total / widget.testd[newValue].length
                      ]);
                    });
                  },
                  items:
                      widget.testd.keys.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: g.loginpgstyles(
                          Color(0xff000000),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: g.height * 0.1,
              ),
              dropdownValue3 != null
                  ? Column(
                      children: [
                        SfCartesianChart(
                            backgroundColor: Colors.white,
                            primaryXAxis: CategoryAxis(),
                            title: ChartTitle(text: 'Subject wise data'),
                            // legend: Legend(isVisible: true),
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <ChartSeries<TestData, String>>[
                              LineSeries<TestData, String>(
                                  xAxisName: 'Test Type',
                                  yAxisName: 'Marks',
                                  dataSource: widget.testd[dropdownValue3],
                                  xValueMapper: (TestData test, _) => test.test,
                                  yValueMapper: (TestData test, _) =>
                                      test.marks,
                                  name: 'Test Data',
                                  // Enable data label
                                  dataLabelSettings:
                                      DataLabelSettings(isVisible: true)),
                            ]),
                        Row(
                          children: [
                            Icon(
                              icons[total - 1],
                              color: Colors.blue,
                              size: g.width * 0.15,
                            ),
                            SizedBox(
                              width: g.width * 0.08,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(
                                  compli[total - 1] + ' in ' + dropdownValue3,
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 16),
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  : Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: g.width * 0.05,
                            vertical: g.height * 0.025),
                        decoration: BoxDecoration(
                          color: Color(0xff0077b6).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Select a Subject to view analysis',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
              SizedBox(
                height: g.height * 0.1,
              ),
              Center(
                child: Text(
                  widget.allM == null
                      ? ''
                      : '${compli[widget.allM - 1]} in your class',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
