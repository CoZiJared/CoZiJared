# frozen_string_literal: true
require "uri"
require "net/http"

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  def destroy
    sign_out

    redirect_to "/logged_in"
  end

  def logged_in
    uri =
      URI.parse(
        "https://id.twitch.tv/oauth2/token" \
          "?client_id=#{ENV["TWITCH_CLIENT_ID"]}" \
          "&client_secret=#{ENV["TWITCH_CLIENT_SECRET"]}" \
          "&code=#{params[:code]}" \
          "&grant_type=authorization_code" \
          "&redirect_uri=#{ENV["TWITCH_REDIRECT_URI"]}"
      )

    resp = Net::HTTP.post_form(uri, {})

    if resp.code == "200"
      token = JSON.parse(resp.body)["access_token"]

      uri = URI.parse("https://api.twitch.tv/helix/users")
      resp =
        Net::HTTP.get(
          uri,
          {
            "Authorization" => "Bearer #{token}",
            "Client-ID" => ENV["TWITCH_CLIENT_ID"]
          }
        )

      user_email = JSON.parse(resp).dig("data", 0, "email")
      @username = JSON.parse(resp).dig("data", 0, "display_name")

      if user_email
        puts "User email: #{user_email} logged in with Twitch"

        @email = user_email

        user = User.from_twitch(@username, @email)
        flash[:notice] = "Welcome #{@username}!"
        return sign_in_and_redirect user, event: :authentication
      end
    end

    redirect_to "/users/sign_in"
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  # GET /resource/sign_in
  def new
    @login_url =
      "https://id.twitch.tv/oauth2/authorize" \
        "?client_id=#{ENV["TWITCH_CLIENT_ID"]}" \
        "&redirect_uri=#{ENV["TWITCH_REDIRECT_URI"]}" \
        "&response_type=code" \
        "&scope=user:read:email"

    super
  end

  def after_sign_out_path_for(resource)
    root_url
  end
end
