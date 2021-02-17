# frozen_string_literal: true

module Dashboard
  class UsersController < Dashboard::DashboardController
    before_action :user_set, only: %i[show edit update destroy]

    def index
      @users = User.all.page(params[:page])
    end

    def show; end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to [:dashboard, @user], notice: t('.created')
      else
        render :new
      end
    end

    def edit; end

    def update
      if @user.update(user_params)
        redirect_to [:dashboard, @user], notice: t('.updated')
      else
        render :edit
      end
    end

    def destroy
      if @user == current_user
        redirect_to %i[dashboard users], error: t('.current_user')
      else
        @user.destroy!
        redirect_to %i[dashboard users], notice: t('.destroyed')
      end
    end

    private

    def user_set
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  end
end
