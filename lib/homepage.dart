// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ott_platforms_app/Globle.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({Key? key}) : super(key: key);

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eduction Websites"),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding:
            const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 20),
        physics: const BouncingScrollPhysics(),
        itemCount: Globle.eductionSiteList.length,
        separatorBuilder: (context, i) => const SizedBox(height: 20),
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () {
              Globle.index = i;
              Navigator.of(context).pushNamed("/");
            },
            child: Container(
              height: 110,
              padding:
                  const EdgeInsets.only(left: 15, top: 5, right: 10, bottom: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white,
                  width: 0.3,
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  opacity: 0.07,
                  image: AssetImage("${Globle.eductionSiteList[i]["logo"]}"),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        width: 0.8,
                        color: Globle.eductionSiteList[i]["color"],
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image:
                            AssetImage("${Globle.eductionSiteList[i]["logo"]}"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    "${Globle.eductionSiteList[i]["name"]}",
                    style: GoogleFonts.openSans(
                      fontSize: 23,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
