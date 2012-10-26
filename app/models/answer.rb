# encoding: UTF-8

class Answer < ActiveRecord::Base
  key :answer
  timestamps

  belongs_to :user
  belongs_to :question
  belongs_to :participation
end

Answer.auto_upgrade!
