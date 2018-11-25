class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.where.not(id: [current_user.id, current_user.friends.pluck(:id)].flatten)
    @friends = current_user.friends
  end

end
