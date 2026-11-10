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

abstract class CustomerOrder
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  CustomerOrder._({
    this.id,
    required this.userId,
    required this.total,
    required this.createdAt,
  });

  factory CustomerOrder({
    int? id,
    required String userId,
    required double total,
    required DateTime createdAt,
  }) = _CustomerOrderImpl;

  factory CustomerOrder.fromJson(Map<String, dynamic> jsonSerialization) {
    return CustomerOrder(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      total: (jsonSerialization['total'] as num).toDouble(),
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = CustomerOrderTable();

  static const db = CustomerOrderRepository._();

  @override
  int? id;

  String userId;

  double total;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [CustomerOrder]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CustomerOrder copyWith({
    int? id,
    String? userId,
    double? total,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CustomerOrder',
      if (id != null) 'id': id,
      'userId': userId,
      'total': total,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CustomerOrder',
      if (id != null) 'id': id,
      'userId': userId,
      'total': total,
      'createdAt': createdAt.toJson(),
    };
  }

  static CustomerOrderInclude include() {
    return CustomerOrderInclude._();
  }

  static CustomerOrderIncludeList includeList({
    _is.WhereExpressionBuilder<CustomerOrderTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CustomerOrderTable>? orderBy,
    _is.OrderByListBuilder<CustomerOrderTable>? orderByList,
    CustomerOrderInclude? include,
  }) {
    return CustomerOrderIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CustomerOrder.t),
      orderByList: orderByList?.call(CustomerOrder.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CustomerOrderImpl extends CustomerOrder {
  _CustomerOrderImpl({
    int? id,
    required String userId,
    required double total,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         total: total,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CustomerOrder]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CustomerOrder copyWith({
    Object? id = _Undefined,
    String? userId,
    double? total,
    DateTime? createdAt,
  }) {
    return CustomerOrder(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CustomerOrderUpdateTable extends _is.UpdateTable<CustomerOrderTable> {
  CustomerOrderUpdateTable(super.table);

  _is.ColumnValue<String, String> userId(String value) => _is.ColumnValue(
    table.userId,
    value,
  );

  _is.ColumnValue<double, double> total(double value) => _is.ColumnValue(
    table.total,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class CustomerOrderTable extends _is.Table<int?> {
  CustomerOrderTable({super.tableRelation})
    : super(tableName: 'customer_orders') {
    updateTable = CustomerOrderUpdateTable(this);
    userId = _is.ColumnString(
      'userId',
      this,
    );
    total = _is.ColumnDouble(
      'total',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final CustomerOrderUpdateTable updateTable;

  late final _is.ColumnString userId;

  late final _is.ColumnDouble total;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    total,
    createdAt,
  ];
}

class CustomerOrderInclude extends _is.IncludeObject {
  CustomerOrderInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => CustomerOrder.t;
}

class CustomerOrderIncludeList extends _is.IncludeList {
  CustomerOrderIncludeList._({
    _is.WhereExpressionBuilder<CustomerOrderTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CustomerOrder.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CustomerOrder.t;
}

class CustomerOrderRepository {
  const CustomerOrderRepository._();

  /// Returns a list of [CustomerOrder]s matching the given query parameters.
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
  Future<List<CustomerOrder>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CustomerOrderTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CustomerOrderTable>? orderBy,
    _is.OrderByListBuilder<CustomerOrderTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CustomerOrder>(
      where: where?.call(CustomerOrder.t),
      orderBy: orderBy?.call(CustomerOrder.t),
      orderByList: orderByList?.call(CustomerOrder.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CustomerOrder] matching the given query parameters.
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
  Future<CustomerOrder?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CustomerOrderTable>? where,
    int? offset,
    _is.OrderByBuilder<CustomerOrderTable>? orderBy,
    _is.OrderByListBuilder<CustomerOrderTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CustomerOrder>(
      where: where?.call(CustomerOrder.t),
      orderBy: orderBy?.call(CustomerOrder.t),
      orderByList: orderByList?.call(CustomerOrder.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CustomerOrder] by its [id] or null if no such row exists.
  Future<CustomerOrder?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CustomerOrder>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CustomerOrder]s in the list and returns the inserted rows.
  ///
  /// The returned [CustomerOrder]s will have their `id` fields set.
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
  Future<List<CustomerOrder>> insert(
    _is.DatabaseSession session,
    List<CustomerOrder> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CustomerOrder>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CustomerOrder] and returns the inserted row.
  ///
  /// The returned [CustomerOrder] will have its `id` field set.
  Future<CustomerOrder> insertRow(
    _is.DatabaseSession session,
    CustomerOrder row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CustomerOrder>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CustomerOrder]s in the list and returns the resulting rows.
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
  /// The returned [CustomerOrder]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CustomerOrder>> upsert(
    _is.DatabaseSession session,
    List<CustomerOrder> rows, {
    required _is.ColumnSelections<CustomerOrderTable> conflictColumns,
    _is.ColumnSelections<CustomerOrderTable>? updateColumns,
    _is.WhereExpressionBuilder<CustomerOrderTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CustomerOrder>(
      rows,
      conflictColumns: conflictColumns(CustomerOrder.t),
      updateColumns: updateColumns?.call(CustomerOrder.t),
      updateWhere: updateWhere?.call(CustomerOrder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CustomerOrder] and returns the resulting row.
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
  /// The returned [CustomerOrder] will have its `id` field set.
  Future<CustomerOrder?> upsertRow(
    _is.DatabaseSession session,
    CustomerOrder row, {
    required _is.ColumnSelections<CustomerOrderTable> conflictColumns,
    _is.ColumnSelections<CustomerOrderTable>? updateColumns,
    _is.WhereExpressionBuilder<CustomerOrderTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CustomerOrder>(
      row,
      conflictColumns: conflictColumns(CustomerOrder.t),
      updateColumns: updateColumns?.call(CustomerOrder.t),
      updateWhere: updateWhere?.call(CustomerOrder.t),
      transaction: transaction,
    );
  }

  /// Updates all [CustomerOrder]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CustomerOrder>> update(
    _is.DatabaseSession session,
    List<CustomerOrder> rows, {
    _is.ColumnSelections<CustomerOrderTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CustomerOrder>(
      rows,
      columns: columns?.call(CustomerOrder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CustomerOrder]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CustomerOrder> updateRow(
    _is.DatabaseSession session,
    CustomerOrder row, {
    _is.ColumnSelections<CustomerOrderTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CustomerOrder>(
      row,
      columns: columns?.call(CustomerOrder.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CustomerOrder] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CustomerOrder?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CustomerOrderUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CustomerOrder>(
      id,
      columnValues: columnValues(CustomerOrder.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CustomerOrder]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CustomerOrder>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CustomerOrderUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CustomerOrderTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CustomerOrderTable>? orderBy,
    _is.OrderByListBuilder<CustomerOrderTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CustomerOrder>(
      columnValues: columnValues(CustomerOrder.t.updateTable),
      where: where(CustomerOrder.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CustomerOrder.t),
      orderByList: orderByList?.call(CustomerOrder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CustomerOrder]s in the list and returns the deleted rows.
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
  Future<List<CustomerOrder>> delete(
    _is.DatabaseSession session,
    List<CustomerOrder> rows, {
    _is.OrderByBuilder<CustomerOrderTable>? orderBy,
    _is.OrderByListBuilder<CustomerOrderTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CustomerOrder>(
      rows,
      orderBy: orderBy?.call(CustomerOrder.t),
      orderByList: orderByList?.call(CustomerOrder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CustomerOrder].
  Future<CustomerOrder> deleteRow(
    _is.DatabaseSession session,
    CustomerOrder row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CustomerOrder>(
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
  Future<List<CustomerOrder>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CustomerOrderTable> where,
    _is.OrderByBuilder<CustomerOrderTable>? orderBy,
    _is.OrderByListBuilder<CustomerOrderTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CustomerOrder>(
      where: where(CustomerOrder.t),
      orderBy: orderBy?.call(CustomerOrder.t),
      orderByList: orderByList?.call(CustomerOrder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CustomerOrderTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CustomerOrder>(
      where: where?.call(CustomerOrder.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CustomerOrder] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CustomerOrderTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CustomerOrder>(
      where: where(CustomerOrder.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
