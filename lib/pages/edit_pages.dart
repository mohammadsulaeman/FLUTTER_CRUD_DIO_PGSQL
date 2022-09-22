import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import '../main.dart';

class EditPages extends StatefulWidget {
  const EditPages({super.key, required this.list, required this.index});
  final List list;
  final int index;
  @override
  State<EditPages> createState() => _EditPagesState();
}

class _EditPagesState extends State<EditPages> {
  final TextEditingController namaControllerEdit = TextEditingController();
  final TextEditingController nimControllerEdit = TextEditingController();
  final TextEditingController phoneControllerEdit = TextEditingController();
  final TextEditingController alamatControllerEdit = TextEditingController();
  final TextEditingController jurusanControllerEdit = TextEditingController();
  final TextEditingController fakultasControllerEdit = TextEditingController();
  File? imageProfile;
  ImagePicker picker = ImagePicker();
  String urlImages = "http://192.168.24.108:8000/";
  @override
  void initState() {
    super.initState();
    namaControllerEdit.text = widget.list[widget.index]['nama'];
    nimControllerEdit.text = widget.list[widget.index]['nim'];
    phoneControllerEdit.text = widget.list[widget.index]['phone'];
    alamatControllerEdit.text = widget.list[widget.index]['alamat'];
    jurusanControllerEdit.text = widget.list[widget.index]['jurusan'];
    fakultasControllerEdit.text = widget.list[widget.index]['fakultas'];
  }

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

  Future updateSiswa(File file) async {
    String fileName = file.path.split('/').last;
    print(fileName);

    FormData data = FormData.fromMap({
      'nim': nimControllerEdit.text,
      'nama': namaControllerEdit.text,
      'alamat': alamatControllerEdit.text,
      'phone': phoneControllerEdit.text,
      'jurusan': jurusanControllerEdit.text,
      'fakultas': fakultasControllerEdit.text,
      'profile': await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });
    print(data);
    var dio = Dio();
    var response = await dio
        .post(
            "http://192.168.24.108:8000/api/siswa/update_siswa/${widget.list[widget.index]['id']}",
            data: data)
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
    nimControllerEdit.dispose();
    namaControllerEdit.dispose();
    alamatControllerEdit.dispose();
    phoneControllerEdit.dispose();
    fakultasControllerEdit.dispose();
    jurusanControllerEdit.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Data'),
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
                        : SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.network(
                              urlImages +
                                  "${widget.list[widget.index]['profile'].toString().replaceAll('public', 'storage')}",
                            )),
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
                child: TextFormField(
                  controller: nimControllerEdit,
                  keyboardType: TextInputType.number,
                  validator: ((value) {
                    if (value == 'abcdefghijklmnopqrstuvwxyz!@#^&*()_+?><":') {
                      return 'Nim Harus Angka';
                    }
                    return null;
                  }),
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
                child: TextFormField(
                  controller: namaControllerEdit,
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
                  controller: alamatControllerEdit,
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
                  controller: phoneControllerEdit,
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
                  controller: jurusanControllerEdit,
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
                  controller: fakultasControllerEdit,
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
                      } else if (nimControllerEdit.text.isEmpty) {
                        Toast.show("Nim wajib di isi",
                            duration: Toast.lengthShort, gravity: Toast.bottom);
                      } else if (namaControllerEdit.text.isEmpty) {
                        Toast.show("Nama wajib di isi",
                            duration: Toast.lengthShort, gravity: Toast.bottom);
                      } else if (alamatControllerEdit.text.isEmpty) {
                        Toast.show("Alamat wajib di isi",
                            duration: Toast.lengthShort, gravity: Toast.bottom);
                      } else if (phoneControllerEdit.text.isEmpty) {
                        Toast.show("Nomor Telepon wajib di isi",
                            duration: Toast.lengthShort, gravity: Toast.bottom);
                      } else if (jurusanControllerEdit.text.isEmpty) {
                        Toast.show("Jurusan wajib di isi",
                            duration: Toast.lengthShort, gravity: Toast.bottom);
                      } else if (fakultasControllerEdit.text.isEmpty) {
                        Toast.show("Fakultas wajib di isi",
                            duration: Toast.lengthShort, gravity: Toast.bottom);
                      } else {
                        updateSiswa(imageProfile!);
                      }
                    },
                    child: const Text('Update Data'),
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
