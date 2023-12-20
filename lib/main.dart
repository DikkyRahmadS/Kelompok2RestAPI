import 'package:flutter/material.dart';
import 'package:rest_api/model/model.dart';
import 'package:rest_api/identitas/repository.dart';
import 'package:rest_api/model/model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Tutorial',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(
          title: 'KELOMPOK 2 [API https://reqres.in/api/unknown]'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int blogCount;
  late List listBlog;
  Repository repository = Repository();

  Future getData() async {
    listBlog = [];
    listBlog = await repository.getData();
    setState(() {
      blogCount = listBlog.length;
      listBlog = listBlog;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  // Membuat fungsi untuk menampilkan warna
  Color hexToColor(String hexString) {
    return Color(int.parse(hexString.substring(1, 7), radix: 16) + 0xFF000000);
  }

  // Membuat fungsi untuk updatedata Blog
  Future<void> editBlog(int index) async {
    // Tampilkan dialog pengeditan
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController();
        TextEditingController yearController = TextEditingController();
        TextEditingController colorCodeController = TextEditingController();
        TextEditingController pantoneValueController = TextEditingController();

        // Inisialisasi controller dengan nilai saat ini
        nameController.text = listBlog[index].name;
        yearController.text = listBlog[index].year.toString();
        colorCodeController.text = listBlog[index].color;
        pantoneValueController.text = listBlog[index].pantone_value.toString();

        return AlertDialog(
          title: Text('Edit Blog'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: yearController,
                decoration: InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: colorCodeController,
                decoration: InputDecoration(labelText: 'Color Code'),
              ),
              TextField(
                controller: pantoneValueController,
                decoration: InputDecoration(labelText: 'Pantone Value'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Tutup dialog popupc tanpa menyimpan perubahan
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Simpan perubahan
                listBlog[index].name = nameController.text;
                listBlog[index].year = int.parse(yearController.text);
                listBlog[index].color = colorCodeController.text;
                listBlog[index].pantone_value = pantoneValueController.text;

                // Perbarui tampilan
                setState(() {});
                Navigator.of(context)
                    .pop(); // Tutup dialog popups setelah menyimpan perubahan
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Membuat fungsi deletedata Blog
  void deleteBlog(int index) {
    // Implementasi logika untuk menghapus data di sini
    listBlog.removeAt(index);
    setState(() {});
  }

  // Membuat fungsi createdata Blog
  Future<void> showAddDialog() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController yearController = TextEditingController();
    TextEditingController colorCodeController = TextEditingController();
    TextEditingController pantoneValueController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Blog'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: yearController,
                decoration: InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: colorCodeController,
                decoration: InputDecoration(labelText: 'Color Code'),
              ),
              TextField(
                controller: pantoneValueController,
                decoration: InputDecoration(labelText: 'Pantone Value'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Tutup dialog tanpa menyimpan perubahan
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    yearController.text.isNotEmpty) {
                  // Buat objek Blog baru
                  Blog newColorModel = Blog(
                    id: listBlog.length + 1,
                    name: nameController.text,
                    year: int.parse(yearController.text),
                    color: colorCodeController.text,
                    pantone_value: pantoneValueController.text,
                  );

                  // Simpan data baru
                  listBlog.add(newColorModel);

                  // Perbarui tampilan
                  setState(() {});

                  Navigator.of(context)
                      .pop(); // Tutup dialog setelah menyimpan perubahan
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Semua data harus diisi.'),
                    ),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: blogCount == 0
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Year')),
                    DataColumn(label: Text('Color Code')),
                    DataColumn(label: Text('Pantone Value')),
                    DataColumn(label: Text('Color')),
                    DataColumn(label: Text('Edit')), // kolomupdate untuk edit
                    DataColumn(label: Text('Delete')), // kolomdelete untuk hapus
                  ],
                  rows: List.generate(
                    listBlog.length,
                    (index) => DataRow(
                      cells: [
                        DataCell(Text('${listBlog[index].id}')),
                        DataCell(Text('${listBlog[index].name}')),
                        DataCell(Text('${listBlog[index].year}')),
                        DataCell(Text('${listBlog[index].color}')),
                        DataCell(Text('${listBlog[index].pantone_value}')),
                        DataCell(Container(
                          // Kolom warna
                          width: 50,
                          height: 20,
                          color: hexToColor(listBlog[index].color),
                        )),
                        DataCell(
                          // Kolom action
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => editBlog(index),
                          ),
                        ),
                        DataCell(
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => deleteBlog(index),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showAddDialog(),
          tooltip: 'Add Blog',
          child: Icon(Icons.add),
        ));
  }
}
