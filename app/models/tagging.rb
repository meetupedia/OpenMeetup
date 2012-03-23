# -*- encoding : utf-8 -*-

class Tagging < ActiveRecord::Base
  timestamps

  belongs_to :tag
  belongs_to :user
end

Tagging.auto_upgrade!
