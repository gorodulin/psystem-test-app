require "csv"

# ","-separated CSV file without headers row.
#
# Columns:
# - Id (integer or empty)
# - Full Name (string)
# - Email (a@b.c string)
# - is admin? ('admin' string or empty field)
# - is merchant? ('merchant' string or empty field)
# - Merchant status (values other than 'active' will be treated as inactive)
# - Merchant description (string)

# NOTE: this code does NOT update existing records

module ImportUsersFromCsv

  def self.call(filepath)
    file = File.open(filepath)
    columns = %i{id name email is_admin is_merchant status description}
    CSV.parse(file, headers: false, col_sep: ",").each do |row|
      columns.zip(row).to_h.tap do |row|
        row[:is_admin] = row[:is_admin].eql?("admin")
        user = User.find_or_create_by(id: row[:id]) do |record|
          record.assign_attributes(row.slice(:id, :name, :email, :is_admin))
        end
        next unless user&.persisted? && row[:is_merchant] == "merchant"
        merchant = Merchant.find_or_create_by(user: user) do |record|
          record.assign_attributes(row.slice(:name, :email, :description))
          record.status = row[:status].eql?("active") ? "active" : "inactive"
        end
      end
    end
  ensure
    file.close if file.is_a? File
  end

end
