class Player < ActiveRecord::Base
  attr_accessible :pname
  
  has_many :affiliations
  has_many :teams, :through => :affiliations

  validates :pname, :presence => true

end
