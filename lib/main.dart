import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:equations/equations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Kvadrat Tenglamani yechish'),
          backgroundColor: Colors.teal,
        ),
        body: const Solver(),
      ),
    );
  }
}

class Quadratic {
  double a;
  double b;
  double c;

  Quadratic(this.a, this.b, this.c);

  List<Complex> sols() {
    final D = b * b - 4 * a * c;
    if (D < 0) {
      return [];
    } else if (D == 0) {
      return [Complex.fromReal(-b / (2 * a))];
    } else {
      final dd = math.sqrt(D);
      return [
        Complex.fromReal((-b + dd) / (2 * a)),
        Complex.fromReal((-b - dd) / (2 * a)),
      ];
    }
  }
}

class Solver extends StatefulWidget {
  const Solver({Key? key}) : super(key: key);

  @override
  _SolverState createState() => _SolverState();
}

class _SolverState extends State<Solver> with TickerProviderStateMixin {
  TextEditingController aC = TextEditingController(text: '1');
  TextEditingController bC = TextEditingController(text: '5');
  TextEditingController cC = TextEditingController(text: '6');
  String res = '';
  bool showGraph = false;

  double a = 0;
  double b = 0;
  double c = 0;

  late AnimationController _bubbleController;
  late List<Widget> _bubbles;

  @override
  void initState() {
    super.initState();

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _bubbles = List.generate(20, (index) {
      return AnimatedBubble(controller: _bubbleController, index: index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 110,
                  child: Image.asset('assets/math.png'),
                ),
                Card(
                  elevation: 4.0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: <Widget>[
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          child: TextField(
                            controller: aC,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'a',
                              labelStyle: TextStyle(color: Colors.blue),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          child: TextField(
                            controller: bC,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'b',
                              labelStyle: TextStyle(color: Colors.blue),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          child: TextField(
                            controller: cC,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'c',
                              labelStyle: TextStyle(color: Colors.blue),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    calc();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text(
                    'Yechish',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: res.isNotEmpty
                      ? Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      res,
                      style: const TextStyle(fontSize: 18),
                    ),
                  )
                      : const SizedBox(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("BU FUNKSIYA HOZIRCHA ISHLAMAYABDI"),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Text('Grafikni Ko\'rsatish',
                      style: TextStyle(color: Colors.white)),
                ),
                if (showGraph)
                  Column(
                    children: [
                      SizedBox(
                        height: 300,
                        child: LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: false),
                            titlesData: const FlTitlesData(show: false),
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(
                                color: const Color(0xff37434d),
                                width: 1,
                              ),
                            ),
                            minX: -10,
                            maxX: 10,
                            minY: -10,
                            maxY: 10,
                            lineBarsData: [
                              LineChartBarData(
                                spots: List.generate(100, (index) {
                                  final x = (index - 50) / 5.0;
                                  final y = a * x * x + b * x + c;
                                  return FlSpot(x, y);
                                }),
                                isCurved: true,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(show: false),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 30,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  launch('https://t.me/NarzullayevS');
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/telegram.png'),
                ),
              ),
              const SizedBox(width: 20),
              InkWell(
                onTap: () {
                  launch('https://github.com/NarzullayevMe');
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/github.png'),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Copyright © 2023 Narzullayev Saidakbar"),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            child: const Text(
              'Copyright © 2023 Narzullayev Saidakbar',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        for (var bubble in _bubbles) bubble,
      ],
    );
  }
  void calc() {
    String aText = aC.text;
    String bText = bC.text;
    String cText = cC.text;

    if (aText.isEmpty || bText.isEmpty || cText.isEmpty) {
      setState(() {
        res = 'Iltimos, hamma maydonlarni to\'ldiring.';
      });
      return;
    }

    a = double.tryParse(aText) ?? 1;
    b = double.tryParse(bText) ?? 5;
    c = double.tryParse(cText) ?? 6;

    final eq = Quadratic(a, b, c);
    final sols = eq.sols();

    if (sols.isNotEmpty) {
      final x1 = sols[0].real;
      final x2 = sols.length > 1 ? sols[1].real : null;

      final eqStr = (a == 1) ? 'x^2' : '${a}x^2';
      final x2Term = (x2 != null) ? 'x2 = $x2' : '';

      final newRes = (x2 != null)
          ? 'Yechimlar:\n$eqStr + ${b}x + $c = 0\nx1 = $x1\n$x2Term'
          : 'Yechim: $eqStr + ${b}x + $c = 0\nx = $x1';

      setState(() {
        res = newRes;
      });
    } else {
      setState(() {
        res = 'Haqiqiy yechimlar mavjud emas.';
      });
    }
  }

  @override
  void dispose() {
    aC.dispose();
    bC.dispose();
    cC.dispose();
    _bubbleController.dispose();
    super.dispose();
  }
}

class AnimatedBubble extends StatefulWidget {
  final AnimationController controller;
  final int index;

  const AnimatedBubble({required this.controller, required this.index});

  @override
  _AnimatedBubbleState createState() => _AnimatedBubbleState();
}

class _AnimatedBubbleState extends State<AnimatedBubble> {
  late Animation<double> _animation;
  late double _initialSize;

  @override
  void initState() {
    super.initState();

    _initialSize = Random().nextDouble() * 20.0 + 10.0;

    _animation = Tween<double>(
      begin: _initialSize,
      end: _initialSize * 2,
    ).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Interval(
          (widget.index / 2),
          (widget.index / 2) + 0.5,
          curve: Curves.easeInOut,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        return Positioned(
          top: _animation.value * 10,
          left: Random().nextDouble() * 400,
          child: Opacity(
            opacity: 1.0 - widget.controller.value,
            child: Container(
              width: _animation.value,
              height: _animation.value,
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}
