class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable
  include DeviseTokenAuth::Concerns::User
  belongs_to :team

  scope :admin, -> { where(role: 'admin') }
  scope :player, -> { where(role: 'player') }
end
