module Mongoid
  module Publishable
    extend ActiveSupport::Concern

    included do

      field :published, type: Boolean, default: false

      def self.published
        where( published: true )
      end

      def published?
        published
      end

      def publish!
        update_attribute :published, true
      end

      def unpublish!
        update_attribute :published, false
      end
    end
  end
end
