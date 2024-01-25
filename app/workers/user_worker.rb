require 'sidekiq-scheduler'
require 'net/http'

class UserWorker
  include Sidekiq::Worker
  
  def perform
    url = 'https://randomuser.me/api/?results=20'
    resp = Net::HTTP.get_response(URI.parse(url))
    data = JSON.parse(resp.body)
    data['results'].each do |api_user|
      user = User.find_or_initialize_by(
              uuid: api_user.dig('login', 'uuid'),
              gender: api_user['gender'],
              name: api_user['name'],
              age: api_user.dig('dob', 'age')
            )
      user_already_exists = user.persisted?
      
      if user.save
        unless user_already_exists
          HourlyRecord.incr_count(user.gender)
        end
      end
    end
  end
end