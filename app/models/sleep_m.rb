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
  validate :start_time_must_be_earlier_than_end_time
  validate :date_must_be_today_or_earlier
  validate :no_overlapping_records

  private

  def start_time_must_be_earlier_than_end_time
    return unless set_time && end_time
    if set_time >= end_time
      errors.add(:set_time, "は終了時間よりも早い時間に設定してください")
    end
  end

  def date_must_be_today_or_earlier
    return unless set_time

    if set_time.to_date > Date.tomorrow
      errors.add(:set_time, "は今日までの日にちを選択してください")
    end
  end

  def no_overlapping_records
    if overlaps_existing_record?
      errors.add(:base, "同じ時間帯に記録が既に存在します")
    end
  end

  def overlaps_existing_record?
    existing_records = SleepM.where.not(id: self.id)
    existing_records.any? { |record| overlaps?(record) }
  end

  def overlaps?(other_record)
    (self.set_time <= other_record.end_time) && (self.end_time >= other_record.set_time)
  end

end
