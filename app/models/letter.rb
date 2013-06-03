# encoding: UTF-8

class Letter < ActiveRecord::Base
  key :subject
  key :template, as: :text
  key :is_mailed, as: :boolean, default: false
  key :mailed_at, as: :datetime
  timestamps
  belongs_to :user
  belongs_to :testuser, class_name: 'User'

  validates_presence_of :subject
  validates_presence_of :template

  def mail!
    update_attributes is_mailed: true, mailed_at: Time.now
    recipients.find_each do |user|
      LetterMailer.letter(self, user).deliver
    end
  end
end

Letter.auto_upgrade!
