module Mongoid
  module Sluggable
    extend ActiveSupport::Concern

    included do
      field :slug, type: String, default: ""

      index({slug: -1}, {unique: true})

      validates_with Mongoid::Sluggable::Validator

      def self.slugged_by(field)
        @@slug_field = field.to_sym
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

        self.slug = (initial + [self.send(self.class.slug_field)]).join(" ").parameterize
      end

      def slug_exists?(initial)
        self.user.posts.where(slug: (initial + [self.send(self.class.slug_field)]).join(" ").parameterize).not.where(_id: self.id).count > 0
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
