import 'package:animate_do/animate_do.dart';
import 'package:assistant_app/croe/constants/pallete.dart';
import 'package:assistant_app/features/feature_box.dart';
import 'package:assistant_app/services/openai_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart'; // Add this for permissions

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  String lastWords = "";
  final OpenAIService openaiService = OpenAIService();
  final flutterTts = FlutterTts();
  String? generatedContent;
  String? generatedImageUrl;
  int start = 200;
  int delay = 200;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    // Request microphone permission if not already granted
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      bool available = await speechToText.initialize(
        onError: (error) => print('Error: $error'), // Log any errors
      );
      if (!available) {
        // Show a message to the user if speech recognition is not available
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Speech recognition is not available on this device.')));
      }
    } else {
      // If permission is denied, notify the user
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Microphone permission is required to use speech recognition.')));
    }
    setState(() {});
  }

  Future<void> startListening() async {
    if (speechToText.isNotListening) {
      await speechToText.listen(onResult: onSpeechResult);
      setState(() {});
    }
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemspeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(child: Text("AWR Helper")),
        centerTitle: true,
        leading: const Icon(Icons.menu),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image of assistant
            ZoomIn(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                          color: Pallete.assistantCircleColor,
                          shape: BoxShape.circle),
                    ),
                  ),
                  Container(
                    height: 123,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage("assets/images/assistant.png"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Greeting container
            FadeInRight(
              child: Visibility(
                visible: generatedImageUrl == null,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 40)
                      .copyWith(top: 30),
                  decoration: BoxDecoration(
                      border: Border.all(color: Pallete.borderColor),
                      borderRadius: BorderRadius.circular(20)
                          .copyWith(topLeft: Radius.zero)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      generatedContent == null
                          ? "Good morning, How can I help you?"
                          : generatedContent!,
                      style: TextStyle(
                          color: Pallete.mainFontColor,
                          fontSize: generatedContent == null ? 20 : 18,
                          fontFamily: "Cera Pro",
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            if (generatedImageUrl != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(generatedImageUrl!)),
              ),
            SlideInLeft(
              child: Visibility(
                visible: generatedContent == null && generatedImageUrl == null,
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 10, left: 22),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Here are a few commands",
                    style: TextStyle(
                        fontFamily: "Cera Pro",
                        color: Pallete.mainFontColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            // Features list
            Visibility(
              visible: generatedContent == null,
              child: Column(
                children: [
                  SlideInLeft(
                    delay: Duration(milliseconds: start),
                    child: const FeatureBox(
                      color: Pallete.firstSuggestionBoxColor,
                      headerText: "Chat GPT",
                      descriptionText:
                          "A smarter way to stay organized and informed with ChatGPT",
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start +delay),
                    child: const FeatureBox(
                      color: Pallete.secondSuggestionBoxColor,
                      headerText: "Dall-E",
                      descriptionText:
                          "Get inspired and stay creative with your personal assistant powered by Dall-E",
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + delay*2),
                    child: const FeatureBox(
                      color: Pallete.thirdSuggestionBoxColor,
                      headerText: "Smart Voice Assistant",
                      descriptionText:
                          "Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT",
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: ZoomIn(
                            delay: Duration(milliseconds: start + delay*3),

        child: FloatingActionButton(
          backgroundColor: Pallete.firstSuggestionBoxColor,
          onPressed: () async {
            if (await speechToText.hasPermission && !speechToText.isListening) {
              await startListening();
            } else if (speechToText.isListening) {
              final speech = await openaiService.isArtPromptAPI(lastWords);
              if (speech.contains('https')) {
                generatedImageUrl = speech;
                generatedContent = null;
                setState(() {});
              } else {
                generatedImageUrl = null;
                generatedContent = speech;
                setState(() {});
                await systemspeak(speech);
              }
              await stopListening();
            } else {
              initSpeechToText();
            }
          },
          child: Icon(speechToText.isListening ? Icons.stop : Icons.mic),
        ),
      ),
    );
  }
}
