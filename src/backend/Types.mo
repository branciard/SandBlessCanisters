import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Blob "mo:base/Blob";
import Time "mo:base/Time";
import List "mo:base/List";
import Principal "mo:base/Principal";

module {

  public type ApiError = {
    #Unauthorized;
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

  public type Mark = {
    id : Nat64;
    createdWhen : Int;
    createdBy : Principal;
  };

  public type Imprint = {
    id : Nat64;
    createdWhen : Int;
    createdBy : Principal;
    imprintType : Text;
    imprintData : ImprintData;
  };

  public type ImprintData = {
    #TextContent : Text;
    #BlobContent : Blob;
    #NatContent : Nat;
    #Nat8Content : Nat8;
    #Nat16Content : Nat16;
    #Nat32Content : Nat32;
    #Nat64Content : Nat64;
  };

  public type MarkResult = Result<Mark, ApiError>;

  public type ImprintResult = Result<Imprint, ApiError>;

};
