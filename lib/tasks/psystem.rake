namespace :psystem do
  namespace :transaction do
    desc "Delete transactions older than one hour"
    task purge: :environment do
      PurgeTransactions.call(older_than: 1.hour)
    end
  end
end
