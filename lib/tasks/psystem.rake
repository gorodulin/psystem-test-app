namespace :psystem do
  namespace :transaction do
    desc "Delete transactions older than one hour"
    task purge: :environment do
      deleted = PurgeTransactions.call(older_than: 1.hour)
      puts "Deleted %d record(s)" % deleted
    end
  end

  namespace :users do
    desc "Import users from CSV file"
    task csv_import: :environment do |t|
      unless ARGV[1].blank?
        ImportUsersFromCsv.call(ARGV[1])
      else
        puts "Usage example:"
        puts "  rake #{t.name} <CSV_FILE_PATH>"
      end
    end
  end
end
