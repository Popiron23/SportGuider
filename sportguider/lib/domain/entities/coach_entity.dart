import 'package:sportguider/domain/entities/account_entity.dart';

class CoachEntity extends AccountEntity {
  final String sport;
  final String? description;


  CoachEntity({required this.sport,this.description,required super.id,super.name,super.email,super.phoneNumber,super.role});
}
