# -*- encoding : utf-8 -*-

class Interest < ActiveRecord::Base
  key :name
  key :permalink
  timestamps

  auto_permalink :name

  has_attached_file :image,
    :path => ':rails_root/public/system/:class/:style/:class_:id.:extension',
    :url => '/system/:class/:style/:class_:id.:extension',
    :default_url => '/system/:class/missing_:style.png',
    :styles => {
      :normal => ['128x128#', :jpg]
    },
    :convert_options => {:all => '-quality 95 -strip'}
end

Interest.auto_upgrade!
