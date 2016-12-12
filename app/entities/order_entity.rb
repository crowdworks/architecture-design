class OrderEntity
    def intialize(order_id:)
      @order = Order.find(order_id)
      @items = @order.items
    end

    # Orderを決済処理中に変更し、Itemを購入予約する
    def update_payment_process_status
      # ここでは DataBase Transaction を貼らない (Serviceの責務だよ)
      order.update!(status: :processing)
      items.update_all!(status: :reserve)
    end

    private

    attr_reader :order, :items
  end
end
