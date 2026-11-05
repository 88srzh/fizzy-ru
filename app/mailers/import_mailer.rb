class ImportMailer < ApplicationMailer
  def completed(identity, account)
    @account = account
    mail to: identity.email_address, subject: "Импорт вашего аккаунта Fizzy завершён"
  end

  def failed(import)
    @import = import
    mail to: import.identity.email_address, subject: "Импорт вашего аккаунта Fizzy не удался"
  end
end
