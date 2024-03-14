class SessionsController < ApplicationController
  before_action :load_user, only: :create
  before_action :authenticate_user, only: :create

  def new; end

  def create
    forwarding_url = session[:forwarding_url]
    reset_session
    log_in @user
    params.dig(:session, :remember_me) == "1" ? remember(@user) : forget(@user)
    redirect_to forwarding_url || @user
  end

  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end

  private

  def load_user
    @user = User.find_by email: params.dig(:session, :email)&.downcase
    return if @user

    flash.now[:danger] = t("errors.user_not_found")
    render :new, status: :unprocessable_entity
  end

  def authenticate_user
    return if @user.authenticate(params.dig(:session, :password))

    flash.now[:danger] = t("errors.invalid_email_password_combination")
    render :new, status: :unprocessable_entity
  end
end
