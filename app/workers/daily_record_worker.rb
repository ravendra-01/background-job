require 'sidekiq-scheduler'

class DailyRecordWorker
  include Sidekiq::Worker
  
  def perform
    day = Date.yesterday
    users = User.where(created_at: day.all_day)
    male_count = HourlyRecord.count('male')
    female_count = HourlyRecord.count('female')
    male_avg_age = users.avg_age('male')
    female_avg_age = users.avg_age('female')
    
    daily_record = DailyRecord.new(
                    date: day,
                    male_count: male_count,
                    female_count: female_count,
                    male_avg_age: male_avg_age,
                    female_avg_age: female_avg_age
                    )
    if daily_record.save
      HourlyRecord.destroy_keys
    end
  end
end