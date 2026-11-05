class AccountMailer < ApplicationMailer
  def cancellation(cancellation)
    @account = cancellation.account
    @user = cancellation.initiated_by

    mail(
      to: @user.identity.email_address,
      subject: "Ваш аккаунт Fizzy был отменён"
    )
  end
end
