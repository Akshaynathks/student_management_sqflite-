import 'package:db/model.dart';
import 'package:sqflite/sqflite.dart';

late Database _db; 

Future<void>  initializeDatabase() async {
  _db = await openDatabase(
    "student.db",
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(
        "CREATE TABLE student (id INTEGER PRIMARY KEY,rollno INTEGER,name TEXT,department TEXT,phoneno INTEGER,imageurl);",
      );
    },
    
  );
}

Future<void> addStudent(StudentModel value) async {
  await _db.rawInsert(
    "INSERT INTO student (id, rollno ,name ,department ,phoneno,imageurl)values(?,?,?,?,?,?)",
    [
      value.id,
      value.rollno,
      value.name,
      value.department,
      value.phoneno,
      value.imageurl
    ],
  );
}

Future<List<Map<String, dynamic>>> getAllStudent() async {
  final _values = await _db.rawQuery("SELECT *FROM student");
  return _values;
}

Future<void> deleteStudent(int id) async {
  await _db.rawDelete('DELETE FROM student WHERE id =?', [id]);
}

Future<void> updateStudent(StudentModel updatedStudent) async {
  await _db.update(
    'student',
    {
      'rollno': updatedStudent.rollno,
      'name': updatedStudent.name,
      'department': updatedStudent.department,
      'phoneno': updatedStudent.phoneno,
      'imageurl': updatedStudent.imageurl,
    },
    where: 'id=?',
    whereArgs: [updatedStudent.id],
  );
}
