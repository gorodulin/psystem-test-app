class CreateTransactions < ActiveRecord::Migration[6.0]

  def up
    create_table :transactions, id: false do |t|
      t.uuid    :id, null: false #, default: "gen_random_uuid()"
      #t.uuid    :uuid, null: false
      #t.uuid    :initial_transaction_id, null: false
      t.string  :type, null: false
      t.belongs_to :merchant, foreign_key: true, null: false, on_delete: :restrict
      t.integer :amount, null: true, default: nil
      t.string  :customer_email, null: false
      t.string  :customer_phone, null: false
    end
    execute %Q{ALTER TABLE transactions ADD PRIMARY KEY ("id");}
    change_table :transactions do |t|
      t.belongs_to :initial_transaction, type: :uuid, null: false, foreign_key: { to_table: "transactions", on_delete: :cascade, validate: true }
    end
    execute %Q{CREATE TYPE transaction_status AS ENUM ('approved', 'reversed', 'refunded', 'error');}
    add_column :transactions, :status, :transaction_status, null: false
    add_index  :transactions, :status
    add_column :transactions, :created_at, :datetime, null: false
    add_column :transactions, :updated_at, :datetime, null: false
    add_index  :transactions, [:initial_transaction_id, :type], unique: true
  end

  def down
    remove_column :transactions, :status
    execute %Q{DROP TYPE IF EXISTS transaction_status}
    drop_table :transactions
  end

end
