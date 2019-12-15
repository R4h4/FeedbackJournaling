// models/feedback.dart

import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Feedback {
  String id;
  String eventDescription;
  DateTime createdAt;

  Feedback(this.eventDescription) {
    this.id = uuid.v4();
    this.createdAt = DateTime.now();
  }
}


class User {

}