import 'package:flutter/material.dart';

void main() {
  runApp(PendulumApp());
}

class PendulumApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PendulumAnimation(),
    );
  }
}

class PendulumAnimation extends StatefulWidget {
  @override
  _PendulumAnimationState createState() => _PendulumAnimationState();
}

class _PendulumAnimationState extends State<PendulumAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _speed = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5 ~/ _speed),
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
      _controller.duration = Duration(seconds: (5 ~/ _speed).toInt());
      _controller.stop();
      _controller.repeat(reverse: true);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pendulum Animation'),
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
                    MediaQuery.of(context).size.width / 3 * _animation.value,
                    0,
                  ),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          Slider(
            value: _speed,
            min: 1,
            max: 5,
            divisions: 4,
            onChanged: _setSpeed,
          ),
          Text('Speed: $_speed'),
        ],
      ),
    );
  }
}
