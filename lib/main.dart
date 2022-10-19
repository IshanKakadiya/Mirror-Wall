// ignore_for_file: unused_local_variable, unused_element, prefer_is_empty

import 'dart:io';
import 'package:educational_website_app/Globle.dart';
import 'package:educational_website_app/bookmark.dart';
import 'package:educational_website_app/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      initialRoute: "Home_Page",
      routes: {
        "/": (context) => const MyApp(),
        "bookmark_page": (context) => const bookmark_page(),
        "Home_Page": (context) => const Home_Page()
      },
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

//
late InAppWebViewController inAppWebViewController;
late PullToRefreshController pullToRefreshController;

class _MyAppState extends State<MyApp> {
  double progressBar = 0;
  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(),
      onRefresh: () async {
        if (Platform.isAndroid) {
          await inAppWebViewController.reload();
        } else if (Platform.isIOS) {
          await inAppWebViewController.loadUrl(
            urlRequest: URLRequest(url: await inAppWebViewController.getUrl()),
          );
        }

        getBookMArk();
      },
    );
  }

  getBookMArk() async {
    Uri? uri = await inAppWebViewController.getUrl();

    setState(() {
      if (Globle.allBookMarkItems.isEmpty) {
        Globle.toggleBookMark = false;
      }

      for (int i = 0; i < Globle.allBookMarkItems.length; i++) {
        if (uri == Globle.allBookMarkItems[i]) {
          Globle.toggleBookMark = true;
          break;
        }
        {
          Globle.toggleBookMark = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil("Home_Page", (route) => false);
          },
        ),
        actions: [
          IconButton(
            icon: (Globle.goBack)
                ? const Icon(Icons.arrow_back_ios)
                : Container(),
            onPressed: () async {
              if (await inAppWebViewController.canGoBack()) {
                await inAppWebViewController.goBack();
              }
            },
          ),
          const SizedBox(width: 15),
          IconButton(
            icon: (Globle.goForward)
                ? const Icon(Icons.arrow_forward_ios)
                : Container(),
            onPressed: () async {
              if (await inAppWebViewController.canGoForward()) {
                await inAppWebViewController.goForward();
              }
            },
          ),
          const SizedBox(width: 15),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              if (Platform.isAndroid) {
                await inAppWebViewController.reload();
              } else if (Platform.isIOS) {
                await inAppWebViewController.loadUrl(
                  urlRequest:
                      URLRequest(url: await inAppWebViewController.getUrl()),
                );
              }

              getBookMArk();
            },
          ),
          const SizedBox(width: 15),
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () async {
              await pullToRefreshController.endRefreshing();
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          (progressBar < 1)
              ? SizedBox(
                  height: 3,
                  child: LinearProgressIndicator(
                    value: progressBar,
                    color: Colors.black,
                    backgroundColor: Colors.white,
                  ),
                )
              : Container(),
          Expanded(
            child: InAppWebView(
              onProgressChanged: (controller, progress) async {
                if (await inAppWebViewController.canGoBack()) {
                  Globle.goBack = true;
                } else {
                  Globle.goBack = false;
                }

                if (await inAppWebViewController.canGoForward()) {
                  Globle.goForward = true;
                } else {
                  Globle.goForward = false;
                }
                setState(() {
                  getBookMArk();
                  progressBar = progress / 100;
                });
              },
              initialUrlRequest: URLRequest(
                url: Uri.parse(
                    "https://${Globle.eductionSiteList[Globle.index]["website"]}"),
              ),
              onWebViewCreated: (InAppWebViewController val) {
                setState(() {
                  inAppWebViewController = val;
                });
              },
              pullToRefreshController: pullToRefreshController,
              onLoadStop: (controller, uri) async {
                await pullToRefreshController.endRefreshing();
              },
              initialOptions: InAppWebViewGroupOptions(
                android: AndroidInAppWebViewOptions(
                  useHybridComposition: true,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: null,
            child: (Globle.toggleBookMark)
                ? const Icon(Icons.bookmark)
                : const Icon(Icons.bookmark_border),
            onPressed: () async {
              Uri? uri = await inAppWebViewController.getUrl();

              setState(() {
                Globle.toggleBookMark = !Globle.toggleBookMark;

                if (Globle.toggleBookMark) {
                  Globle.allBookMarkItems.add(uri);
                } else {
                  Globle.allBookMarkItems.remove(uri);
                }
              });

              // Globle.allBookMarkItems =
              //     Globle.allBookMarkItems.toSet().toList();
            },
          ),
          const SizedBox(width: 15),
          FloatingActionButton(
            heroTag: null,
            child: Container(
              height: 100,
              width: 100,
              alignment: Alignment.center,
              child: (Globle.allBookMarkItems.isEmpty)
                  ? const Icon(
                      Icons.apps,
                    )
                  : Text(
                      "${Globle.allBookMarkItems.length}",
                      style: GoogleFonts.aBeeZee(
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed("bookmark_page");
            },
          ),
          const SizedBox(width: 15),
          FloatingActionButton(
            heroTag: null,
            child: const Icon(Icons.home),
            onPressed: () async {
              inAppWebViewController.loadUrl(
                  urlRequest: URLRequest(
                      url: Uri.parse(
                          "https://${Globle.eductionSiteList[Globle.index]["website"]}")));
            },
          ),
        ],
      ),
    );
  }
}
