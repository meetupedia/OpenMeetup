class Friendship < ActiveRecord::Base
  key :is_confirmed, as: :boolean, default: false
  key :is_delayed, as: :boolean, default: false
  timestamps

  belongs_to :user
  belongs_to :friend, :class_name => 'User'

  after_destroy :destroy_inverse

  def create_inverse
    Friendship.create user_id: friend.id, friend_id: user.id, is_confirmed: true, is_delayed: false unless friend.friendship_for(user)
  end

  def destroy_inverse
    friend.friendship_for(user).andand.destroy
  end
end

Friendship.auto_upgrade!
