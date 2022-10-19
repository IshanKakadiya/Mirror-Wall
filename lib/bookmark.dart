// ignore_for_file: camel_case_types, unused_local_variable, use_build_context_synchronously

import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wab_view/Globle.dart';
import 'package:wab_view/main.dart';

class bookmark_page extends StatefulWidget {
  const bookmark_page({Key? key}) : super(key: key);

  @override
  State<bookmark_page> createState() => _bookmark_pageState();
}

class _bookmark_pageState extends State<bookmark_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmarks"),
        leading: Container(),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: (Globle.allBookMarkItems.isNotEmpty)
          ? Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 20),
                    Text(
                      "Total Teams - ${Globle.allBookMarkItems.length}",
                      style: GoogleFonts.rubik(
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      child: const Text(
                        "Clear All",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        setState(() {
                          Globle.toggleBookMark = false;
                          Globle.allBookMarkItems
                              .removeRange(0, Globle.allBookMarkItems.length);
                        });
                      },
                    ),
                    const SizedBox(width: 15),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.82,
                  child: ListView.separated(
                    padding: const EdgeInsets.only(right: 5, bottom: 5),
                    physics: const BouncingScrollPhysics(),
                    itemCount: Globle.allBookMarkItems.length,
                    separatorBuilder: (context, i) => const Divider(
                      color: Colors.black,
                      indent: 20,
                      endIndent: 20,
                      thickness: 0.7,
                    ),
                    itemBuilder: (context, i) => ListTile(
                      onTap: () async {
                        await inAppWebViewController.loadUrl(
                          urlRequest:
                              URLRequest(url: Globle.allBookMarkItems[i]),
                        );

                        setState(() {
                          for (int j = 0;
                              j < Globle.allBookMarkItems.length;
                              j++) {
                            if (Globle.allBookMarkItems[i] ==
                                Globle.allBookMarkItems[j]) {
                              Globle.toggleBookMark = true;
                              break;
                            } else {
                              Globle.toggleBookMark = false;
                            }
                          }
                        });

                        Navigator.of(context).pop();
                      },
                      leading: const CircleAvatar(
                        radius: 21,
                        backgroundColor: Colors.black,
                        child: CircleAvatar(
                          radius: 19,
                          backgroundColor: Colors.white,
                          child: Icon(
                            CupertinoIcons.globe,
                            color: Colors.black,
                            size: 31,
                          ),
                        ),
                      ),
                      title: SizedBox(
                        child: Text(
                          "${Globle.allBookMarkItems[i]}",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.cancel_sharp),
                        onPressed: () async {
                          setState(() {
                            Globle.allBookMarkItems
                                .remove(Globle.allBookMarkItems[i]);
                          });

                          Uri? uri = await inAppWebViewController.getUrl();

                          bool refreshPage = true;

                          for (int j = 0;
                              j < Globle.allBookMarkItems.length;
                              j++) {
                            if (uri == Globle.allBookMarkItems[j]) {
                              Globle.toggleBookMark = true;
                            } else {
                              Globle.toggleBookMark = false;
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No BookMark Yet..",
                    style: GoogleFonts.rubik(
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    color: Colors.black,
                    indent: 100,
                    endIndent: 100,
                    thickness: 1,
                  ),
                  const Icon(Icons.remove_red_eye),
                ],
              ),
            ),
    );
  }
}
