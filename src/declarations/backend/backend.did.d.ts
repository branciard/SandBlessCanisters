import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export type ApiError = { 'InvalidMarkId' : null } |
  { 'IdDoubloninArray' : null } |
  { 'ImprintWithoutMark' : null } |
  { 'Unauthorized' : null } |
  { 'InvalidImprintId' : null } |
  { 'Other' : null };
export interface Custodian { 'custodianPrincipal' : Principal }
export type CustodianList = Array<Custodian>;
export interface Imprint {
  'id' : bigint,
  'createdBy' : Principal,
  'createdWhen' : bigint,
  'imprintData' : ImprintData,
  'imprintType' : bigint,
  'visible' : boolean,
}
export type ImprintData = { 'Nat64Content' : bigint } |
  { 'Nat32Content' : number } |
  { 'Nat8Content' : number } |
  { 'NatContent' : bigint } |
  { 'Nat16Content' : number } |
  { 'BlobContent' : Uint8Array } |
  { 'TextContent' : string };
export type ImprintResult = { 'Ok' : Imprint } |
  { 'Err' : ApiError };
export interface InitialArgs {
  'createdBy' : Principal,
  'custodians' : CustodianList,
}
export interface Mark {
  'id' : bigint,
  'createdBy' : Principal,
  'createdWhen' : bigint,
}
export type MarkResult = { 'Ok' : Mark } |
  { 'Err' : ApiError };
export interface SandBless {
  'addCustodian' : ActorMethod<[string], boolean>,
  'createImprint' : ActorMethod<
    [BigUint64Array, bigint, ImprintData],
    ImprintResult
  >,
  'createMark' : ActorMethod<[], MarkResult>,
  'getCustodians' : ActorMethod<[], Array<[string, boolean]>>,
  'getCustodiansTreeSize' : ActorMethod<[], bigint>,
  'getImprint' : ActorMethod<[bigint], ImprintResult>,
  'getImprintIdsByMarkId' : ActorMethod<[bigint], [] | [BigUint64Array]>,
  'getImprintIdsByMarkIdTree' : ActorMethod<
    [],
    Array<[bigint, BigUint64Array]>
  >,
  'getImprintIdsByMarkIdTreeSize' : ActorMethod<[], bigint>,
  'getImprintsTotalCount' : ActorMethod<[], bigint>,
  'getImprintsTreeSize' : ActorMethod<[], bigint>,
  'getMark' : ActorMethod<[bigint], MarkResult>,
  'getMarkIdsByImprintId' : ActorMethod<[bigint], [] | [BigUint64Array]>,
  'getMarkIdsByImprintIdTree' : ActorMethod<
    [],
    Array<[bigint, BigUint64Array]>
  >,
  'getMarkIdsByImprintIdTreeSize' : ActorMethod<[], bigint>,
  'getMarksTotalCount' : ActorMethod<[], bigint>,
  'getMarksTreeSize' : ActorMethod<[], bigint>,
  'isCustodian' : ActorMethod<[string], boolean>,
  'isImprintExist' : ActorMethod<[bigint], boolean>,
  'isMarkExist' : ActorMethod<[bigint], boolean>,
  'isPrincipalCustodian' : ActorMethod<[Principal], boolean>,
  'purgeCanister' : ActorMethod<[], boolean>,
  'removeCustodian' : ActorMethod<[string], boolean>,
  'setImprintInvisible' : ActorMethod<[bigint], ImprintResult>,
  'setImprintVisible' : ActorMethod<[bigint], ImprintResult>,
  'whoami' : ActorMethod<[], Principal>,
  'whoamiTextformat' : ActorMethod<[], string>,
}
export interface _SERVICE extends SandBless {}
