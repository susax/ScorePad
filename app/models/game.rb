class Game < ActiveRecord::Base
  attr_accessible :top_team_id, :bottom_team_id, :playball_datetime, :stadium

 has_many :actions

  validates :top_team_id, :presence => true
  validates :bottom_team_id, :presence => true
  validates :playball_datetime, :presence => true
  validates :stadium, :presence => true

end
