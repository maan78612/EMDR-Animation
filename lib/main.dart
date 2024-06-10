import 'package:flutter/material.dart';

void main() {
  runApp(const PendulumApp());
}

class PendulumApp extends StatelessWidget {
  const PendulumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PendulumAnimation(),
    );
  }
}

class PendulumAnimation extends StatefulWidget {
  const PendulumAnimation({super.key});

  @override
  State<StatefulWidget> createState() => _PendulumAnimationState();
}

class _PendulumAnimationState extends State<PendulumAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _speed = 1;
  BallColor _ballColor = BallColor.grey;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 5000 ~/ (_speed * 4)),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: -1, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setSpeed(double value) {
    setState(() {
      _speed = value;
      _controller.duration =
          Duration(milliseconds: (5000 ~/ (_speed * 4)).toInt());
      _controller.stop();
      _controller.repeat(reverse: true);
    });
  }

  void _setBallColor(BallColor color) {
    setState(() {
      _ballColor = color;
    });
  }

  Color getColor(BallColor color) {
    switch (color) {
      case BallColor.grey:
        return Colors.grey;
      case BallColor.green:
        return Colors.green;
      case BallColor.red:
        return Colors.red;
      case BallColor.blue:
        return Colors.blue;
      case BallColor.yellow:
        return Colors.yellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pendulum Animation'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    MediaQuery.of(context).size.width / 2.1 * _animation.value,
                    0,
                  ),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        color: getColor(_ballColor),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.blue.withOpacity(0.4),
                              // Adjust opacity as needed
                              blurRadius: 10,
                              spreadRadius: 2,
                              blurStyle: BlurStyle.outer),
                        ]),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Row(
              children: [
                const Text(
                  "Speed",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Slider(
                    value: _speed,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    onChanged: _setSpeed,
                  ),
                ),
              ],
            ),
          ),


          Text('Speed: $_speed'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: BallColor.values
                .map((color) => GestureDetector(
                      onTap: () {
                        _setBallColor(color);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: getColor(color),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

enum BallColor { grey, green, red, blue, yellow }
