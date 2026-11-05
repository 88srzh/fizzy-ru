class UserMailer < ApplicationMailer
  def email_change_confirmation(email_address:, token:, user:)
    @token = token
    @user = user
    mail to: email_address, subject: "Подтвердите новый email-адрес"
  end
end
