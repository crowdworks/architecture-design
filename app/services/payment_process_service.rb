class PaymentProcessService
    def self.process(request_id:)
      req = CreditCardPaymentAuthorizationRequest.find(request_id)

      ActiveRecord::Base do
        # いろいろやる。
        credit_card_payment = req.credit_card_payment
        credit_card_payment.update!(status: :escrow)
        #
        payment.update!(status: :escrow)
        #
        order.update!(status: :escrow)
      end

      # Orderが成功したことの通知をする
      Publisher::OrderSuccess.process(order)
      # publisherができるまでは↓みたいなノリ
      UserMailer.order_success(order)
      AdminMailer.order_success(order)
      Notification.order_success(order)
      PushNotification.order_success(order)
    end
  end
