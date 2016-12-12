class PaymentRequestForm
  include ActiveModel::Model

  def items
    [Item.new(...), Item.new(...)]
  end

  class Item < Struct.new(:id, :number)
  end
end
