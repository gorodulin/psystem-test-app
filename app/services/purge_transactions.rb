module PurgeTransactions

  # IMPORTANT: some newer records may be deleted as database referral
  # integrity settings doesn't allow to keep orphaned follow-on transactions.
  def self.call(older_than:)
    total = Transaction.count
    AuthorizeTransaction \
      .where(Transaction.arel_table[:created_at].lt(older_than.seconds.ago))
      .delete_all
    puts "Deleted %d record(s)" % (total - Transaction.count)
  end

end
