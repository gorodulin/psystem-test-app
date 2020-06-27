class AuthorizeTransaction < Transaction

  enum status: { approved: "approved", reversed: "reversed" }, _prefix: "status"

  before_save do
    # This allows to validate at DB-level (via uniq index)
    # that every record has not more than one child record of a particular type
    self.initial_transaction_uuid = self.uuid
  end

end
