class Book < ActiveRecord::Base
  attr_accessible :author, :title, :year, :description, :price
  validates_presence_of :title, :description, :price
end
