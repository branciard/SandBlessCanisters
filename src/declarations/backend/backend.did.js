export const idlFactory = ({ IDL }) => {
  const LogoResult = IDL.Record({ 'data' : IDL.Text, 'logo_type' : IDL.Text });
  const Dip721NonFungibleToken = IDL.Record({
    'maxLimit' : IDL.Nat16,
    'logo' : LogoResult,
    'name' : IDL.Text,
    'symbol' : IDL.Text,
  });
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
    'ZeroAddress' : IDL.Null,
    'InvalidArtworkId' : IDL.Null,
    'ImprintWithoutMark' : IDL.Null,
    'InvalidTokenId' : IDL.Null,
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
  const TokenId = IDL.Nat64;
  const MetadataVal = IDL.Variant({
    'Nat64Content' : IDL.Nat64,
    'Nat32Content' : IDL.Nat32,
    'Nat8Content' : IDL.Nat8,
    'NatContent' : IDL.Nat,
    'Nat16Content' : IDL.Nat16,
    'BlobContent' : IDL.Vec(IDL.Nat8),
    'TextContent' : IDL.Text,
  });
  const MetadataKeyVal = IDL.Record({ 'key' : IDL.Text, 'val' : MetadataVal });
  const MetadataPurpose = IDL.Variant({
    'Preview' : IDL.Null,
    'Rendered' : IDL.Null,
  });
  const MetadataPart = IDL.Record({
    'data' : IDL.Vec(IDL.Nat8),
    'key_val_data' : IDL.Vec(MetadataKeyVal),
    'purpose' : MetadataPurpose,
  });
  const MetadataDesc = IDL.Vec(MetadataPart);
  const MetadataResult = IDL.Variant({ 'Ok' : MetadataDesc, 'Err' : ApiError });
  const ExtendedMetadataResult = IDL.Variant({
    'Ok' : IDL.Record({ 'token_id' : TokenId, 'metadata_desc' : MetadataDesc }),
    'Err' : ApiError,
  });
  const MintReceiptPart = IDL.Record({ 'id' : IDL.Nat, 'token_id' : TokenId });
  const MintReceipt = IDL.Variant({ 'Ok' : MintReceiptPart, 'Err' : ApiError });
  const OwnerResult = IDL.Variant({ 'Ok' : IDL.Principal, 'Err' : ApiError });
  const TxReceipt = IDL.Variant({ 'Ok' : IDL.Nat, 'Err' : ApiError });
  const InterfaceId = IDL.Variant({
    'Burn' : IDL.Null,
    'Mint' : IDL.Null,
    'Approval' : IDL.Null,
    'TransactionHistory' : IDL.Null,
    'TransferNotification' : IDL.Null,
  });
  const SandBlessDip721NFT = IDL.Service({
    'balanceOfDip721' : IDL.Func([IDL.Principal], [IDL.Nat64], ['query']),
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
    'getMaxLimitDip721' : IDL.Func([], [IDL.Nat16], ['query']),
    'getMetadataDip721' : IDL.Func([TokenId], [MetadataResult], ['query']),
    'getMetadataForUserDip721' : IDL.Func(
        [IDL.Principal],
        [ExtendedMetadataResult],
        [],
      ),
    'getTokenIdsForUserDip721' : IDL.Func(
        [IDL.Principal],
        [IDL.Vec(TokenId)],
        ['query'],
      ),
    'isImprintExist' : IDL.Func([IDL.Nat64], [IDL.Bool], ['query']),
    'isMarkExist' : IDL.Func([IDL.Nat64], [IDL.Bool], ['query']),
    'logoDip721' : IDL.Func([], [LogoResult], ['query']),
    'mintDip721' : IDL.Func([IDL.Principal, MetadataDesc], [MintReceipt], []),
    'nameDip721' : IDL.Func([], [IDL.Text], ['query']),
    'ownerOfDip721' : IDL.Func([TokenId], [OwnerResult], ['query']),
    'safeTransferFromDip721' : IDL.Func(
        [IDL.Principal, IDL.Principal, TokenId],
        [TxReceipt],
        [],
      ),
    'supportedInterfacesDip721' : IDL.Func(
        [],
        [IDL.Vec(InterfaceId)],
        ['query'],
      ),
    'symbolDip721' : IDL.Func([], [IDL.Text], ['query']),
    'totalSupplyDip721' : IDL.Func([], [IDL.Nat64], ['query']),
    'transferFromDip721' : IDL.Func(
        [IDL.Principal, IDL.Principal, TokenId],
        [TxReceipt],
        [],
      ),
    'whoami' : IDL.Func([], [IDL.Principal], ['query']),
  });
  return SandBlessDip721NFT;
};
export const init = ({ IDL }) => {
  const LogoResult = IDL.Record({ 'data' : IDL.Text, 'logo_type' : IDL.Text });
  const Dip721NonFungibleToken = IDL.Record({
    'maxLimit' : IDL.Nat16,
    'logo' : LogoResult,
    'name' : IDL.Text,
    'symbol' : IDL.Text,
  });
  return [Dip721NonFungibleToken];
};
