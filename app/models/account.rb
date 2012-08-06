class Account
  include Mongoid::Document

  field :name, type: String, default: ""

  index({name: 1}, {unique: true})

  belongs_to :user

  validates_presence_of   :name
  validates_uniqueness_of :name, :case_sensitive => false
end
