class OauthsController < ApplicationController
  skip_before_filter :require_login

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    # logger.debug sorcery_fetch_user_hash(provider)

    if @user = login_from(provider)
      flash[:success] = "Logged in from #{provider.titleize}!"
      redirect_to root_path
    else
      begin
        @user = create_from(provider) do |user|
          user = User.setup_oauth_user(provider, user)
        end

        reset_session # protect from session fixation attack
        auto_login(@user)
        if provider.to_s == 'twitter'
          redirect_to '/users/email'
        else
          @user.activate!
          redirect_to root_path, :notice => "Logged in from #{provider.titleize}!"
        end

      rescue
        redirect_to root_path, :alert => "Failed to login from #{provider.titleize}!"
      end
    end
  end

  private

    def auth_params
      params.permit(:code, :provider, :oauth_token, :oauth_verifier)
    end
end

