module Devise
  module ControllerMacros
    def login_admin
      let(:user) { FactoryGirl.create(:admin) }
      login
    end

    def login_user
      let(:user) { FactoryGirl.create(:user) }
      login
    end

    def login
      before(:each) do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        @request.env["omniauth.auth"] = ::OmniAuth.config.mock_auth[:github]
        @current_user = user
        sign_in @current_user
        @request.host = "#{user.account.name.parameterize}.test.host"
      end
    end
  end
end
