class Api::V1::TeamsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_team, only: [:show, :update, :destroy]
  before_action :delete_other_users, only: [:update]

  def create
    @team = Team.new(team_params)
    if @team.save
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
    if @team.update(team_params)
      render json: { result: 'Team Updated Successfully'}, status: :ok
    else
      render json: { result: 'Invalid params'}, status: :bad_request
    end
  end

  def destroy
    if @team.destroy
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
      params.permit(:name, :country, users_attributes: [:id, :name, :average, :matches])
    end

    def delete_other_users
      user_ids = []
      team_params['users_attributes'].each { |user| user_ids << user['id'] }
      @team.users.where.not(id: user_ids).delete_all
    end
end
