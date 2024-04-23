import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, this.useRouter = false});

  final bool useRouter;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text("Tab Main Screen")),
        backgroundColor: Colors.indigo,
        body: ListView(
          padding: const EdgeInsets.all(16)
              .copyWith(bottom: MediaQuery.of(context).padding.bottom),
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: TextField(
                decoration: InputDecoration(hintText: "Test Text Field"),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (useRouter) {
                    context.go("/settings/detail");
                  } else {
                    pushScreen(
                      context,
                      withNavBar: true,
                      settings: const RouteSettings(name: "/home/second-nav"),
                      screen: const MainScreen2(),
                      pageTransitionAnimation:
                          PageTransitionAnimation.scaleRotate,
                    );
                  }
                },
                child: const Text("Go to Second Screen with Navbar"),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (useRouter) {
                    context.go("/home/detail");
                  } else {
                    pushScreen(
                      context,
                      settings: const RouteSettings(name: "/home/second-no-nav"),
                      screen: const MainScreen2(),
                      pageTransitionAnimation:
                          PageTransitionAnimation.scaleRotate,
                    );
                  }
                },
                child: const Text("Go to Second Screen without Navbar"),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    useRootNavigator: true,
                    builder: (context) => Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Exit"),
                      ),
                    ),
                  );
                },
                child: const Text("Push bottom sheet on TOP of Nav Bar"),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    useRootNavigator: false,
                    builder: (context) => Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Exit"),
                      ),
                    ),
                  );
                },
                child: const Text("Push bottom sheet BEHIND the Nav Bar"),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  pushWithNavBar(
                    context,
                    DialogRoute(
                      context: context,
                      builder: (context) => const ExampleDialog(),
                    ),
                  );
                },
                child: const Text("Push Dynamic/Modal Screen"),
              ),
            ),
          ],
        ),
      );
}

class MainScreen2 extends StatelessWidget {
  const MainScreen2({super.key, this.useRouter = false});

  final bool useRouter;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text("Secondary Screen")),
        backgroundColor: Colors.teal,
        body: ListView(
          padding: const EdgeInsets.all(16)
              .copyWith(bottom: MediaQuery.of(context).padding.bottom),
          children: <Widget>[
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (useRouter) {
                    context.go("/home/detail/super-detail");
                  } else {
                    pushScreen(
                      context,
                      screen: const MainScreen3(),
                      withNavBar: true,
                    );
                  }
                },
                child: const Text("Go to Third Screen with Navbar"),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (useRouter) {
                    context.go("/detail/super-detail");
                  } else {
                    pushScreen(context, screen: const MainScreen3());
                  }
                },
                child: const Text("Go to Second Screen without Navbar"),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Go Back to First Screen"),
              ),
            ),
          ],
        ),
      );
}

class MainScreen3 extends StatelessWidget {
  const MainScreen3({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text("Tertiary Screen")),
        backgroundColor: Colors.deepOrangeAccent,
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Go Back to Second Screen"),
          ),
        ),
      );
}

class ExampleDialog extends StatelessWidget {
  const ExampleDialog({super.key});

  @override
  Widget build(BuildContext context) => Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 0.3,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          color: Colors.amber,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "This is a modal screen",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 26,
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Return"),
                ),
              ),
            ],
          ),
        ),
      );
}
