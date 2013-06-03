# encoding: UTF-8

class GroupInvitation < ActiveRecord::Base
  key :message, as: :text
  key :email
  key :code
  key :is_accepted, as: :boolean
  timestamps

  belongs_to :user
  belongs_to :group
  belongs_to :invited_user, class_name: 'User'

  attr_accessor :ids, :error

  before_create do |group_invitation|
    group_invitation.code = SecureRandom.hex(16)
    true
  end
end

GroupInvitation.auto_upgrade!
