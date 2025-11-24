import 'package:flutter/material.dart';

class AssetsHome extends StatelessWidget {
	const AssetsHome({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Home (screen/assets/home.dart)'),
			),
			body: const Center(
				child: Text('Bienvenue sur la page Home !'),
			),
		);
	}
}
