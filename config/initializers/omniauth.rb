Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['CODEZIT_GITHUB_KEY'], ENV['CODEZIT_GITHUB_SECRET'], scope: "gist"
end
