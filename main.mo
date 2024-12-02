import List "mo:base/List";
import Option "mo:base/Option";
import Trie "mo:base/Trie";
import Nat32 "mo:base/Nat32";

actor Superheroes {

  /**
   * Types
   */

  // userId.
  public type UserId = Nat32;
  //

   // User
  public type User = {
    name : Text;
    surname : Text;
    todo : List.List<Text>;
  };
  
  /**
   * Application State
   */

  // The next available superhero identifier.
  private stable var next : UserId = 0;

  // The User data store.
  private stable var Users : Trie.Trie<UserId, User> = Trie.empty();

  /**
   * High-Level API
   */

  // Create a User.
  public func create(user : User) : async UserId {
    let userId = next;
    next += 1;
    Users := Trie.replace(
      Users,
      key(userId),
      Nat32.equal,
      ?user,
    ).0;
    return userId;
  };

  // Read a user.
  public query func read(userId : UserId) : async ?User {
    let result = Trie.find(Users, key(userId), Nat32.equal);
    return result;
  };

  // Update a USer.
  public func update(userId : UserId, user : User) : async Bool {
    let result = Trie.find(Users, key(userId), Nat32.equal);
    let exists = Option.isSome(result);
    if (exists) {
      Users := Trie.replace(
        Users,
        key(userId),
        Nat32.equal,
        ?user,
      ).0;
    };
    return exists;
  };

  // Delete a user.
  public func delete(userId : UserId) : async Bool {
    let result = Trie.find(Users, key(userId), Nat32.equal);
    let exists = Option.isSome(result);
    if (exists) {
      Users := Trie.replace(
        Users,
        key(userId),
        Nat32.equal,
        null,
      ).0;
    };
    return exists;
  };

  /**
   * Utilities
   */

  // Create a trie key from a superhero identifier.
  private func key(x : UserId) : Trie.Key<UserId> {
    return { hash = x; key = x };
  };
};
