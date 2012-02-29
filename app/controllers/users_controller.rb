class UsersController < InheritedResources::Base
  load_resource
  authorize_resource :except => [:index, :show]
end
