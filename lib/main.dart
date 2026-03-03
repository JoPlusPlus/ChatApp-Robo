import 'package:chatwala/core/app_router.dart';
import 'package:chatwala/core/bloc_observer.dart';
import 'package:chatwala/core/theme_cubit.dart';
import 'package:chatwala/core/utils/app_theme.dart';
import 'package:chatwala/feature/auth/data/auth_repository.dart';
import 'package:chatwala/feature/auth/logic/auth_cubit.dart';
import 'package:chatwala/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    return;
  }
  Bloc.observer = AppBlocObserver();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  runApp(DevicePreview(enabled: false, builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => AuthRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthCubit(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider(create: (context) => ThemeCubit()),
        ],
        child: BlocBuilder<ThemeCubit, bool>(
          builder: (context, isDarkMode) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: DevicePreview.locale(context),
              builder: DevicePreview.appBuilder,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
              initialRoute: AppRouter.splash,
              onGenerateRoute: AppRouter.onGenerateRoute,
            );
          },
        ),
      ),
    );
  }
}
