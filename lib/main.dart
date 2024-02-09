import 'package:flutter/material.dart';
import 'package:babylonjs_viewer/babylonjs_viewer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_selector/file_selector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? _filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("3D GLB File Viewer"),
      ),
      drawer: buildDrawer(context),
      body: BabylonJSViewer(
        src: _filePath ?? 'assets/frog.glb',
      ),
    );
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Text(
                'Support only GLB file',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.remove_red_eye, color: Colors.white),
              title: Text('View 3D / Reload Model',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.file_upload, color: Colors.white),
              title: Text('View Your 3D File',
                  style: TextStyle(color: Colors.white)),
              onTap: () async {
                print("View Your 3D File button tapped.");
                await pickAndSetFile(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.white),
              title: Text('About', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AboutPage(drawer: buildDrawer(context)),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickAndSetFile(BuildContext context) async {
    if (await _requestStoragePermission()) {
      const typeGroup = XTypeGroup(
        label: 'GLB Files',
        extensions: ['glb'],
      );
      print("Opening file picker...");
      final file = await openFile(acceptedTypeGroups: [typeGroup]);
      if (file != null) {
        String filePath = file.path;
        print("Selected file path: $filePath");
        setState(() {
          _filePath = filePath;
        });
        print("File path set in state. Closing the drawer.");
        Navigator.pop(context);
      } else {
        print("No file selected.");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Storage permission need to be enable in your device setting'),
        ),
      );
    }
  }

  Future<bool> _requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      var result = await Permission.storage.request();
      return result.isGranted;
    }
    return true;
  }
}

class AboutPage extends StatelessWidget {
  final Drawer drawer;

  const AboutPage({Key? key, required this.drawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      drawer: drawer,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'This is a Flutter 3D viewer project that supports GLB files '
                'using babylonjs_viewer and FileSelector.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
