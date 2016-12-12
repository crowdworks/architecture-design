class PaymentsController < ApplicationController
  def update
    form = PaymentRequestForm.new(
      params: params,
      cookies: cookies,
      session: session,
      user: current_user,
    )
    unless form.valid?
      render and return
    end

    object = PaymentUpdateServiceHandler.process(form)
    rendering(object)
  end
end
