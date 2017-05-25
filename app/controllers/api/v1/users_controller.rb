class Api::V1::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_user, only: [:show, :update]

  def create
    begin
      User.create(user_params)

      render json: { result: 'User Created Successfully'}, status: :ok
    rescue => e
      render json: { result: 'Invalid params'}, status: :bad_request
    end
  end

  def index
    @users = User.all
    render json: @users.to_json(only: [:name, :age, :average, :role, :status, :matches, :team_id])
  end

  def show
    render json: @team.to_json(only: [:name, :age, :average, :role, :status, :matches, :team_id])
  end

  def update
  end

  private

    def set_user
      @user = User.find_by_id(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :age, :average, :role, :status, :matches, :team_id)
    end
end
