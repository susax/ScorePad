class Team < ActiveRecord::Base
  attr_accessible :tname

  has_many :affiliations
  has_many :players, :through => :affiliations

  validates :tname, :presence => true

end
