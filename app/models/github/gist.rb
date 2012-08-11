class Github::Gist
  include Mongoid::Document

  field :key,  type: String, default: ""
  field :code, type: String, default: ""

  validates_presence_of :code

  embedded_in :post
end
