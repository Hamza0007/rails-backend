class User < ActiveRecord::Base
  belongs_to :team

  scope :admin, -> { where(role: 'admin') }
  scope :player, -> { where(role: 'player') }
end
