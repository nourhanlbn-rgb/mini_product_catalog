// Lifecycle answers
// -------------------------------------
// 1- When Page open for the first time
//   initState => didChangeDependencies => build
// 2- After Pressing the heart
//   build run again
// 3- leave page and go back
//  Login => Products with go =>  Products runs initState
//  didChangeDependencies => build
//  Login runs deactivate => dispose
//  Products => Details => Details runs initState =>
//  didChangeDependencies => build
//   Products doesn't run deactivate or dispose it stays alive
//   go back from Detail Details runs deactivate => dispose
// 4- When I resize the browser window
//    didChangeDependencies and then build run on every size
//    change MediaQuery.sizeOf(context) makes the page depend on
//    the screen size  so when the size changes Flutter notifies
//    the page call didChangeDependencies
//    At width 600 the page switches between ListView and GridView
// -------------------------------------------------------------------------
// 1- context.go استبدلت current stack with new route , لذلك لا يوجد زرار للرجوع
// Example: context.goNamed('products') from Login to Products.
// context.push adds the new route on top of the current one, so
//  the user can go back and we can await a result.
//  Example: context.push('/details/Laptop/23000') from Products
//  to Details.
// 2-  After logging in user should not go back to the Login
//  page so we use go and we use push because user should
//    be able to go back to Products when he go to Details and need "added to cart" result
// 3- path parameter is part of the path itself and identifies
//    the page: /details/Laptop/23000 (name = Laptop, price = 23000)
//    query parameter comes after the ? as key=value and is
//    usually optional extra data: /products?user=Guest
// -------------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:mini_product_catalog/product_widgets.dart';
import 'package:go_router/go_router.dart';

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/products',
      name: 'products',
      builder: (context, state) {
        return ProductsPage(
          username: state.uri.queryParameters['user'] ?? 'Guest',
        );
      },
    ),
    GoRoute(
      path: '/details/:name/:price',
      name: 'details',
      builder: (context, state) {
        return DetailsPage(
          name: state.pathParameters['name'] ?? '',
          price: int.tryParse(state.pathParameters['price'] ?? '') ?? 0,
        );
      },
    ),
  ],
);
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   initialRoute: '/',
    //   routes: {
    //     '/': (context) => const LoginPage(),
    //     '/products': (context) => const ProductsPage(),
    //   },
    // );
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    print("LoginPage: initState");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("LoginPage: didChangeDependencies");
  }

  @override
  void deactivate() {
    print("LoginPage: deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    print("LoginPage: dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("LoginPage: build");
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigator.pushNamed(context, '/products', arguments: "Guest");
            context.goNamed('products', queryParameters: {'user': 'Guest'});
          },
          child: const Text("Login"),
        ),
      ),
    );
  }
}

class DetailsPage extends StatefulWidget {
  final String name;
  final int price;

  const DetailsPage({super.key, required this.name, required this.price});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
    super.initState();
    print("DetailsPage: initState");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("DetailsPage: didChangeDependencies");
  }

  @override
  void deactivate() {
    print("DetailsPage: deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    print("DetailsPage: dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("DetailsPage: build");
    return Scaffold(
      appBar: AppBar(title: const Text("Details")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.name, style: const TextStyle(fontSize: 24)),
            Text("\$${widget.price}"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigator.pop(context, "${widget.name} added to cart");
                context.pop("${widget.name} added to cart");
              },
              child: const Text("Add to Cart"),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductsPage extends StatefulWidget {
  final String username;

  const ProductsPage({super.key, required this.username});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String cartMessage = "";
  int favorites = 0;
  double screenWidth = 0;

  final List<Map<String, dynamic>> products = [
    {"name": "Laptop", "price": 23000},
    {"name": "Redmi10", "price": 10000},
    {"name": "Headphones", "price": 250},
    {"name": "Mouse", "price": 250},
    {"name": "Keyboard", "price": 400},
    {"name": "Monitor", "price": 400},
  ];

  @override
  void initState() {
    super.initState();
    print("ProductsPage: initState");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.sizeOf(context);
    screenWidth = size.width;
    // final args = ModalRoute.of(context)?.settings.arguments;
    // if (args is String) username = args;
    print(
      "ProductsPage: didChangeDependencies -> width: ${size.width}, height: ${size.height}",
    );
  }

  @override
  void deactivate() {
    print("ProductsPage: deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    print("ProductsPage: dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("ProductsPage: build");
    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: Column(
        children: [
          Text("Welcome, ${widget.username}"),
          Text(cartMessage),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text("Favorites: $favorites"),
          ),
          Text("Screen width: ${screenWidth.toStringAsFixed(0)}"),
          Expanded(
            child: screenWidth < 600
                ? ProductsListView(
                    products: products,
                    onFavoritePressed: () {
                      setState(() {
                        favorites++;
                      });
                    },
                    onProductTap: (index) async {
                      // final result = await Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => DetailsPage(
                      //       name: products[index]["name"],
                      //       price: products[index]["price"],
                      //     ),
                      //   ),
                      // );
                      // if (result != null) {
                      //   setState(() {
                      //     cartMessage = result as String;
                      //   });
                      // }
                      final name = Uri.encodeComponent(products[index]["name"]);
                      final price = products[index]["price"];
                      final result = await context.push<String>(
                        '/details/$name/$price',
                      );
                      if (!mounted) return;
                      if (result != null) {
                        setState(() {
                          cartMessage = result;
                        });
                      }
                    },
                  )
                : ProductsGridView(
                    products: products,
                    onFavoritePressed: () {
                      setState(() {
                        favorites++;
                      });
                    },
                    onProductTap: (index) async {
                      // final result = await Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => DetailsPage(
                      //       name: products[index]["name"],
                      //       price: products[index]["price"],
                      //     ),
                      //   ),
                      // );
                      // if (result != null) {
                      //   setState(() {
                      //     cartMessage = result as String;
                      //   });
                      // }
                      final name = Uri.encodeComponent(products[index]["name"]);
                      final price = products[index]["price"];
                      final result = await context.push<String>(
                        '/details/$name/$price',
                      );
                      if (!mounted) return;
                      if (result != null) {
                        setState(() {
                          cartMessage = result;
                        });
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
