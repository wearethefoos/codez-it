module Mongoid
  module Sluggable
    class MongoRouter
      attr_accessor :fk

      def initialize(model_name)
        @model_name = model_name
      end

      def matches?(request)
        return false unless record = @model_name.constantize.find_route(request.path, request.subdomain)
        { id: record.id }
      end
    end
  end
end
