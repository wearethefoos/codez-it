module Mongoid
  module Votable
    extend ActiveSupport::Concern

    included do
      field :votes,      type: Integer, default: 0
      field :upvoters,   type: Array,   default: []
      field :downvoters, type: Array,   default: []
    end

    def upvote(user_id)
      vote user_id, :up
    end

    def downvote(user_id)
      vote user_id, :down
    end

    def vote(user_id, direction)
      case direction.to_sym
      when :up
        add = :upvoters
        remove = :downvoters
        mod = 1
      when :down
        add = :downvoters
        remove = :upvoters
        mod = -1
      else
        return
      end

      vote! add, remove, mod
    end

    def vote!(add, remove, mod)
      if send(add).include? user_id
        collection.update( { '_id' => id, add => user_id },
          {
            '$inc'  => { 'votes' => -mod },
            '$pull' => { add => user_id }
          }
        )
      else
        collection.update( { '_id' => id, remove => user_id },
          {
            '$inc' => { 'votes' => mod },
            '$pull' => { remove => user_id }
          }
        )
        collection.update( { '_id' => id, add => { '$ne' => user_id } },
          {
            '$inc' => { 'votes' => mod },
            '$push' => { add => user_id }
          }
       )
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
