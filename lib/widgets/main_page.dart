import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finki/model/list_item.dart';
import 'package:finki/widgets/calendar.dart';
import 'package:finki/widgets/nov_kolokvium.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  void _addItem(BuildContext ct) {
    showModalBottomSheet(
        context: ct,
        builder: (_) {
          return GestureDetector(
            onTap: (() {}),
            child: const NovKolokvium(),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _showCalendar(BuildContext ct, List<ListItem> kolokviumi) {
    showModalBottomSheet(
        context: ct,
        builder: (_) {
          return GestureDetector(
            onTap: (() {}),
            child: Calendar(
              kolokviumi: kolokviumi,
            ),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    List<ListItem> kolokviumi = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Колоквиуми"),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.all(10),
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _addItem(context),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: IconButton(
              icon: const Icon(Icons.calendar_month),
              onPressed: () => _showCalendar(context, kolokviumi),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => FirebaseAuth.instance.signOut(),
            ),
          ),
        ],
      ),
      body: Center(
        child: StreamBuilder<List<ListItem>>(
          stream: readExams(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Настана грешка!');
            } else if (snapshot.hasData) {
              final exams = snapshot.data!;
              final listItems = exams.map(buildExam).toList();
              kolokviumi = exams;

              if (listItems.isEmpty) {
                return const Text('Додади колоквиуми');
              }

              return ListView(
                children: listItems,
              );
            } else {
              return const Text('Додади колоквиуми');
            }
          },
        ),
      ),
    );
  }

  Stream<List<ListItem>> readExams() => FirebaseFirestore.instance
      .collection(auth.currentUser?.email ?? '')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => ListItem.fromJSON(doc.data())).toList());

  Widget buildExam(ListItem listItem) => Card(
        elevation: 4,
        margin: const EdgeInsets.all(4),
        child: ListTile(
          title: Text(listItem.naslov),
          subtitle: Text('${listItem.datum} ${listItem.vreme}'),
        ),
      );
}
