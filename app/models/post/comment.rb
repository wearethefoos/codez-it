class Post::Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Votable

  field :comment,    type: String,  default: ""

  belongs_to :user

  embedded_in :post
end
