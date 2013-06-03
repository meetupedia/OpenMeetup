# encoding: UTF-8

class LetterTemplate < ActiveRecord::Base
  key :name
  key :subject
  key :template, as: :text
  timestamps
  belongs_to :user

  validates_presence_of :name
  validates_presence_of :subject
  validates_presence_of :template

end

LetterTemplate.auto_upgrade!
