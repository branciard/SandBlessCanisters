export const idlFactory = ({ IDL }) => {
  const Custodian = IDL.Record({ 'custodianPrincipal' : IDL.Principal });
  const CustodianList = IDL.Vec(Custodian);
  const InitialArgs = IDL.Record({
    'createdBy' : IDL.Principal,
    'custodians' : CustodianList,
  });
  const ImprintData = IDL.Variant({
    'Nat64Content' : IDL.Nat64,
    'Nat32Content' : IDL.Nat32,
    'Nat8Content' : IDL.Nat8,
    'NatContent' : IDL.Nat,
    'Nat16Content' : IDL.Nat16,
    'BlobContent' : IDL.Vec(IDL.Nat8),
    'TextContent' : IDL.Text,
  });
  const Imprint = IDL.Record({
    'id' : IDL.Nat64,
    'createdBy' : IDL.Principal,
    'createdWhen' : IDL.Int,
    'imprintData' : ImprintData,
    'imprintType' : IDL.Nat64,
    'visible' : IDL.Bool,
  });
  const ApiError = IDL.Variant({
    'InvalidMarkId' : IDL.Null,
    'IdDoubloninArray' : IDL.Null,
    'ImprintWithoutMark' : IDL.Null,
    'Unauthorized' : IDL.Null,
    'InvalidImprintId' : IDL.Null,
    'Other' : IDL.Null,
  });
  const ImprintResult = IDL.Variant({ 'Ok' : Imprint, 'Err' : ApiError });
  const Mark = IDL.Record({
    'id' : IDL.Nat64,
    'createdBy' : IDL.Principal,
    'createdWhen' : IDL.Int,
  });
  const MarkResult = IDL.Variant({ 'Ok' : Mark, 'Err' : ApiError });
  const SandBless = IDL.Service({
    'addCustodian' : IDL.Func([IDL.Text], [IDL.Bool], []),
    'createImprint' : IDL.Func(
        [IDL.Vec(IDL.Nat64), IDL.Nat64, ImprintData],
        [ImprintResult],
        [],
      ),
    'createMark' : IDL.Func([], [MarkResult], []),
    'getCustodians' : IDL.Func(
        [],
        [IDL.Vec(IDL.Tuple(IDL.Text, IDL.Bool))],
        ['query'],
      ),
    'getCustodiansTreeSize' : IDL.Func([], [IDL.Nat], ['query']),
    'getImprint' : IDL.Func([IDL.Nat64], [ImprintResult], ['query']),
    'getImprintIdsByMarkId' : IDL.Func(
        [IDL.Nat64],
        [IDL.Opt(IDL.Vec(IDL.Nat64))],
        ['query'],
      ),
    'getImprintIdsByMarkIdTree' : IDL.Func(
        [],
        [IDL.Vec(IDL.Tuple(IDL.Nat64, IDL.Vec(IDL.Nat64)))],
        ['query'],
      ),
    'getImprintIdsByMarkIdTreeSize' : IDL.Func([], [IDL.Nat], ['query']),
    'getImprintsTotalCount' : IDL.Func([], [IDL.Nat64], ['query']),
    'getImprintsTreeSize' : IDL.Func([], [IDL.Nat], ['query']),
    'getMark' : IDL.Func([IDL.Nat64], [MarkResult], ['query']),
    'getMarkIdsByImprintId' : IDL.Func(
        [IDL.Nat64],
        [IDL.Opt(IDL.Vec(IDL.Nat64))],
        ['query'],
      ),
    'getMarkIdsByImprintIdTree' : IDL.Func(
        [],
        [IDL.Vec(IDL.Tuple(IDL.Nat64, IDL.Vec(IDL.Nat64)))],
        ['query'],
      ),
    'getMarkIdsByImprintIdTreeSize' : IDL.Func([], [IDL.Nat], ['query']),
    'getMarksTotalCount' : IDL.Func([], [IDL.Nat64], ['query']),
    'getMarksTreeSize' : IDL.Func([], [IDL.Nat], ['query']),
    'isCustodian' : IDL.Func([IDL.Text], [IDL.Bool], ['query']),
    'isImprintExist' : IDL.Func([IDL.Nat64], [IDL.Bool], ['query']),
    'isMarkExist' : IDL.Func([IDL.Nat64], [IDL.Bool], ['query']),
    'isPrincipalCustodian' : IDL.Func([IDL.Principal], [IDL.Bool], ['query']),
    'removeCustodian' : IDL.Func([IDL.Text], [IDL.Bool], []),
    'setImprintInvisible' : IDL.Func([IDL.Nat64], [ImprintResult], []),
    'setImprintVisible' : IDL.Func([IDL.Nat64], [ImprintResult], []),
    'whoami' : IDL.Func([], [IDL.Principal], ['query']),
    'whoamiTextformat' : IDL.Func([], [IDL.Text], ['query']),
  });
  return SandBless;
};
export const init = ({ IDL }) => {
  const Custodian = IDL.Record({ 'custodianPrincipal' : IDL.Principal });
  const CustodianList = IDL.Vec(Custodian);
  const InitialArgs = IDL.Record({
    'createdBy' : IDL.Principal,
    'custodians' : CustodianList,
  });
  return [InitialArgs];
};
