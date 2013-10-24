# encoding: UTF-8

class Feedback < ActiveRecord::Base
  key :email
  key :body, as: :text
  timestamps

  belongs_to :user
end

Feedback.auto_upgrade!
