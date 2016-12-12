class PaymentRequestExecutionService
    # request_id
    def self.process(request_id:)
      req = CreditCardPaymentAuthorizationRequest.find(request_id)

      api_result = CreditCardPaymentAPIRequest.request!(req)

      unless api_result.success?
        # ..
        req.payment_failure_response(api_result)
        raise BusinessError, 'ほげほげ' # 本当は BisunessError を継承した何かを返す
      end

      # 決済APIの呼び出しが成功したことを記録する
      req.payment_success_update
    end
  end
