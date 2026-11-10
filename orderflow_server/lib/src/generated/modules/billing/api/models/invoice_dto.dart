/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;

abstract class InvoiceDto
    implements _is.SerializableModel, _is.ProtocolSerialization {
  InvoiceDto._({
    required this.ledgerEntryId,
    required this.userId,
    required this.amount,
    required this.issuedAt,
  });

  factory InvoiceDto({
    required int ledgerEntryId,
    required int userId,
    required double amount,
    required DateTime issuedAt,
  }) = _InvoiceDtoImpl;

  factory InvoiceDto.fromJson(Map<String, dynamic> jsonSerialization) {
    return InvoiceDto(
      ledgerEntryId: jsonSerialization['ledgerEntryId'] as int,
      userId: jsonSerialization['userId'] as int,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      issuedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['issuedAt'],
      ),
    );
  }

  int ledgerEntryId;

  int userId;

  double amount;

  DateTime issuedAt;

  /// Returns a shallow copy of this [InvoiceDto]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  InvoiceDto copyWith({
    int? ledgerEntryId,
    int? userId,
    double? amount,
    DateTime? issuedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InvoiceDto',
      'ledgerEntryId': ledgerEntryId,
      'userId': userId,
      'amount': amount,
      'issuedAt': issuedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'InvoiceDto',
      'ledgerEntryId': ledgerEntryId,
      'userId': userId,
      'amount': amount,
      'issuedAt': issuedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _InvoiceDtoImpl extends InvoiceDto {
  _InvoiceDtoImpl({
    required int ledgerEntryId,
    required int userId,
    required double amount,
    required DateTime issuedAt,
  }) : super._(
         ledgerEntryId: ledgerEntryId,
         userId: userId,
         amount: amount,
         issuedAt: issuedAt,
       );

  /// Returns a shallow copy of this [InvoiceDto]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  InvoiceDto copyWith({
    int? ledgerEntryId,
    int? userId,
    double? amount,
    DateTime? issuedAt,
  }) {
    return InvoiceDto(
      ledgerEntryId: ledgerEntryId ?? this.ledgerEntryId,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      issuedAt: issuedAt ?? this.issuedAt,
    );
  }
}
