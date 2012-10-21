require 'spec_helper'

describe Book do
  before (:each) do
    @book = FactoryGirl.create(:book)
    @book.should be_valid
  end

  it "should validate title" do
    @book.title = "T"
    @book.should_not be_valid
  end

  it "should validate description" do
    @book.description = ""
    @book.should_not be_valid
  end
  it "should validate price" do
    @book.price = "ADBDSD"
    @book.should_not be_valid
  end
end
