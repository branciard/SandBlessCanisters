import Hash "mo:base/Hash";
import Nat64 "mo:base/Nat64";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Bool "mo:base/Bool";
import TrieSet "mo:base/TrieSet";
import List "mo:base/List";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Time "mo:base/Time";
import StableBuffer "mo:stable-buffer/StableBuffer";
import RBTree "mo:stable-rbtree/StableRBTree";
import Types "./Types";

shared ({ caller }) actor class SandBless(initialArgs : Types.InitialArgs) = Self {

  private stable var custodians = RBTree.init<Text, Bool>();

  let (custodianEntryUpdated, custodiansFromUpdate) = RBTree.replace(custodians, Text.compare, Principal.toText(caller), true);
  if (Option.isSome(custodianEntryUpdated)) {
    custodians := custodiansFromUpdate;
  } else {
    custodians := RBTree.put(custodians, Text.compare, Principal.toText(caller), true);
  };
  for (custodian in initialArgs.custodians.vals()) {
    let (custodianEntryUpdated, custodiansFromUpdate) = RBTree.replace(custodians, Text.compare, Principal.toText(custodian.custodianPrincipal), true);
    if (Option.isSome(custodianEntryUpdated)) {
      custodians := custodiansFromUpdate;
    } else {
      custodians := RBTree.put(custodians, Text.compare, Principal.toText(custodian.custodianPrincipal), true);
    };
  };

  private stable var marksCounter : Nat64 = 0;
  private stable var marks = RBTree.init<Nat64, Types.Mark>();
  private stable var imprintsCounter : Nat64 = 0;
  private stable var imprints = RBTree.init<Nat64, Types.Imprint>();
  private stable var imprintIdsByMarkId = RBTree.init<Nat64, [Nat64]>();
  private stable var markIdsByImprintId = RBTree.init<Nat64, [Nat64]>();

  func nat64Hash(n : Nat64) : Hash.Hash {
    Text.hash(Nat64.toText(n));
  };

  // https://forum.dfinity.org/t/is-there-any-address-0-equivalent-at-dfinity-motoko/5445/3
  let null_address : Principal = Principal.fromText("aaaaa-aa");

  public shared query (msg) func whoami() : async Principal {
    return msg.caller;
  };

  public shared query (msg) func whoamiTextformat() : async Text {
    return Principal.toText(msg.caller);
  };

  public query func getMarksTotalCount() : async Nat64 {
    return marksCounter;
  };

  public query func getImprintsTotalCount() : async Nat64 {
    return imprintsCounter;
  };

  public query func getMarksTreeSize() : async Nat {
    return RBTree.size(marks);
  };

  public query func getImprintsTreeSize() : async Nat {
    return RBTree.size(imprints);
  };

  public query func getImprintIdsByMarkIdTreeSize() : async Nat {
    return RBTree.size(imprintIdsByMarkId);
  };

  public query func getMarkIdsByImprintIdTreeSize() : async Nat {
    return RBTree.size(markIdsByImprintId);
  };

  public query func getCustodiansTreeSize() : async Nat {
    return RBTree.size(custodians);
  };

  public query func isPrincipalCustodian(principal : Principal) : async Bool {
    let custodian : ?Bool = RBTree.get(custodians, Text.compare, Principal.toText(principal));
    switch (custodian) {
      case null {
        return false;
      };
      case (?custodian) {
        return true;
      };
    };
  };

  public query func isCustodian(principal : Text) : async Bool {
    let custodian : ?Bool = RBTree.get(custodians, Text.compare, principal);
    switch (custodian) {
      case null {
        return false;
      };
      case (?custodian) {
        return true;
      };
    };
  };

  public query func getCustodians() : async [(Text, Bool)] {
    return Iter.toArray(RBTree.entries(custodians));
  };

  public query func getImprintIdsByMarkId(markId : Nat64) : async ?[Nat64] {
    return RBTree.get(imprintIdsByMarkId, Nat64.compare, markId);
  };

  public query func getImprintIdsByMarkIdTree() : async [(Nat64, [Nat64])] {
    return Iter.toArray(RBTree.entries(imprintIdsByMarkId));
  };

  public query func getMarkIdsByImprintId(imprintId : Nat64) : async ?[Nat64] {
    return RBTree.get(markIdsByImprintId, Nat64.compare, imprintId);
  };

  public query func getMarkIdsByImprintIdTree() : async [(Nat64, [Nat64])] {
    return Iter.toArray(RBTree.entries(markIdsByImprintId));
  };

  public query func isMarkExist(markId : Nat64) : async Bool {
    let mark : ?Types.Mark = RBTree.get(marks, Nat64.compare, markId);
    let exists = Option.isSome(mark);
    if (exists) {
      return true;
    } else {
      return false;
    };
  };

  public shared ({ caller }) func addCustodian(newCustodian : Text) : async Bool {
    let custodian : ?Bool = RBTree.get(custodians, Text.compare, Principal.toText(caller));
    switch (custodian) {
      case null {
        return false;
      };
      case (?custodian) {
        let (custodianEntryUpdated, custodiansFromUpdate) = RBTree.replace(custodians, Text.compare, newCustodian, true);
        if (Option.isSome(custodianEntryUpdated)) {
          custodians := custodiansFromUpdate;
        } else {
          custodians := RBTree.put(custodians, Text.compare, newCustodian, true);
        };
        return true;
      };
    };
  };

  public shared ({ caller }) func removeCustodian(custodianToRemove : Text) : async Bool {
    let custodian : ?Bool = RBTree.get(custodians, Text.compare, Principal.toText(caller));
    switch (custodian) {
      case null {
        return false;
      };
      case (?custodian) {
        let (custodianEntryRemoved, custodiansFromRemove) = RBTree.remove(custodians, Text.compare, custodianToRemove);
        if (Option.isSome(custodianEntryRemoved)) {
          custodians := custodiansFromRemove;
          return true;
        } else {
          return false;
        };
      };
    };
  };

  public shared ({ caller }) func purgeCanister() : async Bool {
    let custodian : ?Bool = RBTree.get(custodians, Text.compare, Principal.toText(caller));
    switch (custodian) {
      case null {
        return false;
      };
      case (?custodian) {
        marksCounter := 0;
        marks := RBTree.init<Nat64, Types.Mark>();
        imprintsCounter := 0;
        imprints := RBTree.init<Nat64, Types.Imprint>();
        imprintIdsByMarkId := RBTree.init<Nat64, [Nat64]>();
        markIdsByImprintId := RBTree.init<Nat64, [Nat64]>();
        custodians := RBTree.init<Text, Bool>();
        return true;
      };
    };
  };

  public query func getMark(markId : Nat64) : async Types.MarkResult {
    let mark : ?Types.Mark = RBTree.get(marks, Nat64.compare, markId);
    switch (mark) {
      case null {
        return #Err(#InvalidMarkId);
      };
      case (?mark) {
        return #Ok(mark);
      };
    };
  };

  public query func isImprintExist(imprintId : Nat64) : async Bool {
    let imprint : ?Types.Imprint = RBTree.get(imprints, Nat64.compare, imprintId);
    let exists = Option.isSome(imprint);
    if (exists) {
      return true;
    } else {
      return false;
    };
  };

  public query func getImprint(imprintId : Nat64) : async Types.ImprintResult {
    let imprint : ?Types.Imprint = RBTree.get(imprints, Nat64.compare, imprintId);
    switch (imprint) {
      case null {
        return #Err(#InvalidImprintId);
      };
      case (?imprint) {
        return #Ok(imprint);
      };
    };
  };

  public shared ({ caller }) func createMark() : async Types.MarkResult {
    marksCounter += 1;
    let mark : Types.Mark = {
      id = marksCounter;
      createdWhen = Time.now();
      createdBy = caller;
    };
    // Choice : allways trust marksCounter to populate or replace tree structure.
    let (markEntryUpdated, marksFromUpdate) = RBTree.replace(marks, Nat64.compare, marksCounter, mark);
    if (Option.isSome(markEntryUpdated)) {
      marks := marksFromUpdate;
    } else {
      marks := RBTree.put(marks, Nat64.compare, marksCounter, mark);
    };

    return #Ok(mark);
  };

  public shared ({ caller }) func setImprintVisible(imprintId : Nat64) : async Types.ImprintResult {

    let imprint : ?Types.Imprint = RBTree.get(imprints, Nat64.compare, imprintId);
    switch (imprint) {
      case null {
        return #Err(#InvalidImprintId);
      };
      case (?imprint) {
        let imprintToUpdate : Types.Imprint = {
          id = imprint.id;
          createdWhen = imprint.createdWhen;
          createdBy = imprint.createdBy;
          imprintType = imprint.imprintType;
          imprintData = imprint.imprintData;
          visible = true;
        };
        let (imprintsEntry, imprintsUpdated) = RBTree.replace(imprints, Nat64.compare, imprint.id, imprintToUpdate);
        if (Option.isSome(imprintsEntry)) {
          imprints := imprintsUpdated;
        } else {
          imprints := RBTree.put(imprints, Nat64.compare, imprint.id, imprintToUpdate);
        };
        return #Ok(imprintToUpdate);
      };
    };
  };

  public shared ({ caller }) func setImprintInvisible(imprintId : Nat64) : async Types.ImprintResult {

    let imprint : ?Types.Imprint = RBTree.get(imprints, Nat64.compare, imprintId);
    switch (imprint) {
      case null {
        return #Err(#InvalidImprintId);
      };
      case (?imprint) {
        let imprintToUpdate : Types.Imprint = {
          id = imprint.id;
          createdWhen = imprint.createdWhen;
          createdBy = imprint.createdBy;
          imprintType = imprint.imprintType;
          imprintData = imprint.imprintData;
          visible = false;
        };
        let (imprintsEntry, imprintsUpdated) = RBTree.replace(imprints, Nat64.compare, imprint.id, imprintToUpdate);
        if (Option.isSome(imprintsEntry)) {
          imprints := imprintsUpdated;
        } else {
          imprints := RBTree.put(imprints, Nat64.compare, imprint.id, imprintToUpdate);
        };
        return #Ok(imprintToUpdate);
      };
    };
  };

  public shared ({ caller }) func createImprint(markIds : [Nat64], imprintType : Nat64, imprintData : Types.ImprintData) : async Types.ImprintResult {

    //Check at least one mark to update
    if (markIds.size() == 0) {
      return #Err(#ImprintWithoutMark);
    };

    //check doublon in markIds
    try {
      let markIdsToSet = TrieSet.fromArray(markIds, nat64Hash, Nat64.equal);
      let markIdsToSetSize = TrieSet.size(markIdsToSet);
      if (markIdsToSetSize != markIds.size()) {
        return #Err(#IdDoubloninArray);
      };
    } catch (e) {
      return #Err(#IdDoubloninArray);
    };

    //Check all marks ids exist
    for (markId in markIds.vals()) {
      let mark : ?Types.Mark = RBTree.get(marks, Nat64.compare, markId);
      if (Option.isNull(mark)) {
        return #Err(#InvalidMarkId);
      };
    };

    // Create Imprint
    imprintsCounter += 1;
    let imprint : Types.Imprint = {
      id = imprintsCounter;
      createdWhen = Time.now();
      createdBy = caller;
      imprintType = imprintType;
      imprintData = imprintData;
      visible = true;
    };

    // markIdsByImprintId updates
    let (markIdsByImprintIdEntry, markIdsByImprintIdUpdated) = RBTree.replace(markIdsByImprintId, Nat64.compare, imprint.id, markIds);
    if (Option.isSome(markIdsByImprintIdEntry)) {
      markIdsByImprintId := markIdsByImprintIdUpdated;
    } else {
      markIdsByImprintId := RBTree.put(markIdsByImprintId, Nat64.compare, imprint.id, markIds);
    };

    // imprintIdsByMarkId updates
    for (markId in markIds.vals()) {
      let imprintIdsByMarkIdValues : ?[Nat64] = RBTree.get(imprintIdsByMarkId, Nat64.compare, markId);
      switch imprintIdsByMarkIdValues {
        case (null) {
          // choice : allways trust counter to populate or replace over tree structure.
          let (imprintIdsByMarkIdIdEntry, imprintIdsByMarkIdUpdated) = RBTree.replace(imprintIdsByMarkId, Nat64.compare, markId, [imprintsCounter]);
          if (Option.isSome(imprintIdsByMarkIdIdEntry)) {
            imprintIdsByMarkId := imprintIdsByMarkIdUpdated;
          } else {
            imprintIdsByMarkId := RBTree.put(imprintIdsByMarkId, Nat64.compare, markId, [imprintsCounter]);
          };
        };
        case (?imprintIdsByMarkIdValues) {
          let buffer = StableBuffer.fromArray<Nat64>(imprintIdsByMarkIdValues);
          StableBuffer.add(buffer, imprintsCounter);
          let (imprintIdsByMarkIdIdEntry, imprintIdsByMarkIdUpdated) = RBTree.replace(imprintIdsByMarkId, Nat64.compare, markId, StableBuffer.toArray(buffer));
          if (Option.isSome(imprintIdsByMarkIdIdEntry)) {
            imprintIdsByMarkId := imprintIdsByMarkIdUpdated;
          } else {
            imprintIdsByMarkId := RBTree.put(imprintIdsByMarkId, Nat64.compare, markId, StableBuffer.toArray(buffer));
          };
        };
      };
    };

    let (imprintsEntry, imprintsUpdated) = RBTree.replace(imprints, Nat64.compare, imprint.id, imprint);
    if (Option.isSome(imprintsEntry)) {
      imprints := imprintsUpdated;
    } else {
      imprints := RBTree.put(imprints, Nat64.compare, imprint.id, imprint);
    };

    return #Ok(imprint);

  };

};
