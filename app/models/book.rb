class Book < ActiveRecord::Base
  attr_accessible :author, :title, :year, :description, :price
  validates :title, :presence => true, :length => {:minimum => 3, :message => "Title too short"} 
  validates :description, :presence => true
  validates :price, :presence => true, :format => {:with => /^[0-9]*\.?[0-9]*$/, :message => "Price should be float number"} 

  belongs_to :user
end
