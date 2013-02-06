class Affiliation < ActiveRecord::Base
  attr_accessible :team_id, :player_id

  belongs_to :team
  belongs_to :player

  validates_uniqueness_of :team_id, :scope => :player_id
  validates_uniqueness_of :player_id, :scope => :team_id

end
