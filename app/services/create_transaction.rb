class CreateTransaction
  include Interactor

  def call
    creator = "Create#{context.type}".constantize rescue nil # TODO: Refactor. Not safe
    unless creator
      context.fail!(error: ApplicationError::WrongTransactionType.new)
    else
      creator.call(context)
    end
  rescue ActiveRecord::RecordInvalid, ActiveModel::StrictValidationFailed => e
    error = ApplicationError::WrongTransactionParameters.new \
      initial_exception: e,
      details: context.transaction.errors.messages
    context.fail!(error: error)
  rescue ActiveRecord::RecordNotUnique => e
    error = ApplicationError::DuplicateTransaction.new \
      initial_exception: e,
      details: context.transaction.errors.messages
    context.fail!(error: error)
  end

end
