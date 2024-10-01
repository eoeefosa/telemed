import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:telemed/screens/dashboard.dart';
import 'package:telemed/services/api_service.dart';

void main() {
  runApp(const Telemed());
}

class Telemed extends StatelessWidget {
  const Telemed({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(
          create: (_) => ApiService(),
        ),
      ],
      child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, child) {
            return MaterialApp(
              title: 'Telemedicine Admin Panel',
              theme: ThemeData(
                colorScheme:
                    ColorScheme.fromSeed(seedColor: Colors.blue.shade900),
                useMaterial3: true,
              ),
              home: const DashboardScreen(),
            );
          }),
    );
  }
}
