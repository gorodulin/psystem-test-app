class CreateMerchants < ActiveRecord::Migration[6.0]

  def up
    create_table :merchants do |t|
      t.belongs_to :user, foreign_key: true, null: false, on_delete: :restrict
      t.string  :name, null: false
      t.string  :description, null: false
      t.string  :email, null: false
      t.integer :total_transaction_sum, null: false, default: 0
    end
    execute %Q{CREATE TYPE merchant_status AS ENUM ('active', 'inactive');}
    add_column :merchants, :status, :merchant_status, default: 'inactive', null: false
    add_index  :merchants, :status
    add_column :merchants, :created_at, :datetime, null: false
    add_column :merchants, :updated_at, :datetime, null: false
  end

  def down
    remove_column :merchants, :status
    execute %Q{DROP TYPE IF EXISTS merchant_status}
    drop_table :merchants
  end

end
