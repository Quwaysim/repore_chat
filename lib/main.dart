import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:repore_chat/auth/presentation/splash.dart';
import 'package:repore_chat/home/application/presence_notifier.dart';
import 'package:repore_chat/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: MaterialApp(
        title: 'Repore Chat',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AppInit(
          child: SplashScreen(),
        ),
      ),
    );
  }
}

class AppInit extends ConsumerStatefulWidget {
  const AppInit({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  ConsumerState<AppInit> createState() => _AppInitState();
}

class _AppInitState extends ConsumerState<AppInit> {
  @override
  void initState() {
    super.initState();
    ref.read(presenceProvider);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
