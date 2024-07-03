import 'package:flutter/material.dart';
import 'package:maimaid/presentation/widgets/custom_button.dart';

class SuccessPage extends StatelessWidget {
  final String title;
  final VoidCallback onUpdate;

  const SuccessPage({super.key, required this.title, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Color(0XFFFF7622),
              size: 100.0,
            ),
            const SizedBox(height: 28.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 21.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CustomButton(
                  label: "Ok",
                  onPressed: onUpdate,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
