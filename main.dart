import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bill_tracker/firebase_options.dart';
import 'package:bill_tracker/locales/app_locale.dart';
import 'package:bill_tracker/screens/generic/welcome_screen.dart';
import 'package:bill_tracker/utils/globals.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:appwrite/appwrite.dart' as appwrite;
import 'package:supabase_flutter/supabase_flutter.dart';

appwrite.Client client = appwrite.Client();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final FlutterLocalization localization = FlutterLocalization.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      // name: "Main",
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error) {
    print(error.toString());
  }

  final savedThemeMode =
      (await AdaptiveTheme.getThemeMode()) ?? AdaptiveThemeMode.light;
  if (savedThemeMode == AdaptiveThemeMode.dark) {
    Globals.currentTheme = "dark";
  }

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print(e.toString());
  }

  try {
    await initializeDateFormatting();
  } catch (e) {
    print(e.toString());
  }

  // Initialize AppWrite
  // try {
  //   client
  //       .setEndpoint(dotenv.env["APPWRITE_API_ENDPOINT"].toString())
  //       .setProject(dotenv.env["APPWRITE_PROJECT_ID"].toString())
  //       .setSelfSigned();
  // } catch (e) {
  //   print(e.toString());
  // }

  // Initialize supabase
  try {
    await Supabase.initialize(
      url: dotenv.env["SUPABASE_URL"].toString(),
      anonKey: dotenv.env["SUPABASE_KEY"].toString(),
    );

    // // Get a reference your Supabase client
    //     final supabase = Supabase.instance.client;
  } catch (e) {
    print(e.toString());
  }

  runApp(
    MyApp(
      themeMode: savedThemeMode,
    ),
  );
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  AdaptiveThemeMode themeMode = AdaptiveThemeMode.light;

  MyApp({
    super.key,
    required this.themeMode,
  });

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // ThemeData lightTheme = ThemeData.light();
  // ThemeData darkTheme = ThemeData.dark();

  @override
  void initState() {
    localization.init(
      mapLocales: [
        const MapLocale('en', AppLocale.EN),
        const MapLocale('ar', AppLocale.AR),
      ],
      initLanguageCode: 'en',
    );
    localization.onTranslatedLanguage = _onTranslatedLanguage;

    super.initState();
  }

  // the setState function here is a must to add
  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.light().copyWith(
        textTheme: GoogleFonts.arimaTextTheme(
          ThemeData.light().textTheme,
        ),
        primaryTextTheme: GoogleFonts.arimaTextTheme(
          ThemeData.light().textTheme,
        ),
      ),
      dark: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.arimaTextTheme(
          ThemeData.dark().textTheme,
        ),
        primaryTextTheme: GoogleFonts.arimaTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      initial: widget.themeMode,
      builder: (theme, darkTheme) => MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Bill-Tracker',
        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: darkTheme,
        supportedLocales: localization.supportedLocales,
        localizationsDelegates: localization.localizationsDelegates,
        home: WelcomeScreen(),
        builder: EasyLoading.init(),
      ),
    );

    // return MaterialApp(
    //   navigatorKey: navigatorKey,
    //   title: 'Bill-Tracker',
    //   theme: ThemeData.light(),
    //   debugShowCheckedModeBanner: false,
    //   home: WelcomeScreen(),
    //   builder: EasyLoading.init(),
    // );
  }
}
