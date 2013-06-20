class Friendship < ActiveRecord::Base
  key :is_confirmed, as: :boolean, default: false
  key :is_delayed, as: :boolean, default: false
  timestamps

  belongs_to :user
  belongs_to :friend, :class_name => 'User'

  after_create :create_inverse
  after_update :create_inverse
  after_destroy :destroy_inverse

  def create_inverse
    if friendship = friend.friendship_for(user)
      update_column :is_confirmed, true
      friendship.update_column :is_confirmed, true
    else
      Friendship.create user_id: friend.id, friend_id: user.id, is_confirmed: true, is_delayed: false if is_confirmed?
    end
  end

  def destroy_inverse
    friend.friendship_for(user).andand.destroy
  end
end

Friendship.auto_upgrade!
