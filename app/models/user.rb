class User < ApplicationRecord
  validates :uuid, presence: true, uniqueness: true
  scope :avg_age, ->(gender) { where(gender: gender).average(:age).to_f.round(2) }
  after_destroy :update_hourly_count

  private

  def update_hourly_count
    gender = self.gender
    date = self.created_at.to_date
    return HourlyRecord.decr_count(gender) if Date.today == date

    daily_record = DailyRecord.find_by(date: date)
    users = User.where(created_at: date.all_day)
    count = users.where(gender: gender).count
    avg_age = users.avg_age(gender)
    
    case gender
    when 'male'
      daily_record.update(male_avg_age: avg_age, male_count: count)
    when 'female'
      daily_record.update(female_avg_age: avg_age, female_count: count)
    end
  end
end
