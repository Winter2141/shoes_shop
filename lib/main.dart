import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:currency_formatter/currency_formatter.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
void main() {
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController textEditController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchCategory();
    fetchProducts(1, "");
  }
  final List<Category> _categories = [
    // Category(1, "Converse Shoes"), 
    // Category(2, "Converse Shoes"), 
    // Category(3, "Converse Shoes"), 
    // Category(4, "Converse Shoes"), 
    // Category(5, "Converse Shoes"), 
    // Category(6, "Converse Shoes")
    ];
  late List<Product> _products = [];

  final List<String> _brands = ["https://test.mipt.me/file/brandIcon.png", 
                                "https://test.mipt.me/file/brandIcon.png", 
                                "https://test.mipt.me/file/brandIcon.png", 
                                "https://test.mipt.me/file/brandIcon.png", 
                                "https://test.mipt.me/file/brandIcon.png", 
                                "https://test.mipt.me/file/other.png"];
  String selectedValue = "";
  int selectProduct = 0;
  int selectedCategory = 1;
  String searchKeyword = "";

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: 
            Stack(
              children: [
                Scrollbar(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: [
                      Container(
                        color: Colors.white,
                        //constraints: const BoxConstraints(minWidth: 100, maxWidth: 100),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: 
                          [
                            Container(
                              height: 80,
                              color: const Color.fromRGBO(215, 132, 132, 0.68)
                            ),
                            const SizedBox(height: 68),
                            const Text(
                                  'My Products',
                                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                                ),
                            const SizedBox(height: 20),
                            currentWidth > 768 ? SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              //margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1),
                              child: getList(),
                            ) : const SizedBox(height: 0),
                            const SizedBox(height: 30),
                          ],
                        )
                      ),
                      Container(
                          color: Colors.transparent,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: 
                            [
                              currentWidth > 768 ? const SizedBox(height: 50) : const SizedBox(height: 0),
                              currentWidth > 820 ? Container(
                                color: Colors.white,
                                width: 1200,
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          "https://test.mipt.me/file/shop.png",
                                          width: 82,
                                          height: 82,
                                        ),
                                        const SizedBox(width: 38),
                                        const Text(
                                          "Adidda Sport wears",
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      spacing: 10,
                                      children: [
                                        for (String brand in _brands)
                                          Image.network(
                                            brand,
                                            width: 65,
                                            height: 65,
                                          )
                                      ],
                                        
                                    )
                                  ],
                                ),
                              ) : const SizedBox(height: 0),
                              currentWidth > 768 ? const SizedBox(height: 40) : const SizedBox(height: 20),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    GestureDetector(
                                      child: Shortcuts(
                                        shortcuts: const <ShortcutActivator, Intent>{},
                                        child: Actions(
                                          actions: const <Type, Action<Intent>>{},
                                          child: SizedBox(
                                                    width: 1200,//MediaQuery.of(context).size.width,
                                                    //margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1),
                                                    child: getProductList(),
                                                  ),
                                        )
                                      )
                                    ),
                                ],
                              )
                            ],
                          )
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 55,
                  left: (MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width > 768 ? 500 : 320)) / 2,
                  child: 
                    Container(
                      padding: currentWidth > 768 ? const EdgeInsets.symmetric(vertical: 5, horizontal: 10) : const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      width: MediaQuery.of(context).size.width > 768 ? 500 : 320,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black54,
                              blurRadius: 15.0,
                              offset: Offset(0.0, 0.75)
                          )
                        ],
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Icon(Icons.search, color: Color.fromRGBO(0, 0, 0, 0.7)),
                          Expanded(
                            child: 
                              TextField(
                                //controller: textEditController,
                                onChanged: (keyword){onSearch(keyword);},
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(borderSide: BorderSide.none),
                                  hintText: 'Search for a product',
                                ),
                              ),
                          ),
                          const Text('|', style: TextStyle(fontSize: 20)),
                          // Container(
                          //   padding: const EdgeInsets.symmetric(horizontal: 15),
                          //   child: const Text("category"),
                          // ),
                          const SizedBox(width: 10),
                          DropdownButton(
                            items: [
                              for(Category category in _categories)
                                DropdownMenuItem(value: category.id,child: Text(category.name))
                            ],
                            underline: const SizedBox(width: 0,height: 0,),
                            value: selectedCategory,
                            onChanged: (value) {dropDownCallBack(value);}
                          ),
                          //const Icon(Icons.arrow_drop_down, color: Color.fromRGBO(0, 0, 0, 0.7)),
                        ],
                      ),
                    ),
                ),
              ],
            ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void dropDownCallBack(int? selectedValue) {
    if(selectedValue != null) {
      setState(() {
        selectedCategory = selectedValue;
      });
      fetchProducts(selectedValue, searchKeyword);
    }
  }

  void onCategoryChanged(String? selectedValue) {

  }

  void onSearch(String keyword) {
    setState(() {
      searchKeyword = keyword;
    });
    fetchProducts(selectedCategory, keyword);
  }

  Widget getList() {
    return Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runSpacing: 10,
              children: [
                for (Category category in _categories)
                TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 20, horizontal: 30)),
                      shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                )
                              ),
                      side: MaterialStateProperty.all(const BorderSide(color: Colors.black))
                    ),
                    onPressed: () {
                      setState(() {
                        selectedCategory = category.id;
                      });
                      fetchProducts(category.id, searchKeyword);
                    },
                    child: Text(
                      category.name,
                      style: const TextStyle(fontSize: 15),
                    ),
                  )
                  // Container(
                  //   padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  //   margin: const EdgeInsets.only(top: 20),
                  //   decoration: BoxDecoration(
                  //     border: Border.all(color: Colors.black),
                  //     borderRadius: const BorderRadius.all(Radius.circular(30))
                  //   ),
                  //   child: category.name != Null ? Text(
                  //     category.name,
                  //     style: const TextStyle(fontSize: 15),
                  //   ) : const Text(
                  //     'Converse Shoes',
                  //     style: TextStyle(fontSize: 15),
                  //   ),
                  // )
              ]
            );
  }

  Widget getProductList() {
    return Wrap(
              alignment: MediaQuery.of(context).size.width > 1200 ? WrapAlignment.start : WrapAlignment.center,
              runSpacing: 20,
              spacing: MediaQuery.of(context).size.width > 768 ? 0 : 10,
              children: [
                for (Product product in _products)
                  Focus(
                    child: MouseRegion(
                      onEnter: (PointerEnterEvent event) => onEnter(product.id),
                      onExit: (PointerExitEvent event) => onExit(product.id),
                      child: Transform.scale(
                        scale: selectProduct == product.id ? 1.2 : 1,
                        origin: Offset.zero,
                        child: Container(
                                width: MediaQuery.of(context).size.width > 768 ? 300 : 150,
                                margin: const EdgeInsets.only(top: 20),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(0),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                      ),
                                      child: Image.network(
                                        "https://test.mipt.me/file/product.png",
                                        width: 260,
                                      ),
                                    ),
                                    Container(
                                      width: 260,
                                      padding: const EdgeInsets.only(top: 20, bottom: 30, left: 20),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))
                                      ),
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        textDirection: TextDirection.ltr,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 260,
                                            child:
                                              Text(
                                                product.name,
                                                style: TextStyle(fontSize: MediaQuery.of(context).size.width > 768 ? 20 : 13, fontWeight: FontWeight.bold),
                                              ),
                                          ),
                                          const SizedBox(height: 20),
                                          SizedBox(
                                            width: 260,
                                            child:
                                              Text(
                                                CurrencyFormatter.format(product.price, CurrencyFormatterSettings.usd),
                                                style: TextStyle(fontSize: MediaQuery.of(context).size.width > 768 ? 15 : 10, fontWeight: FontWeight.bold),
                                              ),
                                          ),
                                          selectProduct == product.id ? const SizedBox(height: 20) : const SizedBox(height: 5),
                                          selectProduct == product.id ? TextButton(
                                            onPressed: () => {},
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(215, 132, 132, 0.68)),
                                              padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
                                            ),
                                            child: const Text(
                                              "Add to Cart",
                                              style: TextStyle(fontSize: 15, color: Colors.white),
                                            ),
                                          ) : const SizedBox(height: 0),
                                        ],
                                      )
                                    )
                                  ],
                                ),
                              ),
                      )
                    )
                  )
              ]
            );
  }

  String getName() {
    return "";
  }

  void onEnter(int productId) {
    setState(() {
      selectProduct = productId;
    });
  }
  void onExit(int productId) {
    setState(() {
      selectProduct = 0;
    });
  }

  void fetchCategory() async {
    final response = await http
        .get(Uri.parse('https://test.mipt.me/categories'));

    setState(() {
      _categories.clear();
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //return Category.fromJson(jsonDecode(response.body));
      for (var i = 0; i < jsonDecode(response.body).length; i++) {
        setState(() {
          _categories.add(Category(jsonDecode(response.body)[i]['id'], jsonDecode(response.body)[i]['name']));
        });
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Category');
    }
  }  
  void fetchProducts(int categoryId, String keyword) async {
    final response = await http
        .post(
          Uri.parse('https://test.mipt.me/products'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'categoryId': categoryId.toString(),
            'keyword': keyword
          }),
        );

    setState(() {
      _products.clear();
    });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //return Category.fromJson(jsonDecode(response.body));
      for (var i = 0; i < jsonDecode(response.body).length; i++) {
        setState(() {
          _products.add(Product(
            jsonDecode(response.body)[i]['id'],
            jsonDecode(response.body)[i]['categoryId'], 
            jsonDecode(response.body)[i]['name'], 
            jsonDecode(response.body)[i]['media'], 
            jsonDecode(response.body)[i]['price']
          ));
        });
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Category');
    }
  }
}

class Category {
  int id = 0;
  String name = "";

  Category(this.id, this.name);

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      json['id'],json['name'],
    );
  }
}


class Product {
  int id = 1;
  int categoryId = 1;
  String name = "Adidas Converse";
  String media = "https://imagizer.imageshack.com/img923/7559/FHvGFc.png";
  int price = 1200;

  Product(this.id, this.categoryId, this.name, this.media, this.price);

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      json['id'],json['categoryId'],json['name'],json['media'],json['price']
    );
  }
}