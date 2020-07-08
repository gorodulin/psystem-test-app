class CreateTransaction
  include Interactor

  def call
    creator = "Create#{context.type}".constantize rescue nil # TODO: Refactor. Not safe
    unless creator
      context.fail!(error: { message: "wrong transaction type '#{context.type}'" })
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
