class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Votable
  include Mongoid::Sluggable

  field :title, type: String
  field :body, type: String

  slugged_by :title

  belongs_to :user

  embeds_many :comments, class_name: 'Post::Comment'

  def self.from_blog(account_name)
    Account.find(account_name).user.posts
  end
end
