import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kicca/providers/ai_suggestion_provider.dart';
import 'package:kicca/view/page/diagnosis_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AISuggestionProvider(
            apiKey: const String.fromEnvironment('GEMINI_API_KEY'),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Kicca',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const DiagnosisPage(),
      ),
    );
  }
}
