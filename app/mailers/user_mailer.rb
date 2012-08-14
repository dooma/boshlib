class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def activation_needed_email(user)
    @user = user
    @url  = activate_user_url(user.activation_token)
    mail(:to => user.email, :subject => "Welcome to My Awesome Site")
  end

  def activation_success_email(user)
    @user = user
    @url = login_url
    mail(:to => user.email, :subject => "Account successfully activated")
  end
end
