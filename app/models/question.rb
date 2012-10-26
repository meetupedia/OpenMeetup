# encoding: UTF-8

class Question < ActiveRecord::Base
  key :question
  timestamps

  belongs_to :user
  belongs_to :event
  has_many :answers, :dependent => :destroy
end

Question.auto_upgrade!
