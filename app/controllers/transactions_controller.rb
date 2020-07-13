class TransactionsController < ApplicationController
  # GET /transactions
  def index
    @transactions = Transaction.all
  end
end
