class Book < ActiveRecord::Base
  attr_accessible :author, :title, :year, :description, :price
  validates :title, :presence => true, :length => {:minimum => 3}
  validates :description, :presence => true
  validates :price, :presence => true, :format => {:with => /^?[0-9]*\.?[0-9]*$/}
end
