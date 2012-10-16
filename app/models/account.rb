class Account
  include Mongoid::Document
  include Mongoid::Sluggable

  field :name, type: String, default: ""
  field :_id, type: String, default: ->{ name.parameterize }

  slugged_by :name, timed: false

  belongs_to :user

  validates_presence_of   :name
  validates_uniqueness_of :name, :case_sensitive => false
end
