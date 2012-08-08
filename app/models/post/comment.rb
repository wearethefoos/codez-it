class Post::Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Votable

  field :text,    type: String,  default: ""

  belongs_to :user

  embedded_in :post
end
