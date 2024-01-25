class HourlyRecord
  include ActiveModel::Model
  
  class << self
    def count(gender)
      redis.get(gender).to_i
    end

    def incr_count(gender)
      redis.incr(gender)
    end

    def decr_count(gender)
      redis.decr(gender)
    end

    def destroy_keys
      redis.del('male', 'female')
    end

    private

    def redis
      @redis ||= Redis.new
    end
  end
end
