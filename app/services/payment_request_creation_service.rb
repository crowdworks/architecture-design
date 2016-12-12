class PaymentRequestCreationService
    def self.process(token_id: , order_id: , user:)
      ActiveRecord::Base.transaction do
        # Orderモデル(ActiveRecord) じゃなくって、 DomainModelの方
        order_entity = OrderEntity.new(order_id)

        # 指定された order と、それに関連する何かが購入可能な状態になっているかチェックする
        satisfied_result = order_entity.purchase_condition_satisfied_check
        unless satisfied_result.satisfied?
          # 購入条件を充足しなかったので何かエラーを返す
          raise BusinessError, 'ほげほげ' # 本当は BisunessError を継承した何かを返す
        end

        # order を購入処理中の状態に変更し、Itemを購入予約する (状態変更できないようにする)
        order_entity.update_payment_process_status

        # items から 合計額を計算する
        amount = order.amout

        # 決済リクエスト作成 (決済リクエストが発行されようとしている事実をDBに一旦記録する)
        req = CreditCardPaymentAuthorizationRequest.create(
          user: user,
          token_id: token_id, # string
          amount: amount      # integer (yen)
        )

        return SomethingResponseWrapper.new(req)
      end
    end
  end
