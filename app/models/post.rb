class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Votable
  include Mongoid::Sluggable

  field :title, type: String
  field :body, type: String

  slugged_by :title

  embeds_many :comments, class_name: 'Post::Comment'
end
