import 'package:assistant_app/croe/constants/pallete.dart';
import 'package:assistant_app/features/feature_box.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AWR Helper"),
        centerTitle: true,
        leading: const Icon(Icons.menu),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //image of assistant
            Stack(
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
            //greeting container
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin:
                  const EdgeInsets.symmetric(horizontal: 40).copyWith(top: 30),
              decoration: BoxDecoration(
                  border: Border.all(color: Pallete.borderColor),
                  borderRadius:
                      BorderRadius.circular(20).copyWith(topLeft: Radius.zero)),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Good morning, How can I help you?",
                  style: TextStyle(
                      color: Pallete.mainFontColor,
                      fontSize: 20,
                      fontFamily: "Cera Pro",
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top: 10, left: 22),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Here are few commands",
                style: TextStyle(
                    fontFamily: "Cera Pro",
                    color: Pallete.mainFontColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),

            //Features list
            const Column(
              children: [
                FeatureBox(
                  color: Pallete.firstSuggestionBoxColor,
                  headerText: "Chat GPT",
                  descriptionText:
                      "A smarter way to stay organized and informed with ChatGpT",
                ),
                FeatureBox(
                  color: Pallete.secondSuggestionBoxColor,
                  headerText: "Dall-E",
                  descriptionText:
                      "Get inspired and stay creative with your personal assistant powered by Dall-E",
                ),
                FeatureBox(
                  color: Pallete.thirdSuggestionBoxColor,
                  headerText: "Smart Voice Assistant",
                  descriptionText:
                      "Get the best og both worlds with a voice assistant powered by Dall-E and ChatGPT",
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Pallete.firstSuggestionBoxColor,
        onPressed: () {},
        child: const Icon(Icons.mic),
      ),
    );
  }
}
