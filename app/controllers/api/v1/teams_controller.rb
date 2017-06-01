class Api::V1::TeamsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :validate_user
  before_action :set_team, only: [:show, :update, :destroy]
  before_action :delete_other_users, only: [:update]

  def create
    @team = Team.new(team_params)
    if @team.save(validate: false)
      return render json: { result: 'Team Created Successfully'}, status: :ok
    else
      render json: { result: 'Invalid params', errors: @team.errors}, status: :bad_request
    end
  end

  def index
    @teams = Team.all
    render json: @teams, include: { users: {only: [:id, :name, :matches, :average]}}, except: [:created_at, :updated_at]
  end

  def show
    render json: @team.to_json(only: [:id, :name, :country])
  end

  def update
    @team.assign_attributes(team_params)
    if @team.save(validate: false)
      render json: { result: 'Team Updated Successfully'}, status: :ok
    else
      render json: { result: 'Invalid params'}, status: :bad_request
    end
  end

  def destroy
    if @team.destroy
      @team.save(validate: false)
      render json: { result: 'Team Deleted Successfully'}, status: :ok
    else
      render json: { result: 'Invalid params'}, status: :bad_request
    end
  end

  private

    def set_team
      @team = Team.find_by_id(params[:id])
    end

    def team_params
      params.permit(:name, :country, :image, users_attributes: [:id, :name, :average, :matches])
    end

    def delete_other_users
      if team_params['users_attributes'].blank?
        @team.users.delete_all
      else
        user_ids = []
        team_params['users_attributes'].each { |user| user_ids << user['id'] }
        @team.users.where.not(id: user_ids).delete_all
      end
    end

    def validate_user
      @user = User.find_by_email(request.headers['HTTP_UID'])
      return render json: { result: 'Invalid user'}, status: :unauthorized if @user.blank? || @user.tokens[request.headers['HTTP_CLIENT']].blank?
    end
end
