import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finki/model/list_item.dart';
import 'package:finki/services/local_notifications_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nanoid/nanoid.dart';

class NovKolokvium extends StatefulWidget {
  const NovKolokvium({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NovKolokvium();
}

class _NovKolokvium extends State<NovKolokvium> {
  final _naslovController = TextEditingController();
  final _datumController = TextEditingController();
  final _vremeController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  late final LocalNotificationService service;

  @override
  void initState() {
    service = LocalNotificationService();
    service.initialize();
    super.initState();
  }

  Future<void> _submittedData() async {
    if (_naslovController.text.isEmpty) return;

    final String naslov = _naslovController.text;
    final String datum = _datumController.text;
    final String vreme = _vremeController.text;

    if (naslov.isEmpty || datum.isEmpty || vreme.isEmpty) return;

    final ListItem newItem =
        ListItem(id: nanoid(5), naslov: naslov, datum: datum, vreme: vreme);

    addItemToDB(listItem: newItem);

    service.showNotification(
        id: 0,
        title: 'Додаден нов колоквиум',
        body: '$naslov на $datum во $vreme',
    );

    Navigator.pop(context);
  }

  Future addItemToDB({required ListItem listItem}) async {
    final email = auth.currentUser?.email ?? '';
    final db = FirebaseFirestore.instance.collection(email).doc();
    final json = listItem.toJSON();

    await db.set(json);
  }

  @override
  void dispose() {
    _naslovController.dispose();
    _datumController.dispose();
    _vremeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          TextField(
            controller: _naslovController,
            decoration: const InputDecoration(labelText: "Предмет"),
            onSubmitted: (_) => _submittedData(),
          ),
          TextField(
            readOnly: true,
            controller: _datumController,
            decoration: const InputDecoration(hintText: 'Датум'),
            onTap: () async {
              var date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100));
              _datumController.text = date.toString().substring(0, 10);
            },
            onSubmitted: (_) => _submittedData(),
          ),
          TextField(
            readOnly: true,
            controller: _vremeController,
            decoration: const InputDecoration(hintText: 'Време'),
            onTap: () async {
              var vreme = await showTimePicker(
                initialTime: TimeOfDay.now(),
                context: context, //context of current state
              );
              _vremeController.text = vreme.toString().substring(10, 15);
            },
            onSubmitted: (_) => _submittedData(),
          ),
          TextButton(onPressed: _submittedData, child: const Text("Додади")),
        ],
      ),
    );
  }
}
