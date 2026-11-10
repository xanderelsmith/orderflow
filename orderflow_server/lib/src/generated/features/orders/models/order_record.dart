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

abstract class OrderRecord
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  OrderRecord._({
    this.id,
    required this.userId,
    required this.itemCount,
    required this.totalPrice,
  });

  factory OrderRecord({
    int? id,
    required String userId,
    required int itemCount,
    required double totalPrice,
  }) = _OrderRecordImpl;

  factory OrderRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return OrderRecord(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      itemCount: jsonSerialization['itemCount'] as int,
      totalPrice: (jsonSerialization['totalPrice'] as num).toDouble(),
    );
  }

  static final t = OrderRecordTable();

  static const db = OrderRecordRepository._();

  @override
  int? id;

  String userId;

  int itemCount;

  double totalPrice;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [OrderRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  OrderRecord copyWith({
    int? id,
    String? userId,
    int? itemCount,
    double? totalPrice,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrderRecord',
      if (id != null) 'id': id,
      'userId': userId,
      'itemCount': itemCount,
      'totalPrice': totalPrice,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OrderRecord',
      if (id != null) 'id': id,
      'userId': userId,
      'itemCount': itemCount,
      'totalPrice': totalPrice,
    };
  }

  static OrderRecordInclude include() {
    return OrderRecordInclude._();
  }

  static OrderRecordIncludeList includeList({
    _is.WhereExpressionBuilder<OrderRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OrderRecordTable>? orderBy,
    _is.OrderByListBuilder<OrderRecordTable>? orderByList,
    OrderRecordInclude? include,
  }) {
    return OrderRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OrderRecord.t),
      orderByList: orderByList?.call(OrderRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrderRecordImpl extends OrderRecord {
  _OrderRecordImpl({
    int? id,
    required String userId,
    required int itemCount,
    required double totalPrice,
  }) : super._(
         id: id,
         userId: userId,
         itemCount: itemCount,
         totalPrice: totalPrice,
       );

  /// Returns a shallow copy of this [OrderRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  OrderRecord copyWith({
    Object? id = _Undefined,
    String? userId,
    int? itemCount,
    double? totalPrice,
  }) {
    return OrderRecord(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      itemCount: itemCount ?? this.itemCount,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}

class OrderRecordUpdateTable extends _is.UpdateTable<OrderRecordTable> {
  OrderRecordUpdateTable(super.table);

  _is.ColumnValue<String, String> userId(String value) => _is.ColumnValue(
    table.userId,
    value,
  );

  _is.ColumnValue<int, int> itemCount(int value) => _is.ColumnValue(
    table.itemCount,
    value,
  );

  _is.ColumnValue<double, double> totalPrice(double value) => _is.ColumnValue(
    table.totalPrice,
    value,
  );
}

class OrderRecordTable extends _is.Table<int?> {
  OrderRecordTable({super.tableRelation}) : super(tableName: 'order_records') {
    updateTable = OrderRecordUpdateTable(this);
    userId = _is.ColumnString(
      'userId',
      this,
    );
    itemCount = _is.ColumnInt(
      'itemCount',
      this,
    );
    totalPrice = _is.ColumnDouble(
      'totalPrice',
      this,
    );
  }

  late final OrderRecordUpdateTable updateTable;

  late final _is.ColumnString userId;

  late final _is.ColumnInt itemCount;

  late final _is.ColumnDouble totalPrice;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    itemCount,
    totalPrice,
  ];
}

class OrderRecordInclude extends _is.IncludeObject {
  OrderRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => OrderRecord.t;
}

class OrderRecordIncludeList extends _is.IncludeList {
  OrderRecordIncludeList._({
    _is.WhereExpressionBuilder<OrderRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(OrderRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => OrderRecord.t;
}

class OrderRecordRepository {
  const OrderRecordRepository._();

  /// Returns a list of [OrderRecord]s matching the given query parameters.
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
  Future<List<OrderRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<OrderRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OrderRecordTable>? orderBy,
    _is.OrderByListBuilder<OrderRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<OrderRecord>(
      where: where?.call(OrderRecord.t),
      orderBy: orderBy?.call(OrderRecord.t),
      orderByList: orderByList?.call(OrderRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [OrderRecord] matching the given query parameters.
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
  Future<OrderRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<OrderRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<OrderRecordTable>? orderBy,
    _is.OrderByListBuilder<OrderRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<OrderRecord>(
      where: where?.call(OrderRecord.t),
      orderBy: orderBy?.call(OrderRecord.t),
      orderByList: orderByList?.call(OrderRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [OrderRecord] by its [id] or null if no such row exists.
  Future<OrderRecord?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<OrderRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [OrderRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [OrderRecord]s will have their `id` fields set.
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
  Future<List<OrderRecord>> insert(
    _is.DatabaseSession session,
    List<OrderRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<OrderRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [OrderRecord] and returns the inserted row.
  ///
  /// The returned [OrderRecord] will have its `id` field set.
  Future<OrderRecord> insertRow(
    _is.DatabaseSession session,
    OrderRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<OrderRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [OrderRecord]s in the list and returns the resulting rows.
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
  /// The returned [OrderRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<OrderRecord>> upsert(
    _is.DatabaseSession session,
    List<OrderRecord> rows, {
    required _is.ColumnSelections<OrderRecordTable> conflictColumns,
    _is.ColumnSelections<OrderRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<OrderRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<OrderRecord>(
      rows,
      conflictColumns: conflictColumns(OrderRecord.t),
      updateColumns: updateColumns?.call(OrderRecord.t),
      updateWhere: updateWhere?.call(OrderRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [OrderRecord] and returns the resulting row.
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
  /// The returned [OrderRecord] will have its `id` field set.
  Future<OrderRecord?> upsertRow(
    _is.DatabaseSession session,
    OrderRecord row, {
    required _is.ColumnSelections<OrderRecordTable> conflictColumns,
    _is.ColumnSelections<OrderRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<OrderRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<OrderRecord>(
      row,
      conflictColumns: conflictColumns(OrderRecord.t),
      updateColumns: updateColumns?.call(OrderRecord.t),
      updateWhere: updateWhere?.call(OrderRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [OrderRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<OrderRecord>> update(
    _is.DatabaseSession session,
    List<OrderRecord> rows, {
    _is.ColumnSelections<OrderRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<OrderRecord>(
      rows,
      columns: columns?.call(OrderRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [OrderRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<OrderRecord> updateRow(
    _is.DatabaseSession session,
    OrderRecord row, {
    _is.ColumnSelections<OrderRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<OrderRecord>(
      row,
      columns: columns?.call(OrderRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OrderRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<OrderRecord?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<OrderRecordUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<OrderRecord>(
      id,
      columnValues: columnValues(OrderRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [OrderRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<OrderRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<OrderRecordUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<OrderRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OrderRecordTable>? orderBy,
    _is.OrderByListBuilder<OrderRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<OrderRecord>(
      columnValues: columnValues(OrderRecord.t.updateTable),
      where: where(OrderRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OrderRecord.t),
      orderByList: orderByList?.call(OrderRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [OrderRecord]s in the list and returns the deleted rows.
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
  Future<List<OrderRecord>> delete(
    _is.DatabaseSession session,
    List<OrderRecord> rows, {
    _is.OrderByBuilder<OrderRecordTable>? orderBy,
    _is.OrderByListBuilder<OrderRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<OrderRecord>(
      rows,
      orderBy: orderBy?.call(OrderRecord.t),
      orderByList: orderByList?.call(OrderRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [OrderRecord].
  Future<OrderRecord> deleteRow(
    _is.DatabaseSession session,
    OrderRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<OrderRecord>(
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
  Future<List<OrderRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<OrderRecordTable> where,
    _is.OrderByBuilder<OrderRecordTable>? orderBy,
    _is.OrderByListBuilder<OrderRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<OrderRecord>(
      where: where(OrderRecord.t),
      orderBy: orderBy?.call(OrderRecord.t),
      orderByList: orderByList?.call(OrderRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<OrderRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<OrderRecord>(
      where: where?.call(OrderRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [OrderRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<OrderRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<OrderRecord>(
      where: where(OrderRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
