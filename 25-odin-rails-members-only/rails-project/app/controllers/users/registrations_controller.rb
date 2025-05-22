class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |user|
      if user.persisted?
        UserMailer.with(user: user).welcome_email.deliver_later
      end
    end
  end
end
