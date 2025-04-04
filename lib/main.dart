import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

// 位置情報の権限を確認する関数
Future<void> checkPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print("位置情報のアクセスが拒否されました。");
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    print("設定から位置情報の権限を有効にしてください。");
    return;
  }
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 現在地を格納する変数
  double? _latitude;
  double? _longitude;

  //現在の位置を取得する関数
Future<void> getCurrentLocation() async {
  await checkPermission(); // 権限を確認
  try {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );    
    print("現在地: 緯度 ${position.latitude}, 経度 ${position.longitude}");
          // 現在地を更新して画面を再描画
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
  } catch (e) {
    print("位置情報の取得に失敗しました: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '現在地:',
            ),
            // 緯度と経度を表示
            if (_latitude != null && _longitude != null)
              Text(
                '緯度: $_latitude, 経度: $_longitude',
                style: const TextStyle(fontSize: 16),
              )
            else
              const Text(
                '位置情報が取得されていません。',
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getCurrentLocation,
        tooltip: 'Get Location',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
