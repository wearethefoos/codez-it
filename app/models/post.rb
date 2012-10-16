class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Versioning
  include Mongoid::Votable
  include Mongoid::Sluggable

  field :title, type: String
  field :body, type: String

  slugged_by :title, scope: :user_id

  belongs_to :user

  embeds_many :comments, class_name: 'Post::Comment'
  embeds_many :gists,    class_name: 'Github::Gist'

  validates_presence_of :title
  validates_presence_of :body

  # Public: Get all posts for a certain
  # Account name (blog).
  #
  # account_name: String with the subdomain
  #               (name) of the account
  #
  # Returns Mongoid::Relations::Targets::Enumerable
  def self.from_blog(account_name)
    Account.where(slug: account_name).first.user.posts
  end

  private

    # Private: Extract code from the body of the post
    # and create Gists in the User's Github account.
    def extract_code_to_gists(request)
      
    end

    # Private: Extracts code blocks from the post body.
    #
    # Examples:
    #
    #  body :
    #    ```ruby
    #    def foobar
    #      foo + bar
    #    end
    #    ```
    #
    #  extract_code_blocks
    #  # =>
    #  MatchData:
    #    1.
    #      1:
    #        ruby
    #      2:
    #        def foobar
    #          foo + bar
    #        end
    #
    # Returns MatchData or nil
    def extract_code_blocks
      body.match /```([a-z]+)?\n(.*)\n```/
    end
end
