import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Blob "mo:base/Blob";
import Time "mo:base/Time";
import List "mo:base/List";
//import Buffer "mo:stable-buffer/StableBuffer";

import Principal "mo:base/Principal";

module {

  public type Artwork = {
    certifyBy : Principal;
    createdAt : Nat64;
    idCreatorId : Nat64;
    idCollection : Nat64;
    idArtwork : Nat64;
    metadata : MetadataDesc;
  };

  public type Dip721NonFungibleToken = {
    logo : LogoResult;
    name : Text;
    symbol : Text;
    maxLimit : Nat16;
  };

  public type ApiError = {
    #Unauthorized;
    #InvalidTokenId;
    #InvalidArtworkId;
    #ZeroAddress;
    #ImprintWithoutMark;
    #InvalidMarkId;
    #IdDoubloninArray;
    #InvalidImprintId;
    #Other;
  };

  public type Result<S, E> = {
    #Ok : S;
    #Err : E;
  };

  public type OwnerResult = Result<Principal, ApiError>;
  public type TxReceipt = Result<Nat, ApiError>;

  public type TransactionId = Nat;
  public type TokenId = Nat64;

  public type InterfaceId = {
    #Approval;
    #TransactionHistory;
    #Mint;
    #Burn;
    #TransferNotification;
  };

  public type LogoResult = {
    logo_type : Text;
    data : Text;
  };

  public type Nft = {
    owner : Principal;
    id : TokenId;
    metadata : MetadataDesc;
  };

  public type Mark = {
    id : Nat64;
    createdWhen : Int;
    createdBy : Principal;
  };

  public type Imprint = {
    id : Nat64;
    createdWhen : Int;
    createdBy : Principal;
    tags : [Text];
    data : ImprintType;
  };

  public type ImprintType = {
    #TextContent : Text;
    #BlobContent : Blob;
    #NatContent : Nat;
    #Nat8Content : Nat8;
    #Nat16Content : Nat16;
    #Nat32Content : Nat32;
    #Nat64Content : Nat64;
  };

  public type MetadataMark = [MetadataMarkValue];

  public type MetadataMarkValue = {
    key : Text;
    value : ImprintType;
  };

  public type ExtendedMetadataResult = Result<{ metadata_desc : MetadataDesc; token_id : TokenId }, ApiError>;

  public type MetadataMarkResult = Result<MetadataMark, ApiError>;

  public type MarkResult = Result<Mark, ApiError>;

  public type ImprintResult = Result<Imprint, ApiError>;

  public type MetadataResult = Result<MetadataDesc, ApiError>;

  public type MetadataDesc = [MetadataPart];

  public type MetadataPart = {
    purpose : MetadataPurpose;
    key_val_data : [MetadataKeyVal];
    data : Blob;
  };

  public type MetadataPurpose = {
    #Preview;
    #Rendered;
  };

  public type MetadataKeyVal = {
    key : Text;
    val : MetadataVal;
  };

  public type MetadataVal = {
    #TextContent : Text;
    #BlobContent : Blob;
    #NatContent : Nat;
    #Nat8Content : Nat8;
    #Nat16Content : Nat16;
    #Nat32Content : Nat32;
    #Nat64Content : Nat64;
  };

  public type MintReceipt = Result<MintReceiptPart, ApiError>;

  public type MintReceiptPart = {
    token_id : TokenId;
    id : Nat;
  };

  public type BlessReceipt = Result<BlessReceiptPart, ApiError>;

  public type BlessReceiptPart = {
    transactionId : Nat;
  };

};
