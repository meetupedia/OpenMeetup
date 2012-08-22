# encoding: UTF-8

class Interest < ActiveRecord::Base
  key :name
  key :permalink
  key :image_file_name
  key :image_content_type
  key :image_file_size, :as => :integer
  key :image_updated_at, :as => :datetime
  timestamps

  has_many :interest_taggings
  has_many :invited_interest_taggings

  auto_permalink :name

  has_attached_file :image,
    :path => ':rails_root/public/system/:class/:style/:class_:id.:extension',
    :url => '/system/:class/:style/:class_:id.:extension',
    :default_url => '/system/:class/missing_:style.png',
    :styles => {
      :normal => ['128x128#', :jpg]
    },
    :convert_options => {:all => '-quality 95 -strip'}

  def interest_tagging_for(user)
    InterestTagging.find_by_interest_id_and_user_id(self.id, user.id)
  end

  def invited_interest_tagging_for(invited_user)
    InvitedInterestTagging.find_by_interest_id_and_invited_user_id(self.id, invited_user.id)
  end
end

Interest.auto_upgrade!
