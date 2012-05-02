# -*- encoding : utf-8 -*-

class Language < ActiveRecord::Base
  key :code
  key :name

  has_many :groups, :dependent => :nullify
  has_many :tags, :dependent => :nullify
end

Language.auto_upgrade!
