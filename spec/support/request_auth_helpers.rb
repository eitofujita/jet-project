module RequestAuthHelpers
  def sign_in(user, password: "password123")
    post login_path, params: { email: user.email, password: password }
  end
end

RSpec.configure do |config|
  config.include RequestAuthHelpers, type: :request
end
