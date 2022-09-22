import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_dio/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

class AddPages extends StatefulWidget {
  const AddPages({super.key});

  @override
  State<AddPages> createState() => _AddPagesState();
}

class _AddPagesState extends State<AddPages> {
  final TextEditingController namaControllerAdd = TextEditingController();
  final TextEditingController nimControllerAdd = TextEditingController();
  final TextEditingController phoneControllerAdd = TextEditingController();
  final TextEditingController alamatControllerAdd = TextEditingController();
  final TextEditingController jurusanControllerAdd = TextEditingController();
  final TextEditingController fakultasControllerAdd = TextEditingController();
  File? imageProfile;
  ImagePicker picker = ImagePicker();
  Future getImageCamera() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        imageProfile = File(pickedFile.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Gagal Ambil Gambar'),
          duration: Duration(seconds: 4),
        ));
      }
    });
  }

  Future addSiswa(File file) async {
    String fileName = file.path.split('/').last;
    print(fileName);

    FormData data = FormData.fromMap({
      'nim': nimControllerAdd.text,
      'nama': namaControllerAdd.text,
      'alamat': alamatControllerAdd.text,
      'phone': phoneControllerAdd.text,
      'jurusan': jurusanControllerAdd.text,
      'fakultas': fakultasControllerAdd.text,
      'profile': await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });
    print("add Data = $data");
    var dio = Dio();
    var response = await dio
        .post("http://192.168.24.108:8000/api/siswa/tambah_siswa", data: data)
        .then((value) {
      print(value);
      if (value.data['status'] == "success") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: ((context) => const MyApp()),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(value.data['message']),
            duration: const Duration(seconds: 4),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(value.data['message'].toString()),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(onError.toString()),
          duration: const Duration(seconds: 4),
        ),
      );
    });
    return response;
  }

  @override
  void dispose() {
    super.dispose();
    nimControllerAdd.dispose();
    namaControllerAdd.dispose();
    alamatControllerAdd.dispose();
    phoneControllerAdd.dispose();
    jurusanControllerAdd.dispose();
    fakultasControllerAdd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Insert Data',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: Column(
                  children: [
                    imageProfile != null
                        ? ClipOval(
                            child: Image.file(
                              imageProfile!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const SizedBox(
                            width: 100, height: 100, child: Icon(Icons.person)),
                    const Text(
                      'Choose Image',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Positioned(
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.grey,
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: ((builder) => Container(
                                      height: 100,
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 20),
                                      child: Column(
                                        children: [
                                          const Text(
                                            'Ambil Photo Profile',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                onPressed: getImageCamera,
                                                child: const Text('Camera'),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: TextField(
                  controller: nimControllerAdd,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Nim Mahasiswa',
                    labelStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: 'Nim Mahasiswa',
                    hintStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.pin),
                    filled: true,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: TextField(
                  controller: namaControllerAdd,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    labelText: 'Nama Mahasiswa',
                    labelStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: 'Nama Mahasiswa',
                    hintStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                    filled: true,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: TextField(
                  controller: alamatControllerAdd,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    labelText: 'Alamat Mahasiswa',
                    labelStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: 'Alamat Mahasiswa',
                    hintStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                    filled: true,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: TextField(
                  controller: phoneControllerAdd,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Mahasiswa',
                    labelStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: 'Phone Mahasiswa',
                    hintStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone_android),
                    filled: true,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: TextField(
                  controller: jurusanControllerAdd,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    labelText: 'Jurusan Mahasiswa',
                    labelStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: 'Jurusan Mahasiswa',
                    hintStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.school),
                    filled: true,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: TextField(
                  controller: fakultasControllerAdd,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    labelText: 'Fakultas Mahasiswa',
                    labelStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: 'Fakultas Mahasiswa',
                    hintStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.school),
                    filled: true,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (imageProfile == null) {
                        Toast.show("Profile Wajib Di isi",
                            duration: Toast.lengthShort, gravity: Toast.bottom);
                      } else if (nimControllerAdd.text.isEmpty) {
                        Toast.show("Nim wajib di isi",
                            duration: Toast.lengthShort, gravity: Toast.bottom);
                      } else if (namaControllerAdd.text.isEmpty) {
                        Toast.show("Nama wajib di isi",
                            duration: Toast.lengthShort, gravity: Toast.bottom);
                      } else if (alamatControllerAdd.text.isEmpty) {
                        Toast.show("Alamat wajib di isi",
                            duration: Toast.lengthShort, gravity: Toast.bottom);
                      } else if (phoneControllerAdd.text.isEmpty) {
                        Toast.show("Nomor Telepon wajib di isi",
                            duration: Toast.lengthShort, gravity: Toast.bottom);
                      } else if (jurusanControllerAdd.text.isEmpty) {
                        Toast.show("Jurusan wajib di isi",
                            duration: Toast.lengthShort, gravity: Toast.bottom);
                      } else if (fakultasControllerAdd.text.isEmpty) {
                        Toast.show("Fakultas wajib di isi",
                            duration: Toast.lengthShort, gravity: Toast.bottom);
                      } else {
                        addSiswa(imageProfile!);
                      }
                    },
                    child: const Text('Insert Data'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
