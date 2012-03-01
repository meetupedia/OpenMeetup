class UsersController < ApplicationController
  load_resource
  authorize_resource :except => [:index, :show]
end
