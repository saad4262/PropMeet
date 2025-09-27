import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'auth_model.freezed.dart';
part 'auth_model.g.dart';

@freezed
abstract class Auth with _$Auth {
  const factory Auth({
    required String userId,
    // @Default('') String displayName,
    @Default('') String email,
    // @Default('') String avatarUrl,
    @Default('user') String tag,

    @TimestampConverter() required Timestamp createdAt,
    @TimestampConverter() required Timestamp updatedAt,
  }) = _Auth;

  factory Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);

  factory Auth.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Auth.fromJson({...data, "userId": doc.id});
  }
}

// Firestore me save karne ke liye extension:
extension AuthFirestoreX on Auth {
  Map<String, dynamic> toFirestore() => toJson();
}

class TimestampConverter implements JsonConverter<Timestamp, dynamic> {
  const TimestampConverter();

  @override
  Timestamp fromJson(dynamic json) {
    if (json is Timestamp) return json;
    if (json is Map && json.containsKey('_seconds')) {
      return Timestamp(json['_seconds'] as int, json['_nanoseconds'] as int);
    }
    if (json is String) {
      return Timestamp.fromDate(DateTime.parse(json));
    }
    throw ArgumentError('Invalid timestamp format: $json');
  }

  @override
  dynamic toJson(Timestamp timestamp) => timestamp;
}
