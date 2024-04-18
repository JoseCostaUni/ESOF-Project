import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final Function(int) onMenuItemClicked;

  const CustomDrawer({super.key, required this.onMenuItemClicked});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Opção 1'),
              onTap: () {
                onMenuItemClicked(1); // Chama a função passando o índice da opção clicada
              },
            ),
            ListTile(
              title: const Text('Opção 2'),
              onTap: () {
                onMenuItemClicked(2); // Chama a função passando o índice da opção clicada
              },
            ),
            // Adicione mais ListTile para mais opções
          ],
        ),
      ),
    );
  }
}
