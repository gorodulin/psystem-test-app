FactoryBot.define do
  factory :transaction do
    merchant
    id { SecureRandom.uuid }
    amount { Faker::Number.decimal(l_digits: 2) }
    status { "error" }
    customer_email { Faker::Internet.email }
    customer_phone { Faker::PhoneNumber.cell_phone_in_e164 }
  end

  factory :authorize_transaction do
    merchant
    id { SecureRandom.uuid }
    amount { 1 }
    status { :approved }
    customer_email { "a@b.c" }
    customer_phone { "+1234567890" }
  end

  factory :charge_transaction do
    id { SecureRandom.uuid }
    authorize_transaction
    merchant { authorize_transaction.merchant }
    amount { 1 }
    status { :approved }
    customer_email { authorize_transaction.customer_email }
    customer_phone { authorize_transaction.customer_phone }
  end

  factory :refund_transaction do
    id { SecureRandom.uuid }
    charge_transaction
    merchant { charge_transaction.merchant }
    amount { charge_transaction.amount }
    status { :approved }
    customer_email { charge_transaction.customer_email }
    customer_phone { charge_transaction.customer_phone }
  end

  factory :reversal_transaction do
    id { SecureRandom.uuid }
    authorize_transaction
    merchant { authorize_transaction.merchant }
    amount { nil }
    status { :approved }
    customer_email { authorize_transaction.customer_email }
    customer_phone { authorize_transaction.customer_phone }
  end
end
