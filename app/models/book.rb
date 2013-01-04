class Book < ActiveRecord::Base
  attr_accessible :author, :title, :year, :description, :price, :hire_status, :units
  validates :title, :presence => true, :length => {:minimum => 3, :message => "Title too short"} 
  validates :description, :presence => true
  validates :price, :presence => true, :format => {:with => /^[0-9]*\.?[0-9]*$/, :message => "Price should be float number"} 
  validates :units, :presence => true, :format => {:with => /^[1-9]+/, :message => "You should have more units"}, :on => :create
  validates :hire_status, :presence => true, :on => :create

  belongs_to :user
end
