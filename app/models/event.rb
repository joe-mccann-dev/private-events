class Event < ApplicationRecord
  belongs_to :host, class_name: "User"

  has_many :invitations, foreign_key: "event_id",
                         dependent: :destroy

  has_many :invitees, through: :invitations,
                      class_name: "User",
                      source: :invitee


  scope :past,     -> { where("start_time < ?", Date.today)}
  scope :upcoming, -> { where("start_time > ?", Date.today)}

  validates :title,  presence: true, length: { in: 3..100 }, uniqueness: true;
  validates :location, presence: true, length: { in: 3..30 }
  validates :description, length: { in: 10..500}, allow_blank: true
  validates :start_time, presence: true
  validate  :start_time_in_future

  private
    def start_time_in_future
      return unless start_time

      if start_time < Time.zone.today
        errors.add(:start_time, "must be in future")
      end
    end
end
