class Api::V1::TeamsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_team, only: [:show, :update]

  def create
    begin
      Team.create(team_params)

      render json: { result: 'Team Created Successfully'}, status: :ok
    rescue => e
      render json: { result: 'Invalid params'}, status: :bad_request
    end
  end

  def index
    @teams = Team.all
    render json: @teams, include: { users: {only: [:name, :matches, :average]}}, except: [:created_at, :updated_at]
  end

  def show
    render json: @team.to_json(only: [:id, :name, :country])
  end

  def update
  end

  private

    def set_team
      @team = Team.find_by_id(params[:id])
    end

    def team_params
      params.require(:team).permit(:name, :country)
    end
end
