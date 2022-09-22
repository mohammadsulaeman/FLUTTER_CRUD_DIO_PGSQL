import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_dio/main.dart';
import 'package:flutter_crud_dio/pages/edit_pages.dart';

class DetailPages extends StatefulWidget {
  const DetailPages({super.key, required this.list, required this.index});
  final List list;
  final int index;
  @override
  State<DetailPages> createState() => _DetailPagesState();
}

class _DetailPagesState extends State<DetailPages> {
  String urlImages = "http://192.168.24.108:8000/";
  Future deleteData() async {
    var dio = Dio();
    print(widget.list[widget.index]['id']);
    var response = await dio
        .delete(
            'http://192.168.24.108:8000/api/siswa/delete_siswa/${widget.list[widget.index]['id']}')
        .then((value) {
      print(value);
      if (value.data['status'] == "success") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: ((context) => const MyApp()),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value.data['message']),
          duration: const Duration(seconds: 4),
        ));
      }
    }).catchError((onError) {
      print(onError);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(onError.toString()),
        duration: const Duration(seconds: 4),
      ));
    });

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail ${widget.list[widget.index]['nama']}",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  urlImages +
                      "${widget.list[widget.index]['profile'].toString().replaceAll('public', 'storage')}",
                  filterQuality: FilterQuality.medium,
                  fit: BoxFit.cover,
                  width: 80,
                  height: 80,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5, right: 10),
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: const Icon(
                          Icons.phone_android_outlined,
                          size: 25,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5, right: 5),
                        child: Text(
                          widget.list[widget.index]['phone'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: const Icon(
                          Icons.location_on_outlined,
                          size: 25,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Text(
                          widget.list[widget.index]['alamat'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Text(
                    "Nim  : ${widget.list[widget.index]['nim']}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Text(
                    "Nama : ${widget.list[widget.index]['nama']}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Text(
                    "Jurusan : ${widget.list[widget.index]['jurusan']}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Text(
                    "Fakultas : ${widget.list[widget.index]['fakultas']}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green)),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: ((context) => EditPages(
                              list: widget.list, index: widget.index)),
                        ),
                      );
                    },
                    child: const Text('Update')),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red)),
                    onPressed: () {
                      deleteData();
                    },
                    child: const Text('Delete')),
              )
            ],
          ),
        ],
      ),
    );
  }
}
