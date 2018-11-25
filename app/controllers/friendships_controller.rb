class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  # POST /friendships
  # POST /friendships.json
  def create
    @friendship = current_user.friendships.build(friendship_params)

    respond_to do |format|
      if @friendship.save
        format.html { redirect_to users_path, notice: 'Friendship was successfully created. Friend Added' }
      else
        format.html { redirect_to users_path, error: "ups something went wrong." }
      end
    end
  end

  # DELETE /friendships/1
  # DELETE /friendships/1.json
  def destroy
    @friendship = current_user.friendships.find_by_friend_id(friendship_params["id"])
    @friendship.destroy
    respond_to do |format|
      format.html { redirect_to users_path, notice: 'Friendship was successfully destroyed.' }
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def friendship_params
      params.permit(:friend_id, :id)
    end
end
