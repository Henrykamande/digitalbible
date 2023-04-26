// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'Digital Bible'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Application>>? _appsFuture;

  @override
  void initState() {
    super.initState();
    _appsFuture = getApplications();
  }

  Future<List<Application>> getApplications() async {
    return await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      onlyAppsWithLaunchIntent: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: FutureBuilder<List<Application>>(
        future: _appsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Application> apps = snapshot.data!;
            apps.sort((a, b) => a.appName.compareTo(b.appName));
            return ListView.builder(
              itemCount: apps.length,
              itemBuilder: (BuildContext context, int index) {
                final app = apps[index];
                return GestureDetector(
                  onTap: () async {
                    print("category: ${app.category}");
                    await debounce(() async {
                      bool isInstalled =
                          await DeviceApps.isAppInstalled(app.appName);
                      DeviceApps.openApp(app.packageName);
                    });
                  },
                  child: ListTile(
                    leading: app is ApplicationWithIcon
                        ? CircleAvatar(
                            backgroundImage: MemoryImage(
                              app.icon,
                            ),
                          )
                        : null,
                    title: Text(
                      app.appName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading apps'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<void> debounce(FutureOr<void> Function() callback) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    callback();
  }

/* // ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //DefaultAssetBundle.of(context).load('');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'Digital Bible'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Application>>? _appsFuture;

  @override
  void initState() {
    super.initState();
    _appsFuture = getApplications();
  }

  Future<List<Application>> getApplications() async {
    return await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      onlyAppsWithLaunchIntent: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: FutureBuilder<List<Application>>(
        future: _appsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Application> apps = snapshot.data!;
            apps.sort((a, b) => a.appName.compareTo(b.appName));

            // return ListView.builder(
            //   itemCount: apps.length,
            //   itemBuilder: (context, index) => GestureDetector(
            //     onTap: () async {
            //       print(apps[index]);

            //       print("category: ${apps[index].category}");
            //       bool isInstalled =
            //           await DeviceApps.isAppInstalled(apps[index].appName);
            //       DeviceApps.openApp(apps[index].packageName);
            //     },
            //     child: ListTile(
            //       // leading: apps[index] is ApplicationWithIcon
            //       //     ? CircleAvatar(
            //       //         backgroundImage: MemoryImage(
            //       //           apps[index].,
            //       //         ),
            //       //       )
            //       //     : null,
            //       title: Text(apps[index].appName),
            //     ),
            //   ),
            // );

            return Column(
              children: [
                // output the list of apps
                ...apps
                    .map(
                      (app) => GestureDetector(
                        onTap: () async {
                          print("category: ${app.category}");
                          bool isInstalled =
                              await DeviceApps.isAppInstalled(app.appName);
                          DeviceApps.openApp(app.packageName);
                        },
                        child: ListTile(
                          leading: app is ApplicationWithIcon
                              ? CircleAvatar(
                                  backgroundImage: MemoryImage(
                                    app.icon,
                                  ),
                                )
                              : null,
                          title: Text(app.appName),
                        ),
                      ),
                    )
                    .toList(),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading apps'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
 */
}
