require 'spec_helper'

describe Group do
  it 'can be instantiated' do
    Group.new.should be_an_instance_of(Group)
  end
end
