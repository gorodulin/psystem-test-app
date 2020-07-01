class CreateTransaction

  def self.call(type:, parent: nil, **opts)
    {
      "authorize" => CreateAuthorizeTransaction,
      "charge"    => CreateChargeTransaction,
      "refund"    => CreateRefundTransaction,
      "reversal"  => CreateReversalTransaction,
    }[type]&.call(parent: parent, **opts) \
    || fail(ArgumentError, "unknown type #{type.inspect}")
  end

end
