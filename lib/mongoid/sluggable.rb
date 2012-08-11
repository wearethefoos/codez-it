require 'mongoid/sluggable/router/redis_router'

module Mongoid
  module Sluggable
    extend ActiveSupport::Concern

    included do
      field :slug, type: String, default: ""

      index({slug: -1}, {unique: true})

      validates_with Mongoid::Sluggable::Validator

      def to_url
        self.slug
      end

      def self.slugged_by(field)
        @@slug_field = field.to_sym
      end

      def self.find_route(route, subdomain)
        if respond_to?(:find_route_custom)
          send(:find_route_custom, route, subdomain)
        else
          # Strip left slash (/) and parameterize
          route = route.match(/^\/(.*)/)[1]
          if subdomain.empty?
            self.find_by_slug(route)
          else
            Account.find(subdomain).user.posts.find_by_slug(route)
          end
        end
      end

      def self.find_by_slug(slug)
        where(slug: slug).first
      end

      def self.slug_field
        @@slug_field
      end

      def create_slug
        t = Time.now
        initial = [t.year, t.month]
        extra_date_parts = [t.day, t.hour, t.min, t.sec]

        while slug_exists?(initial) && extra_date_parts.size > 0
          initial << extra_date_parts.pop
        end

        return if slug_exists?(initial)

        self.slug = create_slug_with_initial(initial)
      end

      def slug_exists?(initial)
        self.user.posts.where(slug: create_slug_with_initial(initial)).not.where(_id: self.id).count > 0
      end

      def create_slug_with_initial(initial)
        [initial.join("/"), self.send(self.class.slug_field).parameterize].join("/")
      end
    end

    class Validator < ActiveModel::Validator
      def validate(record)
        record.errors[record.class.slug_field] << "Please choose another #{record.class.slug_field.humanize}." unless check(record)
      end

      private

        def check(record)
          !record.create_slug.nil?
        end
    end
  end
end
