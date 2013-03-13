require 'spec_helper'

describe "Root" do
  describe "GET /" do
    it "Root works!" do
      get root_path
      response.status.should be(200)
    end
  end
end
