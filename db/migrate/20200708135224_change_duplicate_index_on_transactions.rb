class ChangeDuplicateIndexOnTransactions < ActiveRecord::Migration[6.0]
  def up
    remove_index  :transactions, [:initial_transaction_id, :type]
    add_index  :transactions, [:initial_transaction_id, :type, :status], unique: true, name: "index_transactions_on_parent_n_type_n_status"
  end

  def down
    remove_index  :transactions, name: "index_transactions_on_parent_n_type_n_status"
    add_index  :transactions, [:initial_transaction_id, :type], unique: true
  end
end
