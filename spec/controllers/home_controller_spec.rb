require 'spec_helper'

describe HomeController do

  describe "GET /users" do
    it "should show sign in button if user isn't logged in" do
      get "index"
      response.should be_true
    end
  end
end
