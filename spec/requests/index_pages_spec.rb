require 'spec_helper'

describe "IndexPages" do
  describe "GET /index_pages" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get index_pages_path
      response.status.should be(200)
    end
  end
end
