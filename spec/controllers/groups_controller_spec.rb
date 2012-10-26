require 'spec_helper'
require 'factory_girl'

FactoryGirl.define do
  factory :group do
    name 'Test'
  end
end

describe GroupsController do
  describe 'GET show' do
    it 'renders the show template' do
      @group = FactoryGirl.build(:group)
      get :show, :id => @group.id
      response.should render_template('show')
    end
  end
end
