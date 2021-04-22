class User < ApplicationRecord
  has_many :hosted_events, class_name: "Event",
                           foreign_key: "host_id"
  
  has_many :sent_invitations, class_name: "Invitation",
                              foreign_key: "host_id"
                        
  has_many :received_invitations, class_name: "Invitation",
                                  foreign_key: "invitee_id"                     

  has_many :invited_events,  through: :received_invitations, 
                             class_name: "Event",
                             foreign_key: "invitee_id",
                             source: :event

  has_secure_password
  validates :name, presence: true, length: { in: 2..50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                                    format: { with: VALID_EMAIL_REGEX },
                                    uniqueness: true
  validates :password, length: { minimum: 6 }

  before_create { generate_token(:auth_token) }

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])    
  end
end
