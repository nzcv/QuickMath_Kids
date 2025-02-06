import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final List<FAQItem> allFAQs = [
    FAQItem(
      question: "What is QuickMath_Kids?",
      answer:
          "QuickMath_Kids is an educational app designed to help children improve their math skills through fun and interactive exercises.",
    ),
    FAQItem(
      question: "Who is this app for?",
      answer:
          "The app is primarily for children, especially those in elementary or primary school, who are learning basic math concepts like addition, subtraction, multiplication, and division.",
    ),
    FAQItem(
      question: "What features does the app offer?",
      answer:
          "The app includes math problems and quizzes, timed challenges, progress tracking, to keep kids motivated.",
    ),
    FAQItem(
      question: "Is the app free to use?",
      answer:
          "All the functionality in this app is purchased at a one-time fee from the Google Play Store.",
    ),
    FAQItem(
      question: "How do I download and install the app?",
      answer:
          "This app is available on the Google Play Store. Simply search for 'QuickMath_Kids' and follow the instructions to download and install it on your device.",
    ),
    FAQItem(
      question: "Is the app safe for kids?",
      answer:
          "Yes, this app is designed with kids' safety in mind. It does not collect any personal information and does not include any ads or in-app purchases.",
    ),
    FAQItem(
      question: "Can parents track their child's progress?",
      answer:
          "This app provides the feature to share the report after finishing a quiz in the result screen. But this app does not have the ability to store past quizzes.",
    ),
    FAQItem(
      question: "What devices are supported?",
      answer:
          "This app only supports Android devices currently. It is not available for iOS or other platforms.",
    ),
    FAQItem(
      question: "How can I report bugs or suggest features?",
      answer:
          "You can report issues or suggest improvements by contacting us at master.guru.raghav@gmail.com",
    ),
    FAQItem(
      question: "Is the app available offline?",
      answer:
          "Yes, this app works completely offline. You don't need an internet connection to play the game.",
    ),
    FAQItem(
      question: "What age group is this app suitable for?",
      answer:
          "The app is likely designed for kids aged 6–12, but this may vary depending on the difficulty level of the math problems.",
    ),
    FAQItem(
      question: "What languages does the app support?",
      answer:
          "Currently, this app only supports English. Other languages will be added in future updates.",
    ),
    FAQItem(
      question: "Does the app have a dark mode?",
      answer: "Yes, you can choose the dark mode option in the drawer by clicking on the drawer button in the home screen, and the top left corner "
    ),
    FAQItem(
      question: "Can I customize the difficulty level?",
      answer:
          "Yes, you can choose the difficulty level of the math problems on the home page before starting a quiz.",
    ),
    FAQItem(
      question: "Can I share my progress with others?",
      answer:
          "Yes. Click on the share button in the result screen to share your score with friends via social media or messaging apps.",
    ),
    FAQItem(
      question: "What happens if I uninstall the app?",
      answer:
          "If the app does not support cloud syncing, your progress may be lost when you uninstall it.",
    ),
    FAQItem(
      question: "Are there any additional costs associated with using the app?",
      answer: "No, this app is free to use once downloaded.",
    ),
    FAQItem(
      question: "How can I provide feedback on the app?",
      answer:
          "You can provide feedback by rating the app on the Google Play Store or by contacting us directly.",
    ),
    FAQItem(
      question: "What types of math problems are included in the app?",
      answer:
          "The app covers various topics such as addition, subtraction, multiplication, division, and more.",
    ),
    FAQItem(
      question: "Can I access previous quizzes or scores?",
      answer:
          "No, this app does not save past quizzes or scores locally. However, you can take new quizzes to see how much you've improved over time.",
    ),
    FAQItem(
      question: "Can I earn rewards or badges for completing quizzes?",
      answer:
          "No, this app does not offer rewards or badges for completing quizzes. This functionality may be added in future updates.",
    ),
    FAQItem(
      question: "How can I contact customer support?",
      answer:
          "You can contact customer support by emailing us at master.guru.raghav@gmail.com",
    ),
  ];

  List<FAQItem> filteredFAQs = [];
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    filteredFAQs = allFAQs;
    _searchController.addListener(_filterFAQs);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _filterFAQs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredFAQs = allFAQs.where((faq) {
        return faq.question.toLowerCase().contains(query) ||
            faq.answer.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("QuickMath_Kids FAQ"),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        elevation: 4,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search FAQs...",
                prefixIcon:
                    Icon(Icons.search, color: theme.colorScheme.primary),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear, color: theme.colorScheme.primary),
                  onPressed: () {
                    _searchController.clear();
                    _filterFAQs();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      BorderSide(color: theme.colorScheme.primary, width: 2),
                ),
              ),
            ),
          ),
          Expanded(
            child: AnimatedOpacity(
              opacity: filteredFAQs.isEmpty ? 0.5 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: filteredFAQs.isEmpty
                  ? Center(
                      child: Text(
                        "No results found.",
                        style: TextStyle(
                          fontSize: 18,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: filteredFAQs.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: isDarkMode
                              ? theme.colorScheme.surfaceVariant
                              : Colors.white,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ExpansionTile(
                            title: Text(
                              filteredFAQs[index].question,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  filteredFAQs[index].answer,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToTop,
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.arrow_upward, color: Colors.white),
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}
