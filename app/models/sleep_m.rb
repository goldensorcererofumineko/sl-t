class SleepM < ApplicationRecord
  enum quality: {普通: "normal", 良: "good", 最高: "excellent", 悪い: "bad" }
  belongs_to :user
  def sleep_duration_minutes
    ((end_time - set_time) / 60).to_i
  end
  def sleep_duration
    (end_time - set_time) / 1.hour  
  end
  validates :quality, presence: true
  validates :set_time, presence: true
  validates :end_time, presence: true
end
