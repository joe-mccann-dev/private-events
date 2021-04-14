class Event < ApplicationRecord
  belongs_to :host, class_name: "User"

  has_many :invitations, foreign_key: "event_id"

  has_many :invitees, through: :invitations,
                      class_name: "User"

  scope :past,     -> { where("start_time < ?", Time.zone.now)}
  scope :upcoming, -> { where("start_time > ?", Time.zone.now)}

  validates :title,  presence: true, length: { in: 3..255 }, uniqueness: true;
  validates :location, presence: true, length: { in: 3..255 }
  validates :start_time, presence: true
  validate  :start_time_in_future

  private
    def start_time_in_future
      if start_time < Time.zone.now
        errors.add(:start_time, "must be in future")
      end
    end

end
