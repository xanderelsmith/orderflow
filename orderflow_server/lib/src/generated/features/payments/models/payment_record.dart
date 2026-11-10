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

abstract class PaymentRecord
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  PaymentRecord._({
    this.id,
    required this.orderId,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  factory PaymentRecord({
    int? id,
    required int orderId,
    required double amount,
    required String status,
    required DateTime createdAt,
  }) = _PaymentRecordImpl;

  factory PaymentRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return PaymentRecord(
      id: jsonSerialization['id'] as int?,
      orderId: jsonSerialization['orderId'] as int,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      status: jsonSerialization['status'] as String,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = PaymentRecordTable();

  static const db = PaymentRecordRepository._();

  @override
  int? id;

  int orderId;

  double amount;

  String status;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [PaymentRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PaymentRecord copyWith({
    int? id,
    int? orderId,
    double? amount,
    String? status,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PaymentRecord',
      if (id != null) 'id': id,
      'orderId': orderId,
      'amount': amount,
      'status': status,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PaymentRecord',
      if (id != null) 'id': id,
      'orderId': orderId,
      'amount': amount,
      'status': status,
      'createdAt': createdAt.toJson(),
    };
  }

  static PaymentRecordInclude include() {
    return PaymentRecordInclude._();
  }

  static PaymentRecordIncludeList includeList({
    _is.WhereExpressionBuilder<PaymentRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PaymentRecordTable>? orderBy,
    _is.OrderByListBuilder<PaymentRecordTable>? orderByList,
    PaymentRecordInclude? include,
  }) {
    return PaymentRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PaymentRecord.t),
      orderByList: orderByList?.call(PaymentRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PaymentRecordImpl extends PaymentRecord {
  _PaymentRecordImpl({
    int? id,
    required int orderId,
    required double amount,
    required String status,
    required DateTime createdAt,
  }) : super._(
         id: id,
         orderId: orderId,
         amount: amount,
         status: status,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [PaymentRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PaymentRecord copyWith({
    Object? id = _Undefined,
    int? orderId,
    double? amount,
    String? status,
    DateTime? createdAt,
  }) {
    return PaymentRecord(
      id: id is int? ? id : this.id,
      orderId: orderId ?? this.orderId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class PaymentRecordUpdateTable extends _is.UpdateTable<PaymentRecordTable> {
  PaymentRecordUpdateTable(super.table);

  _is.ColumnValue<int, int> orderId(int value) => _is.ColumnValue(
    table.orderId,
    value,
  );

  _is.ColumnValue<double, double> amount(double value) => _is.ColumnValue(
    table.amount,
    value,
  );

  _is.ColumnValue<String, String> status(String value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class PaymentRecordTable extends _is.Table<int?> {
  PaymentRecordTable({super.tableRelation})
    : super(tableName: 'payment_records') {
    updateTable = PaymentRecordUpdateTable(this);
    orderId = _is.ColumnInt(
      'orderId',
      this,
    );
    amount = _is.ColumnDouble(
      'amount',
      this,
    );
    status = _is.ColumnString(
      'status',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final PaymentRecordUpdateTable updateTable;

  late final _is.ColumnInt orderId;

  late final _is.ColumnDouble amount;

  late final _is.ColumnString status;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    orderId,
    amount,
    status,
    createdAt,
  ];
}

class PaymentRecordInclude extends _is.IncludeObject {
  PaymentRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => PaymentRecord.t;
}

class PaymentRecordIncludeList extends _is.IncludeList {
  PaymentRecordIncludeList._({
    _is.WhereExpressionBuilder<PaymentRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PaymentRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => PaymentRecord.t;
}

class PaymentRecordRepository {
  const PaymentRecordRepository._();

  /// Returns a list of [PaymentRecord]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<PaymentRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PaymentRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PaymentRecordTable>? orderBy,
    _is.OrderByListBuilder<PaymentRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PaymentRecord>(
      where: where?.call(PaymentRecord.t),
      orderBy: orderBy?.call(PaymentRecord.t),
      orderByList: orderByList?.call(PaymentRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PaymentRecord] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<PaymentRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PaymentRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<PaymentRecordTable>? orderBy,
    _is.OrderByListBuilder<PaymentRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PaymentRecord>(
      where: where?.call(PaymentRecord.t),
      orderBy: orderBy?.call(PaymentRecord.t),
      orderByList: orderByList?.call(PaymentRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PaymentRecord] by its [id] or null if no such row exists.
  Future<PaymentRecord?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PaymentRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PaymentRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [PaymentRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PaymentRecord>> insert(
    _is.DatabaseSession session,
    List<PaymentRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PaymentRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PaymentRecord] and returns the inserted row.
  ///
  /// The returned [PaymentRecord] will have its `id` field set.
  Future<PaymentRecord> insertRow(
    _is.DatabaseSession session,
    PaymentRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PaymentRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PaymentRecord]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [PaymentRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PaymentRecord>> upsert(
    _is.DatabaseSession session,
    List<PaymentRecord> rows, {
    required _is.ColumnSelections<PaymentRecordTable> conflictColumns,
    _is.ColumnSelections<PaymentRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<PaymentRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PaymentRecord>(
      rows,
      conflictColumns: conflictColumns(PaymentRecord.t),
      updateColumns: updateColumns?.call(PaymentRecord.t),
      updateWhere: updateWhere?.call(PaymentRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PaymentRecord] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [PaymentRecord] will have its `id` field set.
  Future<PaymentRecord?> upsertRow(
    _is.DatabaseSession session,
    PaymentRecord row, {
    required _is.ColumnSelections<PaymentRecordTable> conflictColumns,
    _is.ColumnSelections<PaymentRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<PaymentRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PaymentRecord>(
      row,
      conflictColumns: conflictColumns(PaymentRecord.t),
      updateColumns: updateColumns?.call(PaymentRecord.t),
      updateWhere: updateWhere?.call(PaymentRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [PaymentRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PaymentRecord>> update(
    _is.DatabaseSession session,
    List<PaymentRecord> rows, {
    _is.ColumnSelections<PaymentRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PaymentRecord>(
      rows,
      columns: columns?.call(PaymentRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PaymentRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PaymentRecord> updateRow(
    _is.DatabaseSession session,
    PaymentRecord row, {
    _is.ColumnSelections<PaymentRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PaymentRecord>(
      row,
      columns: columns?.call(PaymentRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PaymentRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PaymentRecord?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<PaymentRecordUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PaymentRecord>(
      id,
      columnValues: columnValues(PaymentRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PaymentRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PaymentRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PaymentRecordUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<PaymentRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PaymentRecordTable>? orderBy,
    _is.OrderByListBuilder<PaymentRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PaymentRecord>(
      columnValues: columnValues(PaymentRecord.t.updateTable),
      where: where(PaymentRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PaymentRecord.t),
      orderByList: orderByList?.call(PaymentRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PaymentRecord]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PaymentRecord>> delete(
    _is.DatabaseSession session,
    List<PaymentRecord> rows, {
    _is.OrderByBuilder<PaymentRecordTable>? orderBy,
    _is.OrderByListBuilder<PaymentRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PaymentRecord>(
      rows,
      orderBy: orderBy?.call(PaymentRecord.t),
      orderByList: orderByList?.call(PaymentRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PaymentRecord].
  Future<PaymentRecord> deleteRow(
    _is.DatabaseSession session,
    PaymentRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PaymentRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PaymentRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PaymentRecordTable> where,
    _is.OrderByBuilder<PaymentRecordTable>? orderBy,
    _is.OrderByListBuilder<PaymentRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PaymentRecord>(
      where: where(PaymentRecord.t),
      orderBy: orderBy?.call(PaymentRecord.t),
      orderByList: orderByList?.call(PaymentRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PaymentRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PaymentRecord>(
      where: where?.call(PaymentRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PaymentRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PaymentRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PaymentRecord>(
      where: where(PaymentRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
