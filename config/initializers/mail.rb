ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.mandrillapp.com',
  :port           => '587',
  :authentication => :plain,
  :user_name      => ENV["MANDRILL_USERNAME"],
  :password       => ENV["MANDRILL_PASSWORD"]#,
  #:domain         => 'heroku.com'
}
ActionMailer::Base.delivery_method = :smtp