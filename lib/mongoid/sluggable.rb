require 'mongoid/sluggable/redis_router'

module Mongoid
  module Sluggable
    extend ActiveSupport::Concern

    included do
      field :slug, type: String, default: ""

      index({slug: -1}, {unique: true})

      validates_with Mongoid::Sluggable::Validator

      def self.defaults
        {scope: false, timed: false}
      end

      def to_url
        self.slug
      end

      def self.slugged_by(field, options={})
        @@slug_field ||= {}
        @@sluggable_options ||= {}
        @@slug_field[self.name] = field.to_sym
        @@sluggable_options[self.name] = defaults.merge options
      end

      def self.find_route(route, subdomain)
        if respond_to?(:find_route_custom)
          send(:find_route_custom, route, subdomain)
        else
          # Strip left slash (/) and parameterize
          route = route.match(/^\/(.*)/)[1]
          if subdomain.empty? || subdomain == 'www'
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
        @@slug_field[self.name]
      end

      def self.sluggable_scope
        @@sluggable_options[self.name][:scope]
      end

      def timed_slugs?
        @@sluggable_options[:timed]
      end

      def create_slug
        intial = false

        if timed_slugs?
          t = Time.now
          initial = [t.year, t.month]
          extra_date_parts = [t.day, t.hour, t.min, t.sec]

          while slug_exists?(initial) && extra_date_parts.size > 0
            initial << extra_date_parts.pop
          end
        end

        return if slug_exists?(initial)

        self.slug = create_slug_with_initial(initial)
      end

      def slug_exists?(initial=false)
        with_same_slug = self.class.where(slug: create_slug_with_initial(initial)).where(:id.ne => self.id)
        if self.class.sluggable_scope
          with_same_slug.where(self.class.sluggable_scope => self.send(self.class.sluggable_scope))
        end
        with_same_slug.count > 0
      end

      def create_slug_with_initial(initial=false)
        if initial
          [initial.join("/"), self.send(self.class.slug_field).parameterize].join("/")
        else
          self.send(self.class.slug_field).parameterize
        end
      end
    end

    class Validator < ActiveModel::Validator
      def validate(document)
        document.errors[document.class.slug_field] << "Please choose another #{document.class.slug_field.to_s.humanize}." unless check(document)
      end

      private

        def check(document)
          !document.create_slug.nil?
        end
    end
  end
end
