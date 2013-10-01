class Image < ActiveRecord::Base
  include CommonCommentable
  include CommonVoteable
  key :image_file_name
  key :image_content_type
  key :image_file_size, as: :integer
  key :image_updated_at, as: :datetime
  key :caption
  key :is_live, as: :boolean, default: false
  timestamps

  belongs_to :imageable, polymorphic: true
  belongs_to :event, foreign_type: 'Event', foreign_key: :imageable_id
  belongs_to :group, foreign_type: 'Group', foreign_key: :imageable_id
  belongs_to :user
  has_many :activities, as: :activable, dependent: :destroy

  has_attached_file :image,
    path: ':rails_root/public/system/:class/:style/:class_:id.:extension',
    url: '/system/:class/:style/:class_:id.:extension',
    default_url: '/system/:class/missing_:style.png',
    styles: {
      normal: ['920x920>', :jpg],
      small: ['80x80#', :jpg]
    },
    convert_options: {all: '-quality 95 -strip'}
end

Image.auto_upgrade!
