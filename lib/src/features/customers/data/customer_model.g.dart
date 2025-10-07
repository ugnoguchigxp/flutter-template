// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerImpl _$$CustomerImplFromJson(Map<String, dynamic> json) =>
    _$CustomerImpl(
      id: json['id'] as String,
      companyName: json['companyName'] as String,
      contactName: json['contactName'] as String,
      email: json['email'] as String,
      industry: json['industry'] as String,
      seats: (json['seats'] as num).toInt(),
      renewalDate: DateTime.parse(json['renewalDate'] as String),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$CustomerImplToJson(_$CustomerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'companyName': instance.companyName,
      'contactName': instance.contactName,
      'email': instance.email,
      'industry': instance.industry,
      'seats': instance.seats,
      'renewalDate': instance.renewalDate.toIso8601String(),
      'notes': instance.notes,
    };
