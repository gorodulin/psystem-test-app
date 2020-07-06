class CreateTransaction
  include Interactor

  def call
    creators = Transaction::SLUGS.map { |k, v| [k, "Create#{v}".constantize] }.to_h # {charge: CreateChargeTransaction, ...}
    creator = creators[context.type] # Choose Create<transactionType> class
    unless creator
      context.fail!(error: { message: "unknown transaction type '#{context.type}'" })
    else
      creator.call(context)
    end
  rescue ActiveRecord::RecordInvalid => e
    context.error = { exception: e, message: "Wrong parameter(s)", kind: :unprocessable_entity,
                      details: context.transaction.errors.messages }
    context.fail!
  rescue ActiveRecord::RecordNotUnique => e
    context.error = { exception: e, message: "Duplicate transaction", kind: :conflict }
    context.fail!
  end

end
