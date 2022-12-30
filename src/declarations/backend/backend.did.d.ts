import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export type ApiError = { 'InvalidMarkId' : null } |
  { 'IdDoubloninArray' : null } |
  { 'ZeroAddress' : null } |
  { 'InvalidArtworkId' : null } |
  { 'ImprintWithoutMark' : null } |
  { 'InvalidTokenId' : null } |
  { 'Unauthorized' : null } |
  { 'InvalidImprintId' : null } |
  { 'Other' : null };
export interface Dip721NonFungibleToken {
  'maxLimit' : number,
  'logo' : LogoResult,
  'name' : string,
  'symbol' : string,
}
export type ExtendedMetadataResult = {
    'Ok' : { 'token_id' : TokenId, 'metadata_desc' : MetadataDesc }
  } |
  { 'Err' : ApiError };
export interface Imprint {
  'id' : bigint,
  'data' : ImprintType,
  'createdBy' : Principal,
  'tags' : Array<string>,
  'createdWhen' : bigint,
}
export type ImprintResult = { 'Ok' : Imprint } |
  { 'Err' : ApiError };
export type ImprintType = { 'Nat64Content' : bigint } |
  { 'Nat32Content' : number } |
  { 'Nat8Content' : number } |
  { 'NatContent' : bigint } |
  { 'Nat16Content' : number } |
  { 'BlobContent' : Uint8Array } |
  { 'TextContent' : string };
export type InterfaceId = { 'Burn' : null } |
  { 'Mint' : null } |
  { 'Approval' : null } |
  { 'TransactionHistory' : null } |
  { 'TransferNotification' : null };
export interface LogoResult { 'data' : string, 'logo_type' : string }
export interface Mark {
  'id' : bigint,
  'createdBy' : Principal,
  'createdWhen' : bigint,
}
export type MarkResult = { 'Ok' : Mark } |
  { 'Err' : ApiError };
export type MetadataDesc = Array<MetadataPart>;
export interface MetadataKeyVal { 'key' : string, 'val' : MetadataVal }
export interface MetadataPart {
  'data' : Uint8Array,
  'key_val_data' : Array<MetadataKeyVal>,
  'purpose' : MetadataPurpose,
}
export type MetadataPurpose = { 'Preview' : null } |
  { 'Rendered' : null };
export type MetadataResult = { 'Ok' : MetadataDesc } |
  { 'Err' : ApiError };
export type MetadataVal = { 'Nat64Content' : bigint } |
  { 'Nat32Content' : number } |
  { 'Nat8Content' : number } |
  { 'NatContent' : bigint } |
  { 'Nat16Content' : number } |
  { 'BlobContent' : Uint8Array } |
  { 'TextContent' : string };
export type MintReceipt = { 'Ok' : MintReceiptPart } |
  { 'Err' : ApiError };
export interface MintReceiptPart { 'id' : bigint, 'token_id' : TokenId }
export type OwnerResult = { 'Ok' : Principal } |
  { 'Err' : ApiError };
export interface SandBlessDip721NFT {
  'balanceOfDip721' : ActorMethod<[Principal], bigint>,
  'createImprint' : ActorMethod<
    [BigUint64Array, ImprintType, Array<string>],
    ImprintResult
  >,
  'createMark' : ActorMethod<[], Mark>,
  'getImprint' : ActorMethod<[bigint], ImprintResult>,
  'getImprintIdsByMarkId' : ActorMethod<[bigint], [] | [BigUint64Array]>,
  'getImprintIdsByMarkIdTreeSize' : ActorMethod<[], bigint>,
  'getImprintsTotalCount' : ActorMethod<[], bigint>,
  'getImprintsTreeSize' : ActorMethod<[], bigint>,
  'getMark' : ActorMethod<[bigint], MarkResult>,
  'getMarkIdsByImprintId' : ActorMethod<[bigint], [] | [BigUint64Array]>,
  'getMarkIdsByImprintIdTreeSize' : ActorMethod<[], bigint>,
  'getMarksTotalCount' : ActorMethod<[], bigint>,
  'getMarksTreeSize' : ActorMethod<[], bigint>,
  'getMaxLimitDip721' : ActorMethod<[], number>,
  'getMetadataDip721' : ActorMethod<[TokenId], MetadataResult>,
  'getMetadataForUserDip721' : ActorMethod<[Principal], ExtendedMetadataResult>,
  'getTokenIdsForUserDip721' : ActorMethod<[Principal], BigUint64Array>,
  'isImprintExist' : ActorMethod<[bigint], boolean>,
  'isMarkExist' : ActorMethod<[bigint], boolean>,
  'logoDip721' : ActorMethod<[], LogoResult>,
  'mintDip721' : ActorMethod<[Principal, MetadataDesc], MintReceipt>,
  'nameDip721' : ActorMethod<[], string>,
  'ownerOfDip721' : ActorMethod<[TokenId], OwnerResult>,
  'safeTransferFromDip721' : ActorMethod<
    [Principal, Principal, TokenId],
    TxReceipt
  >,
  'supportedInterfacesDip721' : ActorMethod<[], Array<InterfaceId>>,
  'symbolDip721' : ActorMethod<[], string>,
  'totalSupplyDip721' : ActorMethod<[], bigint>,
  'transferFromDip721' : ActorMethod<
    [Principal, Principal, TokenId],
    TxReceipt
  >,
  'whoami' : ActorMethod<[], Principal>,
}
export type TokenId = bigint;
export type TxReceipt = { 'Ok' : bigint } |
  { 'Err' : ApiError };
export interface _SERVICE extends SandBlessDip721NFT {}
