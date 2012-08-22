# encoding: UTF-8


module CommonCommentable

  def self.included(base)
    base.class_eval do
      key :comments_count, :as => :integer
      has_many :comments, :as => :commentable, :dependent => :destroy

      def commenters
        @commenters ||= comments_count > 0 ? User.joins(:comments).where('comments.commentable_type' => self.class.name, 'comments.commentable_id' => self.id).group('users.id').all : []
      end
    end
  end
end
