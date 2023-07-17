import 'dart:io';

import 'package:flutter/material.dart';
import 'package:schedule/pages/create_or_update.page.dart';
import 'package:schedule/repositories/contact.repository.dart';

import '../models/models.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ContactRepository _contactRepository = ContactRepository();
  List<Contact> _contacts = [];

  Widget _itemBuilder(BuildContext buildContext, int index) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Row(children: <Widget>[
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: _contacts[index].image.isNotEmpty
                      ? FileImage(File(_contacts[index].image)) as ImageProvider
                      : const AssetImage("assets/person.png"),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _contacts[index].name ?? "",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _contacts[index].email ?? "",
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                Text(
                  _contacts[index].phone ?? "",
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                )
              ],
            ),
          ]),
        ),
      ),
      onTap: () => _showContactPage(contact: _contacts[index]),
    );
  }

  void _showContactPage({Contact? contact}) async {
    final reqContact = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateOrUpdatePage(contact: contact),
      ),
    );

    if (reqContact != null) {
      if (contact != null) {
        reqContact.id = contact.id;
        await _contactRepository.update(reqContact.id, reqContact);
      } else {
        await _contactRepository.save(reqContact);
      }
      _getAll();
    }
  }

  void _getAll() {
    _contactRepository.getAll().then(
      (value) {
        setState(() {
          _contacts = value;
        });
        print(value);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('contatos'),
        centerTitle: true,
        actions: const [
          Icon(
            Icons.menu,
            color: Colors.white,
            size: 30,
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, index) {
          return _itemBuilder(context, index);
        },
        itemCount: _contacts.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage(contact: null);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
