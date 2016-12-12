class PaymentUpdateServiceHandler
    # インスタンス化しない（状態持たない）
    # 返り値は、オブジェクトを返す (Hash, Array, Model, ... ではない)
    def self.process(form:)
      payment_request_service_result = PaymentRequestCreationService.process(
        token_id: form.token_id,
        order_id: form.order_id,
        user: form.user
      )

      hoge = PaymentRequestExecutionService.process(
        request_id: payment_request_service_result.request_id
      )

      fuga = PaymentProcessService.process(
        request_id: payment_request_service_result.request_id
      )
      # hoge, fuga は成功した結果が入ったオブジェクトが入る
      # 想定された失敗が起きたときは、 BusinessError を継承した例外が飛ぶ（＝エラー）
      # 想定外の失敗が起きたときは、何かの例外が飛ぶ（＝例外→ここではハンドリングせず、システムエラーにする）

      gig_transaction_service_result = GigTransactionCreationService.process(...)

      # 合体させて何かオブジェクトを作る (?)
      PaymentUpdateServiceHandlerResponse.new(
        payment_request_service_result: payment_request_service_result,
        gig_transaction_service_result: gig_transaction_service_result
      )
    rescue BusinessError => e
      # 例外ハンドリングいろいろ
      return PaymentUpdateServiceHandlerResponse.build_error_response(form: form, error: e)
    end

    # ServiceHandler の返り値
    class PaymentUpdateServiceHandlerResponse
      # たぶん↓みたいな振る舞いは持たせたほうが良い気がする
      # ActiveModel っぽい振る舞い
      def success?
      end

      def errors
      end
    end
  end
