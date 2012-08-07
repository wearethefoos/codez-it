module Mongoid
  module Votable
    extend ActiveSupport::Concern

    included do
      field :votes,      type: Integer, default: 0
      field :upvoters,   type: Array,   default: []
      field :downvoters, type: Array,   default: []
    end

    def upvote(user_id)
      if upvoters.include? user_id
        collection.update({'_id' => id, 'upvoters' => user_id},
          {'$inc' => {'votes' => -1}, '$pull' => {'upvoters' => user_id}})
      else
        if downvoters.include? user_id
          collection.update({'_id' => id, 'downvoters' => user_id},
            {'$inc' => {'votes' => 1}, '$pull' => {'downvoters' => user_id}})
        end
        collection.update({'_id' => id, 'upvoters' => {'$ne' => user_id}},
          {'$inc' => {'votes' => 1}, '$push' => {'upvoters' => user_id}})
      end
    end

    def downvote(user_id)
      if downvoters.include? user_id
        collection.update({'_id' => id, 'downvoters' => user_id},
          {'$inc' => {'votes' => 1}, '$pull' => {'downvoters' => user_id}})
      else
        if upvoters.include? user_id
          collection.update({'_id' => id, 'upvoters' => user_id},
            {'$inc' => {'votes' => -1}, '$pull' => {'upvoters' => user_id}})
        end
        collection.update({'_id' => id, 'downvoters' => {'$ne' => user_id}},
          {'$inc' => {'votes' => -1}, '$push' => {'downvoters' => user_id}})
      end
    end

    def voted_by?(user)
      upvoters.include? user.id or downvoters.include? user.id
    end

    def upvoted_by?(user)
      upvoters.include? user.id
    end

    def downvoted_by?(user)
      downvoters.include? user.id
    end
  end
end
