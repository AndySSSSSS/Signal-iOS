//
//  Copyright (c) 2019 Open Whisper Systems. All rights reserved.
//

import Foundation
import GRDB
import SignalCoreKit

// NOTE: This file is generated by /Scripts/sds_codegen/sds_generate.py.
// Do not manually edit it, instead run `sds_codegen.sh`.

// MARK: - Record

public struct UserProfileRecord: SDSRecord {
    public weak var delegate: SDSRecordDelegate?

    public var tableMetadata: SDSTableMetadata {
        return OWSUserProfileSerializer.table
    }

    public static let databaseTableName: String = OWSUserProfileSerializer.table.tableName

    public var id: Int64?

    // This defines all of the columns used in the table
    // where this model (and any subclasses) are persisted.
    public let recordType: SDSRecordType
    public let uniqueId: String

    // Base class properties
    public let avatarFileName: String?
    public let avatarUrlPath: String?
    public let profileKey: Data?
    public let profileName: String?
    public let recipientPhoneNumber: String?
    public let recipientUUID: String?
    public let username: String?

    public enum CodingKeys: String, CodingKey, ColumnExpression, CaseIterable {
        case id
        case recordType
        case uniqueId
        case avatarFileName
        case avatarUrlPath
        case profileKey
        case profileName
        case recipientPhoneNumber
        case recipientUUID
        case username
    }

    public static func columnName(_ column: UserProfileRecord.CodingKeys, fullyQualified: Bool = false) -> String {
        return fullyQualified ? "\(databaseTableName).\(column.rawValue)" : column.rawValue
    }

    public func didInsert(with rowID: Int64, for column: String?) {
        guard let delegate = delegate else {
            owsFailDebug("Missing delegate.")
            return
        }
        delegate.updateRowId(rowID)
    }
}

// MARK: - Row Initializer

public extension UserProfileRecord {
    static var databaseSelection: [SQLSelectable] {
        return CodingKeys.allCases
    }

    init(row: Row) {
        id = row[0]
        recordType = row[1]
        uniqueId = row[2]
        avatarFileName = row[3]
        avatarUrlPath = row[4]
        profileKey = row[5]
        profileName = row[6]
        recipientPhoneNumber = row[7]
        recipientUUID = row[8]
        username = row[9]
    }
}

// MARK: - StringInterpolation

public extension String.StringInterpolation {
    mutating func appendInterpolation(userProfileColumn column: UserProfileRecord.CodingKeys) {
        appendLiteral(UserProfileRecord.columnName(column))
    }
    mutating func appendInterpolation(userProfileColumnFullyQualified column: UserProfileRecord.CodingKeys) {
        appendLiteral(UserProfileRecord.columnName(column, fullyQualified: true))
    }
}

// MARK: - Deserialization

// TODO: Rework metadata to not include, for example, columns, column indices.
extension OWSUserProfile {
    // This method defines how to deserialize a model, given a
    // database row.  The recordType column is used to determine
    // the corresponding model class.
    class func fromRecord(_ record: UserProfileRecord) throws -> OWSUserProfile {

        guard let recordId = record.id else {
            throw SDSError.invalidValue
        }

        switch record.recordType {
        case .userProfile:

            let uniqueId: String = record.uniqueId
            let avatarFileName: String? = record.avatarFileName
            let avatarUrlPath: String? = record.avatarUrlPath
            let profileKeySerialized: Data? = record.profileKey
            let profileKey: OWSAES256Key? = try SDSDeserialization.optionalUnarchive(profileKeySerialized, name: "profileKey")
            let profileName: String? = record.profileName
            let recipientPhoneNumber: String? = record.recipientPhoneNumber
            let recipientUUID: String? = record.recipientUUID
            let username: String? = record.username

            return OWSUserProfile(grdbId: recordId,
                                  uniqueId: uniqueId,
                                  avatarFileName: avatarFileName,
                                  avatarUrlPath: avatarUrlPath,
                                  profileKey: profileKey,
                                  profileName: profileName,
                                  recipientPhoneNumber: recipientPhoneNumber,
                                  recipientUUID: recipientUUID,
                                  username: username)

        default:
            owsFailDebug("Unexpected record type: \(record.recordType)")
            throw SDSError.invalidValue
        }
    }
}

// MARK: - SDSModel

extension OWSUserProfile: SDSModel {
    public var serializer: SDSSerializer {
        // Any subclass can be cast to it's superclass,
        // so the order of this switch statement matters.
        // We need to do a "depth first" search by type.
        switch self {
        default:
            return OWSUserProfileSerializer(model: self)
        }
    }

    public func asRecord() throws -> SDSRecord {
        return try serializer.asRecord()
    }

    public var sdsTableName: String {
        return UserProfileRecord.databaseTableName
    }

    public static var table: SDSTableMetadata {
        return OWSUserProfileSerializer.table
    }
}

// MARK: - Table Metadata

extension OWSUserProfileSerializer {

    // This defines all of the columns used in the table
    // where this model (and any subclasses) are persisted.
    static let idColumn = SDSColumnMetadata(columnName: "id", columnType: .primaryKey, columnIndex: 0)
    static let recordTypeColumn = SDSColumnMetadata(columnName: "recordType", columnType: .int64, columnIndex: 1)
    static let uniqueIdColumn = SDSColumnMetadata(columnName: "uniqueId", columnType: .unicodeString, isUnique: true, columnIndex: 2)
    // Base class properties
    static let avatarFileNameColumn = SDSColumnMetadata(columnName: "avatarFileName", columnType: .unicodeString, isOptional: true, columnIndex: 3)
    static let avatarUrlPathColumn = SDSColumnMetadata(columnName: "avatarUrlPath", columnType: .unicodeString, isOptional: true, columnIndex: 4)
    static let profileKeyColumn = SDSColumnMetadata(columnName: "profileKey", columnType: .blob, isOptional: true, columnIndex: 5)
    static let profileNameColumn = SDSColumnMetadata(columnName: "profileName", columnType: .unicodeString, isOptional: true, columnIndex: 6)
    static let recipientPhoneNumberColumn = SDSColumnMetadata(columnName: "recipientPhoneNumber", columnType: .unicodeString, isOptional: true, columnIndex: 7)
    static let recipientUUIDColumn = SDSColumnMetadata(columnName: "recipientUUID", columnType: .unicodeString, isOptional: true, columnIndex: 8)
    static let usernameColumn = SDSColumnMetadata(columnName: "username", columnType: .unicodeString, isOptional: true, columnIndex: 9)

    // TODO: We should decide on a naming convention for
    //       tables that store models.
    public static let table = SDSTableMetadata(collection: OWSUserProfile.collection(),
                                               tableName: "model_OWSUserProfile",
                                               columns: [
        idColumn,
        recordTypeColumn,
        uniqueIdColumn,
        avatarFileNameColumn,
        avatarUrlPathColumn,
        profileKeyColumn,
        profileNameColumn,
        recipientPhoneNumberColumn,
        recipientUUIDColumn,
        usernameColumn
        ])
}

// MARK: - Save/Remove/Update

@objc
public extension OWSUserProfile {
    func anyInsert(transaction: SDSAnyWriteTransaction) {
        sdsSave(saveMode: .insert, transaction: transaction)
    }

    // This method is private; we should never use it directly.
    // Instead, use anyUpdate(transaction:block:), so that we
    // use the "update with" pattern.
    private func anyUpdate(transaction: SDSAnyWriteTransaction) {
        sdsSave(saveMode: .update, transaction: transaction)
    }

    @available(*, deprecated, message: "Use anyInsert() or anyUpdate() instead.")
    func anyUpsert(transaction: SDSAnyWriteTransaction) {
        let isInserting: Bool
        if OWSUserProfile.anyFetch(uniqueId: uniqueId, transaction: transaction) != nil {
            isInserting = false
        } else {
            isInserting = true
        }
        sdsSave(saveMode: isInserting ? .insert : .update, transaction: transaction)
    }

    // This method is used by "updateWith..." methods.
    //
    // This model may be updated from many threads. We don't want to save
    // our local copy (this instance) since it may be out of date.  We also
    // want to avoid re-saving a model that has been deleted.  Therefore, we
    // use "updateWith..." methods to:
    //
    // a) Update a property of this instance.
    // b) If a copy of this model exists in the database, load an up-to-date copy,
    //    and update and save that copy.
    // b) If a copy of this model _DOES NOT_ exist in the database, do _NOT_ save
    //    this local instance.
    //
    // After "updateWith...":
    //
    // a) Any copy of this model in the database will have been updated.
    // b) The local property on this instance will always have been updated.
    // c) Other properties on this instance may be out of date.
    //
    // All mutable properties of this class have been made read-only to
    // prevent accidentally modifying them directly.
    //
    // This isn't a perfect arrangement, but in practice this will prevent
    // data loss and will resolve all known issues.
    func anyUpdate(transaction: SDSAnyWriteTransaction, block: (OWSUserProfile) -> Void) {

        block(self)

        guard let dbCopy = type(of: self).anyFetch(uniqueId: uniqueId,
                                                   transaction: transaction) else {
            return
        }

        // Don't apply the block twice to the same instance.
        // It's at least unnecessary and actually wrong for some blocks.
        // e.g. `block: { $0 in $0.someField++ }`
        if dbCopy !== self {
            block(dbCopy)
        }

        dbCopy.anyUpdate(transaction: transaction)
    }

    // The class function lets us update the database only without
    // instantiating a model twice. anyUpdate() will instantiate
    // the model once.
    @objc(anyUpdateUserProfileWithUniqueId:transaction:block:)
    class func anyUpdateUserProfile(uniqueId: String,
                               transaction: SDSAnyWriteTransaction, block: (OWSUserProfile) -> Void) {
        guard let dbCopy = anyFetch(uniqueId: uniqueId,
                                    transaction: transaction) else {
                                        owsFailDebug("Can't update missing record.")
                                        return
        }
        dbCopy.anyUpdate(transaction: transaction)
    }

    func anyRemove(transaction: SDSAnyWriteTransaction) {
        sdsRemove(transaction: transaction)
    }

    func anyReload(transaction: SDSAnyReadTransaction) {
        anyReload(transaction: transaction, ignoreMissing: false)
    }

    func anyReload(transaction: SDSAnyReadTransaction, ignoreMissing: Bool) {
        guard let latestVersion = type(of: self).anyFetch(uniqueId: uniqueId, transaction: transaction) else {
            if !ignoreMissing {
                owsFailDebug("`latest` was unexpectedly nil")
            }
            return
        }

        setValuesForKeys(latestVersion.dictionaryValue)
    }
}

// MARK: - OWSUserProfileCursor

@objc
public class OWSUserProfileCursor: NSObject {
    private let cursor: RecordCursor<UserProfileRecord>?

    init(cursor: RecordCursor<UserProfileRecord>?) {
        self.cursor = cursor
    }

    public func next() throws -> OWSUserProfile? {
        guard let cursor = cursor else {
            return nil
        }
        guard let record = try cursor.next() else {
            return nil
        }
        return try OWSUserProfile.fromRecord(record)
    }

    public func all() throws -> [OWSUserProfile] {
        var result = [OWSUserProfile]()
        while true {
            guard let model = try next() else {
                break
            }
            result.append(model)
        }
        return result
    }
}

// MARK: - Obj-C Fetch

// TODO: We may eventually want to define some combination of:
//
// * fetchCursor, fetchOne, fetchAll, etc. (ala GRDB)
// * Optional "where clause" parameters for filtering.
// * Async flavors with completions.
//
// TODO: I've defined flavors that take a read transaction.
//       Or we might take a "connection" if we end up having that class.
@objc
public extension OWSUserProfile {
    class func grdbFetchCursor(transaction: GRDBReadTransaction) -> OWSUserProfileCursor {
        let database = transaction.database
        do {
            let cursor = try UserProfileRecord.fetchCursor(database)
            return OWSUserProfileCursor(cursor: cursor)
        } catch {
            owsFailDebug("Read failed: \(error)")
            return OWSUserProfileCursor(cursor: nil)
        }
    }

    // Fetches a single model by "unique id".
    class func anyFetch(uniqueId: String,
                        transaction: SDSAnyReadTransaction) -> OWSUserProfile? {
        assert(uniqueId.count > 0)

        switch transaction.readTransaction {
        case .yapRead(let ydbTransaction):
            return OWSUserProfile.ydb_fetch(uniqueId: uniqueId, transaction: ydbTransaction)
        case .grdbRead(let grdbTransaction):
            let sql = "SELECT * FROM \(UserProfileRecord.databaseTableName) WHERE \(userProfileColumn: .uniqueId) = ?"
            return grdbFetchOne(sql: sql, arguments: [uniqueId], transaction: grdbTransaction)
        }
    }

    // Traverses all records.
    // Records are not visited in any particular order.
    class func anyEnumerate(transaction: SDSAnyReadTransaction,
                            block: @escaping (OWSUserProfile, UnsafeMutablePointer<ObjCBool>) -> Void) {
        anyEnumerate(transaction: transaction, batched: false, block: block)
    }

    // Traverses all records.
    // Records are not visited in any particular order.
    class func anyEnumerate(transaction: SDSAnyReadTransaction,
                            batched: Bool = false,
                            block: @escaping (OWSUserProfile, UnsafeMutablePointer<ObjCBool>) -> Void) {
        let batchSize = batched ? Batching.kDefaultBatchSize : 0
        anyEnumerate(transaction: transaction, batchSize: batchSize, block: block)
    }

    // Traverses all records.
    // Records are not visited in any particular order.
    //
    // If batchSize > 0, the enumeration is performed in autoreleased batches.
    class func anyEnumerate(transaction: SDSAnyReadTransaction,
                            batchSize: UInt,
                            block: @escaping (OWSUserProfile, UnsafeMutablePointer<ObjCBool>) -> Void) {
        switch transaction.readTransaction {
        case .yapRead(let ydbTransaction):
            OWSUserProfile.ydb_enumerateCollectionObjects(with: ydbTransaction) { (object, stop) in
                guard let value = object as? OWSUserProfile else {
                    owsFailDebug("unexpected object: \(type(of: object))")
                    return
                }
                block(value, stop)
            }
        case .grdbRead(let grdbTransaction):
            do {
                let cursor = OWSUserProfile.grdbFetchCursor(transaction: grdbTransaction)
                try Batching.loop(batchSize: batchSize,
                                  loopBlock: { stop in
                                      guard let value = try cursor.next() else {
                                        stop.pointee = true
                                        return
                                      }
                                      block(value, stop)
                })
            } catch let error {
                owsFailDebug("Couldn't fetch models: \(error)")
            }
        }
    }

    // Traverses all records' unique ids.
    // Records are not visited in any particular order.
    class func anyEnumerateUniqueIds(transaction: SDSAnyReadTransaction,
                                     block: @escaping (String, UnsafeMutablePointer<ObjCBool>) -> Void) {
        anyEnumerateUniqueIds(transaction: transaction, batched: false, block: block)
    }

    // Traverses all records' unique ids.
    // Records are not visited in any particular order.
    class func anyEnumerateUniqueIds(transaction: SDSAnyReadTransaction,
                                     batched: Bool = false,
                                     block: @escaping (String, UnsafeMutablePointer<ObjCBool>) -> Void) {
        let batchSize = batched ? Batching.kDefaultBatchSize : 0
        anyEnumerateUniqueIds(transaction: transaction, batchSize: batchSize, block: block)
    }

    // Traverses all records' unique ids.
    // Records are not visited in any particular order.
    //
    // If batchSize > 0, the enumeration is performed in autoreleased batches.
    class func anyEnumerateUniqueIds(transaction: SDSAnyReadTransaction,
                                     batchSize: UInt,
                                     block: @escaping (String, UnsafeMutablePointer<ObjCBool>) -> Void) {
        switch transaction.readTransaction {
        case .yapRead(let ydbTransaction):
            ydbTransaction.enumerateKeys(inCollection: OWSUserProfile.collection()) { (uniqueId, stop) in
                block(uniqueId, stop)
            }
        case .grdbRead(let grdbTransaction):
            grdbEnumerateUniqueIds(transaction: grdbTransaction,
                                   sql: """
                    SELECT \(userProfileColumn: .uniqueId)
                    FROM \(UserProfileRecord.databaseTableName)
                """,
                batchSize: batchSize,
                block: block)
        }
    }

    // Does not order the results.
    class func anyFetchAll(transaction: SDSAnyReadTransaction) -> [OWSUserProfile] {
        var result = [OWSUserProfile]()
        anyEnumerate(transaction: transaction) { (model, _) in
            result.append(model)
        }
        return result
    }

    // Does not order the results.
    class func anyAllUniqueIds(transaction: SDSAnyReadTransaction) -> [String] {
        var result = [String]()
        anyEnumerateUniqueIds(transaction: transaction) { (uniqueId, _) in
            result.append(uniqueId)
        }
        return result
    }

    class func anyCount(transaction: SDSAnyReadTransaction) -> UInt {
        switch transaction.readTransaction {
        case .yapRead(let ydbTransaction):
            return ydbTransaction.numberOfKeys(inCollection: OWSUserProfile.collection())
        case .grdbRead(let grdbTransaction):
            return UserProfileRecord.ows_fetchCount(grdbTransaction.database)
        }
    }

    // WARNING: Do not use this method for any models which do cleanup
    //          in their anyWillRemove(), anyDidRemove() methods.
    class func anyRemoveAllWithoutInstantation(transaction: SDSAnyWriteTransaction) {
        switch transaction.writeTransaction {
        case .yapWrite(let ydbTransaction):
            ydbTransaction.removeAllObjects(inCollection: OWSUserProfile.collection())
        case .grdbWrite(let grdbTransaction):
            do {
                try UserProfileRecord.deleteAll(grdbTransaction.database)
            } catch {
                owsFailDebug("deleteAll() failed: \(error)")
            }
        }

        if shouldBeIndexedForFTS {
            FullTextSearchFinder.allModelsWereRemoved(collection: collection(), transaction: transaction)
        }
    }

    class func anyRemoveAllWithInstantation(transaction: SDSAnyWriteTransaction) {
        // To avoid mutationDuringEnumerationException, we need
        // to remove the instances outside the enumeration.
        let uniqueIds = anyAllUniqueIds(transaction: transaction)

        var index: Int = 0
        do {
            try Batching.loop(batchSize: Batching.kDefaultBatchSize,
                              loopBlock: { stop in
                                  guard index < uniqueIds.count else {
                                    stop.pointee = true
                                    return
                                  }
                                  let uniqueId = uniqueIds[index]
                                  index = index + 1
                                  guard let instance = anyFetch(uniqueId: uniqueId, transaction: transaction) else {
                                      owsFailDebug("Missing instance.")
                                      return
                                  }
                                  instance.anyRemove(transaction: transaction)
            })
        } catch {
            owsFailDebug("Error: \(error)")
        }

        if shouldBeIndexedForFTS {
            FullTextSearchFinder.allModelsWereRemoved(collection: collection(), transaction: transaction)
        }
    }

    class func anyExists(uniqueId: String,
                        transaction: SDSAnyReadTransaction) -> Bool {
        assert(uniqueId.count > 0)

        switch transaction.readTransaction {
        case .yapRead(let ydbTransaction):
            return ydbTransaction.hasObject(forKey: uniqueId, inCollection: OWSUserProfile.collection())
        case .grdbRead(let grdbTransaction):
            let sql = "SELECT EXISTS ( SELECT 1 FROM \(UserProfileRecord.databaseTableName) WHERE \(userProfileColumn: .uniqueId) = ? )"
            let arguments: StatementArguments = [uniqueId]
            return try! Bool.fetchOne(grdbTransaction.database, sql: sql, arguments: arguments) ?? false
        }
    }
}

// MARK: - Swift Fetch

public extension OWSUserProfile {
    class func grdbFetchCursor(sql: String,
                               arguments: StatementArguments = StatementArguments(),
                               transaction: GRDBReadTransaction) -> OWSUserProfileCursor {
        do {
            let sqlRequest = SQLRequest<Void>(sql: sql, arguments: arguments, cached: true)
            let cursor = try UserProfileRecord.fetchCursor(transaction.database, sqlRequest)
            return OWSUserProfileCursor(cursor: cursor)
        } catch {
            Logger.error("sql: \(sql)")
            owsFailDebug("Read failed: \(error)")
            return OWSUserProfileCursor(cursor: nil)
        }
    }

    class func grdbFetchOne(sql: String,
                            arguments: StatementArguments = StatementArguments(),
                            transaction: GRDBReadTransaction) -> OWSUserProfile? {
        assert(sql.count > 0)

        do {
            let sqlRequest = SQLRequest<Void>(sql: sql, arguments: arguments, cached: true)
            guard let record = try UserProfileRecord.fetchOne(transaction.database, sqlRequest) else {
                return nil
            }

            return try OWSUserProfile.fromRecord(record)
        } catch {
            owsFailDebug("error: \(error)")
            return nil
        }
    }
}

// MARK: - SDSSerializer

// The SDSSerializer protocol specifies how to insert and update the
// row that corresponds to this model.
class OWSUserProfileSerializer: SDSSerializer {

    private let model: OWSUserProfile
    public required init(model: OWSUserProfile) {
        self.model = model
    }

    // MARK: - Record

    func asRecord() throws -> SDSRecord {
        let id: Int64? = model.grdbId?.int64Value

        let recordType: SDSRecordType = .userProfile
        let uniqueId: String = model.uniqueId

        // Base class properties
        let avatarFileName: String? = model.avatarFileName
        let avatarUrlPath: String? = model.avatarUrlPath
        let profileKey: Data? = optionalArchive(model.profileKey)
        let profileName: String? = model.profileName
        let recipientPhoneNumber: String? = model.recipientPhoneNumber
        let recipientUUID: String? = model.recipientUUID
        let username: String? = model.username

        return UserProfileRecord(delegate: model, id: id, recordType: recordType, uniqueId: uniqueId, avatarFileName: avatarFileName, avatarUrlPath: avatarUrlPath, profileKey: profileKey, profileName: profileName, recipientPhoneNumber: recipientPhoneNumber, recipientUUID: recipientUUID, username: username)
    }
}
