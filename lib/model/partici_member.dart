class PartiMember {
  final int userId;
  final String email;

  PartiMember({required this.userId, required this.email});

  factory PartiMember.fromJson(Map<dynamic, dynamic>json){
    return PartiMember(userId: json['userId'], email: json['email']);
  }
}
