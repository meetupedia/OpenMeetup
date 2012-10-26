# encoding: UTF-8

class Answer < ActiveRecord::Base
  key :answer
  timestamps

  belongs_to :user
  belongs_to :question
end

Answer.auto_upgrade!
