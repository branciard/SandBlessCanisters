import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import List "mo:base/List";
import Text "mo:base/Text";
import Map "mo:base/HashMap";
import Iter "mo:base/Iter";
import TrieSet "mo:base/TrieSet";

import Array "mo:base/Array";
import Option "mo:base/Option";
import Bool "mo:base/Bool";
import Principal "mo:base/Principal";
import Time "mo:base/Time";
import StableBuffer "mo:stable-buffer/StableBuffer";
import RBTree "mo:stable-rbtree/StableRBTree";
import Types "./Types";

// SandBlessDip721NFT from https://github.com/dfinity/examples/tree/master/motoko/dip-721-nft-container
shared actor class SandBlessDip721NFT(init : Types.Dip721NonFungibleToken) = Self {

  stable var transactionId : Types.TransactionId = 0;
  stable var nfts = List.nil<Types.Nft>();
  stable var artworks = List.nil<Types.Artwork>();
  stable var logo : Types.LogoResult = init.logo;
  stable var name : Text = init.name;
  stable var symbol : Text = init.symbol;
  stable var maxLimit : Nat16 = init.maxLimit;

  func nat64Hash(n : Nat64) : Hash.Hash {
    Text.hash(Nat64.toText(n));
  };

  private stable var marksCounter : Nat64 = 0;
  private stable var marks = RBTree.init<Nat64, Types.Mark>();
  private stable var imprintsCounter : Nat64 = 0;
  private stable var imprints = RBTree.init<Nat64, Types.Imprint>();
  private stable var imprintIdsByMarkId = RBTree.init<Nat64, [Nat64]>();
  private stable var markIdsByImprintId = RBTree.init<Nat64, [Nat64]>();

  // https://forum.dfinity.org/t/is-there-any-address-0-equivalent-at-dfinity-motoko/5445/3
  let null_address : Principal = Principal.fromText("aaaaa-aa");

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

  public query func getImprintIdsByMarkId(markId : Nat64) : async ?[Nat64] {
    return RBTree.get(imprintIdsByMarkId, Nat64.compare, markId);
  };

  public query func getMarkIdsByImprintId(imprintId : Nat64) : async ?[Nat64] {
    return RBTree.get(markIdsByImprintId, Nat64.compare, imprintId);
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

  public shared ({ caller }) func createMark() : async Types.Mark {
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

    return mark;
  };

  //public shared ({ caller }) func newImprint(markId : Nat64, data : Types.ImprintType, tags : [Text]) : async Types.ImprintResult {
  //public shared ({ caller }) func attachImprintToMark(markId : Nat64, data : Types.ImprintType, tags : [Text]) : async Types.ImprintResult {

  /*
  public shared ({ caller }) func newImprint(markIds : [Nat64], data : Types.ImprintType, tags : [Text]) : async Types.ImprintResult {
    let item = List.find(marks, func(mark : Types.Mark) : Bool { mark.id == markId });
    switch (item) {
      case null {
        return #Err(#InvalidSandBlessId);
      };
      case (?mark) {
        imprintsCounter += 1;
        let imprint : Types.Imprint = {
          id = imprintsCounter;
          createdWhen = Time.now();
          createdBy = caller;
          tags = tags;
          data = data;
        };

        let idsImprint : ?[Nat64] = RBTree.get(imprintIdsByMarkId, Nat64.compare, markId);
        switch idsImprint {
          case (null) {
            imprintIdsByMarkId := RBTree.put(imprintIdsByMarkId, Nat64.compare, markId, [imprintsCounter]);
          };
          case (?idsImprint) {
            var buffer = StableBuffer.fromArray<Nat64>(idsImprint);
            StableBuffer.add(buffer, imprintsCounter);
            imprintIdsByMarkId := RBTree.put(imprintIdsByMarkId, Nat64.compare, markId, StableBuffer.toArray(buffer));
          };
        };
        imprints := RBTree.put(imprints, Nat64.compare, imprintsCounter, imprint);
        return #Ok(imprint);
      };
    };

  };
*/

  /*
    let size1 = array1.size();
    let size2 = array2.size();
    if (size1 != size2) {
      return false
    };
    var i = 0;
    while (i < size1) {
      if (not equal(array1[i], array2[i])) {
        return false
      };
      i += 1
    };
    return true
*/

  public shared ({ caller }) func createImprint(markIds : [Nat64], data : Types.ImprintType, tags : [Text]) : async Types.ImprintResult {

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

    //check doublon in tags
    try {
      let tagsToSet = TrieSet.fromArray(tags, Text.hash, Text.equal);
      let tagsToSetSize = TrieSet.size(tagsToSet);
      if (tagsToSetSize != tags.size()) {
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
      tags = tags;
      data = data;
    };

    // markIdsByImprintId updates
    // choice : allways trust counter to populate or replace over tree structure.
    let (markIdsByImprintIdEntry, markIdsByImprintIdUpdated) = RBTree.replace(markIdsByImprintId, Nat64.compare, imprintsCounter, markIds);
    if (Option.isSome(markIdsByImprintIdEntry)) {
      markIdsByImprintId := markIdsByImprintIdUpdated;
    } else {
      markIdsByImprintId := RBTree.put(markIdsByImprintId, Nat64.compare, imprintsCounter, markIds);
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
          // choice : allways trust counter to populate or replace over tree structure.
          let (imprintIdsByMarkIdIdEntry, imprintIdsByMarkIdUpdated) = RBTree.replace(imprintIdsByMarkId, Nat64.compare, markId, StableBuffer.toArray(buffer));
          if (Option.isSome(imprintIdsByMarkIdIdEntry)) {
            imprintIdsByMarkId := imprintIdsByMarkIdUpdated;
          } else {
            imprintIdsByMarkId := RBTree.put(imprintIdsByMarkId, Nat64.compare, markId, StableBuffer.toArray(buffer));
          };
        };
      };
    };

    // choice : allways trust counter to populate or replace over tree structure.
    let (imprintsEntry, imprintsUpdated) = RBTree.replace(imprints, Nat64.compare, imprintsCounter, imprint);
    if (Option.isSome(imprintsEntry)) {
      imprints := imprintsUpdated;
    } else {
      imprints := RBTree.put(imprints, Nat64.compare, imprintsCounter, imprint);
    };

    return #Ok(imprint);

  };

  public query func balanceOfDip721(user : Principal) : async Nat64 {
    return Nat64.fromNat(
      List.size(
        List.filter(nfts, func(token : Types.Nft) : Bool { token.owner == user }),
      ),
    );
  };

  public query func ownerOfDip721(token_id : Types.TokenId) : async Types.OwnerResult {
    let item = List.find(nfts, func(token : Types.Nft) : Bool { token.id == token_id });
    switch (item) {
      case (null) {
        return #Err(#InvalidTokenId);
      };
      case (?token) {
        return #Ok(token.owner);
      };
    };
  };

  public shared ({ caller }) func safeTransferFromDip721(from : Principal, to : Principal, token_id : Types.TokenId) : async Types.TxReceipt {
    if (to == null_address) {
      return #Err(#ZeroAddress);
    } else {
      return transferFrom(from, to, token_id, caller);
    };
  };

  public shared ({ caller }) func transferFromDip721(from : Principal, to : Principal, token_id : Types.TokenId) : async Types.TxReceipt {
    return transferFrom(from, to, token_id, caller);
  };

  func transferFrom(from : Principal, to : Principal, token_id : Types.TokenId, caller : Principal) : Types.TxReceipt {
    let item = List.find(nfts, func(token : Types.Nft) : Bool { token.id == token_id });
    switch (item) {
      case null {
        return #Err(#InvalidTokenId);
      };
      case (?token) {
        if (
          caller != token.owner,
        ) {
          return #Err(#Unauthorized);
        } else if (Principal.notEqual(from, token.owner)) {
          return #Err(#Other);
        } else {
          nfts := List.map(
            nfts,
            func(item : Types.Nft) : Types.Nft {
              if (item.id == token.id) {
                let update : Types.Nft = {
                  owner = to;
                  id = item.id;
                  metadata = token.metadata;
                };
                return update;
              } else {
                return item;
              };
            },
          );
          transactionId += 1;
          return #Ok(transactionId);
        };
      };
    };
  };

  public query func supportedInterfacesDip721() : async [Types.InterfaceId] {
    return [#TransferNotification, #Burn, #Mint];
  };

  public query func logoDip721() : async Types.LogoResult {
    return logo;
  };

  public query func nameDip721() : async Text {
    return name;
  };

  public query func symbolDip721() : async Text {
    return symbol;
  };

  public query func totalSupplyDip721() : async Nat64 {
    return Nat64.fromNat(
      List.size(nfts),
    );
  };

  public query func getMetadataDip721(token_id : Types.TokenId) : async Types.MetadataResult {
    let item = List.find(nfts, func(token : Types.Nft) : Bool { token.id == token_id });
    switch (item) {
      case null {
        return #Err(#InvalidTokenId);
      };
      case (?token) {
        return #Ok(token.metadata);
      };
    };
  };

  public query func getMaxLimitDip721() : async Nat16 {
    return maxLimit;
  };

  public func getMetadataForUserDip721(user : Principal) : async Types.ExtendedMetadataResult {
    let item = List.find(nfts, func(token : Types.Nft) : Bool { token.owner == user });
    switch (item) {
      case null {
        return #Err(#Other);
      };
      case (?token) {
        return #Ok({
          metadata_desc = token.metadata;
          token_id = token.id;
        });
      };
    };
  };

  public query func getTokenIdsForUserDip721(user : Principal) : async [Types.TokenId] {
    let items = List.filter(nfts, func(token : Types.Nft) : Bool { token.owner == user });
    let tokenIds = List.map(items, func(item : Types.Nft) : Types.TokenId { item.id });
    return List.toArray(tokenIds);
  };
  /*
  public shared ({ caller }) func blessArtwork(caller : Principal, idCreator : Types.SandBlessId, idCollection : Types.SandBlessId, idArtwork : Types.SandBlessId, metadata : Types.MetadataDesc) : async Types.BlessReceipt {

    let artwork : Types.Artwork = {
      certifyBy = caller;
      createdAt = now;
      idCreator = idCreator;
      idCollection = idCollection;
      idArtwork = idArtwork;
      metadata = metadata;
    };

    artworks := List.push(artwork, artworks);

    transactionId += 1;

    return #Ok({
      transactionId = transactionId;
    });
  };


  public query func getBlessedArtwork(idCreator : Types.SandBlessId, idCollection : Types.SandBlessId, idArtwork : Types.SandBlessId) : async Types.MetadataResult {
    let item = List.find(artworks, func(artwork : Types.Artwork) : Bool { artwork.idCreator == idCreator });
    switch (item) {
      case null {
        return #Err(#InvalidArtworkId);
      };
      case (?artwork) {
        return #Ok(artwork.metadata);
      };
    };
  };
  */

  public shared ({ caller }) func mintDip721(to : Principal, metadata : Types.MetadataDesc) : async Types.MintReceipt {

    let newId = Nat64.fromNat(List.size(nfts));
    let nft : Types.Nft = {
      owner = to;
      id = newId;
      metadata = metadata;
    };

    nfts := List.push(nft, nfts);

    transactionId += 1;

    return #Ok({
      token_id = newId;
      id = transactionId;
    });
  };

  public shared query (msg) func whoami() : async Principal {
    return msg.caller;
  };
};
