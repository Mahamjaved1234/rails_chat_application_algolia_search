class ContactMailer < ApplicationMailer

    default from: 'mhmjaved1@gmail.com'

    CONTACT_EMAIL = 'mhmjaved1@gmail.com'
  
    def submission(message)
      @message = message
      mail(to: CONTACT_EMAIL, subject: 'New contact page submission')
    end
end
