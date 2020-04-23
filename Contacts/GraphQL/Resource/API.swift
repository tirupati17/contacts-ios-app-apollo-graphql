//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class ContactsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query contacts {
      contacts {
        __typename
        first_name
        last_name
        id
        profile_pic
        url
        favorite
      }
    }
    """

  public let operationName = "contacts"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("contacts", type: .list(.object(Contact.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(contacts: [Contact?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "contacts": contacts.flatMap { (value: [Contact?]) -> [ResultMap?] in value.map { (value: Contact?) -> ResultMap? in value.flatMap { (value: Contact) -> ResultMap in value.resultMap } } }])
    }

    public var contacts: [Contact?]? {
      get {
        return (resultMap["contacts"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Contact?] in value.map { (value: ResultMap?) -> Contact? in value.flatMap { (value: ResultMap) -> Contact in Contact(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [Contact?]) -> [ResultMap?] in value.map { (value: Contact?) -> ResultMap? in value.flatMap { (value: Contact) -> ResultMap in value.resultMap } } }, forKey: "contacts")
      }
    }

    public struct Contact: GraphQLSelectionSet {
      public static let possibleTypes = ["Contact"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("first_name", type: .scalar(String.self)),
        GraphQLField("last_name", type: .scalar(String.self)),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("profile_pic", type: .scalar(String.self)),
        GraphQLField("url", type: .scalar(String.self)),
        GraphQLField("favorite", type: .scalar(Bool.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(firstName: String? = nil, lastName: String? = nil, id: GraphQLID, profilePic: String? = nil, url: String? = nil, favorite: Bool? = nil) {
        self.init(unsafeResultMap: ["__typename": "Contact", "first_name": firstName, "last_name": lastName, "id": id, "profile_pic": profilePic, "url": url, "favorite": favorite])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var firstName: String? {
        get {
          return resultMap["first_name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "first_name")
        }
      }

      public var lastName: String? {
        get {
          return resultMap["last_name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "last_name")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var profilePic: String? {
        get {
          return resultMap["profile_pic"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "profile_pic")
        }
      }

      public var url: String? {
        get {
          return resultMap["url"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "url")
        }
      }

      public var favorite: Bool? {
        get {
          return resultMap["favorite"] as? Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "favorite")
        }
      }
    }
  }
}
