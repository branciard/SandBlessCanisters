export const idlFactory = ({ IDL }) => {
  const ImprintType = IDL.Variant({
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
    'data' : ImprintType,
    'createdBy' : IDL.Principal,
    'tags' : IDL.Vec(IDL.Text),
    'createdWhen' : IDL.Int,
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
    'createImprint' : IDL.Func(
        [IDL.Vec(IDL.Nat64), ImprintType, IDL.Vec(IDL.Text)],
        [ImprintResult],
        [],
      ),
    'createMark' : IDL.Func([], [Mark], []),
    'getImprint' : IDL.Func([IDL.Nat64], [ImprintResult], ['query']),
    'getImprintIdsByMarkId' : IDL.Func(
        [IDL.Nat64],
        [IDL.Opt(IDL.Vec(IDL.Nat64))],
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
    'getMarkIdsByImprintIdTreeSize' : IDL.Func([], [IDL.Nat], ['query']),
    'getMarksTotalCount' : IDL.Func([], [IDL.Nat64], ['query']),
    'getMarksTreeSize' : IDL.Func([], [IDL.Nat], ['query']),
    'isImprintExist' : IDL.Func([IDL.Nat64], [IDL.Bool], ['query']),
    'isMarkExist' : IDL.Func([IDL.Nat64], [IDL.Bool], ['query']),
    'whoami' : IDL.Func([], [IDL.Principal], ['query']),
  });
  return SandBless;
};
export const init = ({ IDL }) => { return []; };
