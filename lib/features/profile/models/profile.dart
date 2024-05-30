import 'package:data_class_macro/data_class_macro.dart';
import 'package:json/json.dart';

@Data()
@JsonCodable()
class Profile {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;
  final String image;

  String get fullName => '$firstName $lastName';
}
