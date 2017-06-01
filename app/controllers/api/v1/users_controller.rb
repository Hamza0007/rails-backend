class Api::V1::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :validate_user
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :set_team, only: :update

  def create
    @user = User.new(user_params)
    @user.team_id = user_params['team_id'].blank? ? nil : user_params['team_id'].to_i
    if @user.save(validate: false)
      return render json: { result: 'User Created Successfully'}, status: :ok
    else
      render json: { result: 'Invalid params', errors: @user.errors}, status: :bad_request
    end
  end

  def index
    @users = User.player.uniq
    render json: @users, include: { team: {only: [:id, :name, :country]}}, except: [:created_at, :updated_at]
  end

  def show
    render json: @users, include: { team: {only: [:id, :name, :country]}}, except: [:created_at, :updated_at]
  end

  def update
    @user.assign_attributes(user_params)
    if @user.save(validate: false)
      return render json: { result: 'User Updated Successfully'}, status: :ok
    else
      render json: { result: 'Invalid params', errors: @user.errors}, status: :bad_request
    end
  end

  def destroy
    if @user.destroy
      render json: { result: 'User Deleted Successfully'}, status: :ok
    else
      render json: { result: 'Invalid params'}, status: :bad_request
    end
  end

  private

    def set_user
      @user = User.find_by_id(params[:id])
    end

    def user_params
      params.permit(:name, :age, :average, :matches, :team_id, :image)
    end

    def set_team
      @user.team_id = user_params['team_id'].blank? ? nil : user_params['team_id'].to_i
    end

    def validate_user
      @user = User.find_by_email(request.headers['HTTP_UID'])
      return render json: { result: 'Invalid user'}, status: :unauthorized if @user.blank? || @user.tokens[request.headers['HTTP_CLIENT']].blank?
    end
end
