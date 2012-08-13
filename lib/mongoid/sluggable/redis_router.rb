require 'mongoid/sluggable/mongo_router'
require 'yaml'

module Mongoid
  module Sluggable
    class RedisRouter < MongoRouter

      def initialize(model_name)
        setup_redis_connection
        super
      end

      def matches?(request)
        rails_env = ENV['RAILS_ENV'] || 'production'
        fk_json = @@redis.get redis_key(request)
        fk = ::JSON.parse(fk_json) unless fk_json.nil?
        if rails_env != 'production' or fk.nil?
          fk = super
          return false unless fk
          @@redis.set redis_key(request), fk.to_json
        end
        request.path_parameters = request.path_parameters.merge fk
        true
      end

      def redis_key(request)
        "Routes::#{request.subdomain}::#{@model_name}::#{request.path}"
      end

      def clear_key_for_request(request)
        return if request.nil? or request.path.nil?
        @@redis.del redis_key(request) unless @@redis.get(redis_key(request)).nil?
      end

      private

      def setup_redis_connection
        unless defined?(@@redis)
          rails_env = ENV['RAILS_ENV'] || 'production'
          options = YAML.load_file("#{Rails.root}/config/sluggable.yml")[rails_env]['redis']
          host = options['host'] || 'localhost'
          port = options['port'] || 6379
          @@redis = Redis.new(:host => options['host'], :port => port)
        end
      end
    end
  end
end
