import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export type ApiError = { 'InvalidMarkId' : null } |
  { 'IdDoubloninArray' : null } |
  { 'ImprintWithoutMark' : null } |
  { 'Unauthorized' : null } |
  { 'InvalidImprintId' : null } |
  { 'Other' : null };
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
export interface Mark {
  'id' : bigint,
  'createdBy' : Principal,
  'createdWhen' : bigint,
}
export type MarkResult = { 'Ok' : Mark } |
  { 'Err' : ApiError };
export interface SandBless {
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
  'isImprintExist' : ActorMethod<[bigint], boolean>,
  'isMarkExist' : ActorMethod<[bigint], boolean>,
  'whoami' : ActorMethod<[], Principal>,
}
export interface _SERVICE extends SandBless {}
