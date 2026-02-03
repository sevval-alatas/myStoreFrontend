import 'package:flutter/material.dart';
import '../core/network/api_servis.dart';

class ProductScreen extends StatefulWidget {
  final String marketId;

  const ProductScreen({super.key, required this.marketId});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    products = await ApiService.get(
      "/products",
      query: {"marketId": widget.marketId},
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (_, i) => ListTile(title: Text(products[i]["name"])),
      ),
    );
  }
}
