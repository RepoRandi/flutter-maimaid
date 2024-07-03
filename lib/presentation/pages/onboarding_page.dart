import 'package:flutter/material.dart';
import 'dart:async';

import 'package:maimaid/presentation/widgets/custom_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  final List<Map<String, String>> _onboardingData = [
    {
      "image": "assets/image1.jpg",
      "title": "Title 1",
      "description": "Description 1"
    },
    {
      "image": "assets/image2.jpg",
      "title": "Title 2",
      "description": "Description 2"
    },
    {
      "image": "assets/image3.jpg",
      "title": "Title 3",
      "description": "Description 3"
    },
    {
      "image": "assets/image4.jpg",
      "title": "Title 4",
      "description": "Description 4"
    },
  ];

  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < _onboardingData.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Padding(
              padding: const EdgeInsets.only(left: 60, top: 114, right: 60),
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 240,
                        height: 292,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          image: DecorationImage(
                            image: AssetImage(_onboardingData[index]['image']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 63),
                      Text(
                        _onboardingData[index]['title']!,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Color(0XFF32343E)),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        _onboardingData[index]['description']!,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0XFF646982)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 32.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _onboardingData.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? Colors.orange
                      : Colors.orange.withOpacity(.2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 70),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CustomButton(
                label: _currentPage == _onboardingData.length - 1
                    ? "Get Started"
                    : "Next",
                onPressed: () {
                  if (_currentPage < _onboardingData.length - 1) {
                    _currentPage++;
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  } else {
                    _currentPage = 0;
                    _pageController.animateToPage(
                      _currentPage,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                    Navigator.pushReplacementNamed(context, '/user_list');
                  }
                },
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/user_list');
            },
            child: const Text(
              "Skip",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0XFF646982)),
            ),
          ),
        ],
      ),
    );
  }
}
