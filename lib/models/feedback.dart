import 'package:meta/meta.dart';

class Feedback {
  String eventDescription;
  DateTime createdAt;

  Feedback(this.eventDescription) {
    this.createdAt = DateTime.now();
  }
}