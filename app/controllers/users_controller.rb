class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  # before_filter :require_login, only: [:email, :submit_email]
  authorize_resource

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end


  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        auto_login(@user)
        format.html { redirect_to root_path, notice: 'Welcome! You have signed up successfuly.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def activate
    if (@user = User.load_from_activation_token(params[:id]))
      @user.activate!
      redirect_to login_path, :notice => 'User was successfully activated.'
    else
      not_authenticated
    end
  end

  def email
    @user = current_user
    @user.email = ''
  end

  def submit_email
    current_user.update_attribute(:email, user_email_params[:email])
    UserMailer.activation_needed_email(current_user).deliver
    redirect_to root_path, :notice => 'Email was successfuly updated'
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_email_params
      params.require(:user).permit(:email)
    end

    def user_params
      params.require(:user).permit(:email, :screen_name, :password, :password_confirmation, :avatar)
    end
end
