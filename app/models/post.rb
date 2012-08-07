class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Votable

  field :title, type: String
  field :slug, type: String
  field :body, type: String

  embeds_many :comments
end
