// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Globle {
  static List allBookMarkItems = [];
  static int index = 0;
  static bool toggleBookMark = false;
  static bool goBack = true;
  static bool goForward = true;

  static List eductionSiteList = [
    {
      "name": "W3schools",
      "logo": "image/w3school.jpg",
      "website": "www.w3schools.com",
      "color": Colors.green,
    },
    {
      "name": "Wikipedia",
      "logo": "image/Wikipedia.png",
      "website": "www.wikipedia.org",
      "color": Colors.transparent,
    },
    {
      "name": "Javatpoint",
      "logo": "image/javapoint.png",
      "website": "www.javatpoint.com",
      "color": Colors.redAccent,
    },
    {
      "name": "Tutorialspoint",
      "logo": "image/tutorialspoint.jpg",
      "website": "www.tutorialspoint.com",
      "color": Colors.teal,
    },
    {
      "name": "Stackoverflow",
      "logo": "image/stack-overflow.png",
      "website": "stackoverflow.com",
      "color": Colors.white,
    },
  ];
}
