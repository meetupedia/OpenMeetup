# encoding: UTF-8

module CommonVoteable

  def self.included(base)
    base.class_eval do
      key :votes_count, as: :integer, default: 0

      has_many :votes, as: :voteable, dependent: :delete_all

      def voters
        @voters ||= votes_count > 0 ? User.all(joins: :votes, conditions: {'votes.voteable_type' => self.class.name, 'votes.voteable_id' => id}, order: 'votes.id') : []
      end

      def voter_ids
        Vote.all(conditions: {voteable_type: self.class.name, voteable_id: id}, select: 'user_id', order: 'id ASC').map(&:user_id)
      end
    end
  end
end
