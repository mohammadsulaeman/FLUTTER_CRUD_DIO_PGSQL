import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_crud_dio/pages/add_pages.dart';
import 'package:flutter_crud_dio/pages/detail_pages.dart';

class MyHomePages extends StatefulWidget {
  const MyHomePages({super.key});

  @override
  State<MyHomePages> createState() => _MyHomePagesState();
}

class _MyHomePagesState extends State<MyHomePages> {
  Future<List> getAllSiswa() async {
    var dio = Dio();
    final response =
        await dio.get("http://192.168.24.108:8000/api/siswa/allSiswa");
    print(response.data['siswa_data']);
    return response.data['siswa_data'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          margin: const EdgeInsets.only(left: 10),
          child: const Text(
            'CRUD Siswa Dio Example',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: const Icon(Icons.person),
        leadingWidth: 20,
      ),
      body: FutureBuilder<List>(
        future: getAllSiswa(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                      strokeWidth: 100,
                      semanticsLabel: 'Loading',
                      semanticsValue: 'Loading',
                      backgroundColor: Colors.blueAccent,
                    ),
                  ),
                  Center(
                    child: Text('Loading......'),
                  )
                ],
              ),
            );
          }
          if (snapshot.hasData) {
            return ItemListPerson(list: snapshot.data!);
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                      strokeWidth: 100,
                      semanticsLabel: 'Loading',
                      semanticsValue: 'Loading',
                      backgroundColor: Colors.blueAccent,
                    ),
                  ),
                  Center(
                    child: Text('Loading......'),
                  )
                ],
              ),
            );
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: ((context) => const AddPages()),
            ),
          );
        },
        tooltip: "Insert",
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ItemListPerson extends StatelessWidget {
  const ItemListPerson({super.key, required this.list});

  final List list;
  @override
  Widget build(BuildContext context) {
    String urlImages = "http://192.168.24.108:8000/";
    return Scaffold(
      body: ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: ((context, index) {
          return Container(
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
                border: Border.all(
                  width: 4,
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(18)),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: ((context) =>
                        DetailPages(list: list, index: index)),
                  ),
                );
              },
              child: Card(
                child: ListTile(
                  leading: Image.network(
                    urlImages +
                        list[index]['profile']
                            .toString()
                            .replaceAll('public', 'storage'),
                    fit: BoxFit.cover,
                    width: 45,
                    height: 45,
                  ),
                  title: Text(
                    list[index]['nim'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    list[index]['nama'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
