# encoding: UTF-8

class InvitedUser < ActiveRecord::Base
  key :name
  key :email
  key :code
  key :permalink
  key :locale
  key :location
  key :i_am_an_organizer, as: :boolean
  key :i_am_a_participant, as: :boolean
  timestamps

  auto_permalink :code

  before_validation on: :create do |invited_user|
    invited_user.code = SecureRandom.hex(16)
    true
  end
end

InvitedUser.auto_upgrade!
