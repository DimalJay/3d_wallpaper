import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AccelerometerEvent accelerometerEvent = AccelerometerEvent(0, 0, 0);
  double speed = 2;
  @override
  void initState() {
    accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        setState(() {
          accelerometerEvent = event;
        });
      },
      onError: (error) {
        // Logic to handle error
        // Needed for Android in case sensor is not available
      },
      cancelOnError: true,
    );
    super.initState();
  }

  Map<String, double> images = {
    "assets/flower/l2.png": -1,
    "assets/flower/l3.png": 0.5,
    "assets/flower/l4.png": 1,
    "assets/flower/l5.png": 1.5
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
              top: 0, right: 0, child: Image.asset("assets/flower/l1.png")),
          ...images
              .map((image, i) => MapEntry(
                  image,
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    transform: Matrix4.identity()
                      ..translate(accelerometerEvent.x * speed * i,
                          50 - accelerometerEvent.y * speed * i),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(image),
                        ),
                      ),
                    ),
                  )))
              .values
              .toList(),
        ],
      ),
    );
  }
}

class CardImage extends StatefulWidget {
  const CardImage({
    super.key,
  });

  @override
  State<CardImage> createState() => _CardImageState();
}

class _CardImageState extends State<CardImage> {
  AccelerometerEvent accelerometerEvent = AccelerometerEvent(0, 0, 0);
  double speed = 1.6;
  @override
  void initState() {
    accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        setState(() {
          accelerometerEvent = event;
        });
      },
      onError: (error) {
        // Logic to handle error
        // Needed for Android in case sensor is not available
      },
      cancelOnError: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      child: SizedOverflowBox(
        size: MediaQuery.of(context).size,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              transform: Matrix4.identity()
                ..translate(-accelerometerEvent.x * speed,
                    accelerometerEvent.y * speed),
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              transform: Matrix4.identity()
                ..translate(accelerometerEvent.x * speed,
                    50 - accelerometerEvent.y * speed),
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/fg.png"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
