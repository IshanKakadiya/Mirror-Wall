// ignore_for_file: unused_local_variable, unused_element, prefer_is_empty

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wab_view/Globle.dart';
import 'package:wab_view/bookmark.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => const MyApp(),
        "bookmark_page": (context) => const bookmark_page(),
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
  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
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

  double progressBar = 0;

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Web-Browser"),
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
                  height: 5,
                  child: LinearProgressIndicator(
                    value: progressBar,
                    color: Colors.blue,
                    backgroundColor: Colors.white,
                  ),
                )
              : const SizedBox(),
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
                  progressBar = progress / 100;

                  getBookMArk();
                });
              },
              initialUrlRequest: URLRequest(
                url: Uri.parse("https://www.google.com"),
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
            child: const Icon(Icons.search),
            onPressed: () async {
              searchController.clear();

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: const Center(child: Text("Serach")),
                    content: TextFormField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        label: Text("Search"),
                        hintText: "Search Here ..",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        child: const Text("Search"),
                        onPressed: () {
                          Navigator.of(context).pop();

                          inAppWebViewController.loadUrl(
                            urlRequest: URLRequest(
                              url: Uri.parse(
                                  "https://www.google.com/search?q=${searchController.text}"),
                            ),
                          );
                        },
                      ),
                      OutlinedButton(
                        child: const Text("Calcel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(width: 15),
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
                        color: Colors.white,
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
                  url: Uri.parse("https://www.google.com"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
