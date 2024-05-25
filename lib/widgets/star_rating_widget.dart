import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int mq9Value; // Replace with your data source
  final Color starFilledColor;
  final Color starBorderColor;

  StarRating({
    required this.mq9Value,
    this.starFilledColor = Colors.amber,
    this.starBorderColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    double rating = calculateRating(mq9Value); // Function to calculate rating

    return Row(
      children: List.generate(
          5,
              (index) => buildStar(index, rating)
      ),
    );
  }

  Widget buildStar(int index, double rating) {
    Image image;
    if (index >= rating) {
      image = Image.asset('assets/fire.png');
    } else {
      image = Image.asset('assets/fire (1).png');
    }
    Widget cont = Container(
      height: 40,
      child: image,
    );
    return cont;
  }

  double calculateRating(int mq9Value) {
    // Implement your logic to calculate rating based on MQ-9 value
    // This is an example, adjust thresholds and ratings as needed
    if (mq9Value >= 1000) {
      return 5.0;
    } else if (mq9Value >= 900) {
      return 4.5;
    } else if (mq9Value >= 800) {
      return 3.5;
    }else if (mq9Value >= 700) {
      return 3.0;
    }else if (mq9Value >= 600) {
      return 2.5;
    }else if (mq9Value >= 500) {
      return 2.0;
    }else if (mq9Value >= 400) {
      return 1.5;
    } else if (mq9Value >= 300) {
      return 1.0;
    } else if (mq9Value >= 150) {
      return 0.5;
    } else {
      return 0.0;
    }
  }
}