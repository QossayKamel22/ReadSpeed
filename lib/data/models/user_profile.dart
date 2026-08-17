import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String displayName;
  final String email;
  final int dailyGoalMinutes;
  final int dailyWpmTarget;
  final int defaultWpm;
  final bool premium;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    this.dailyGoalMinutes = 60,
    this.dailyWpmTarget = 350,
    this.defaultWpm = 320,
    this.premium = false,
    this.createdAt,
    this.updatedAt,
  });

  UserProfile copyWith({
    String? displayName,
    int? dailyGoalMinutes,
    int? dailyWpmTarget,
    int? defaultWpm,
    bool? premium,
  }) {
    return UserProfile(
      uid: uid,
      displayName: displayName ?? this.displayName,
      email: email,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      dailyWpmTarget: dailyWpmTarget ?? this.dailyWpmTarget,
      defaultWpm: defaultWpm ?? this.defaultWpm,
      premium: premium ?? this.premium,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'dailyGoalMinutes': dailyGoalMinutes,
      'dailyWpmTarget': dailyWpmTarget,
      'defaultWpm': defaultWpm,
      'premium': premium,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory UserProfile.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return UserProfile(
      uid: doc.id,
      displayName: (data['displayName'] as String?) ?? 'Reader',
      email: (data['email'] as String?) ?? '',
      dailyGoalMinutes: (data['dailyGoalMinutes'] as num?)?.toInt() ?? 60,
      dailyWpmTarget: (data['dailyWpmTarget'] as num?)?.toInt() ?? 350,
      defaultWpm: (data['defaultWpm'] as num?)?.toInt() ?? 320,
      premium: (data['premium'] as bool?) ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
}
