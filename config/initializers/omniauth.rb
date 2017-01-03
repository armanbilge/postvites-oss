OmniAuth.config.full_host = Rails.env.production? ? ENV['PROTOCOL'] + '://' + ENV['HOSTNAME'] : 'http://localhost:3000'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'],
    {
      name: 'google',
      prompt: 'select_account',
      access_type: 'online'
    }
end
