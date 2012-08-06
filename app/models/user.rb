class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  field :name,               :type => String, :default => ""

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Optional stuff
  field :bio,                :type => String,  :default => ""
  field :hireable,           :type => Boolean, :default => false
  field :avatar_url,         :type => String,  :default => ""
  field :location,           :type => String,  :default => ""
  field :public_repos,       :type => Integer, :default => 0

  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :encrypted_password
  validates_uniqueness_of :name, :email, :case_sensitive => false

  has_one :account
  has_many :authentications, :dependent => :delete

  accepts_nested_attributes_for :account

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  field :confirmation_token,   :type => String
  field :confirmed_at,         :type => Time
  field :confirmation_sent_at, :type => Time
  field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String

  def apply_omniauth(omniauth)
    self.email = omniauth['info']['email'] if email.blank?
    apply_trusted_services(omniauth) if self.new_record?
  end

  def apply_trusted_services(omniauth)
    user_info = omniauth['info']
    if omniauth['extra'] && omniauth['extra']['raw_info']
      user_info.merge!(omniauth['extra']['raw_info'])
    end
    if self.name.blank?
      self.name   = user_info['name']   unless user_info['name'].blank?
      self.name ||= user_info['nickname'] unless user_info['nickname'].blank?
      self.name ||= (user_info['first_name']+" "+user_info['last_name']) unless \
        user_info['first_name'].blank? || user_info['last_name'].blank?
    end
    if self.email.blank?
      self.email = user_info['email'] unless user_info['email'].blank?
    end
    self.password, self.password_confirmation = String::RandomString(16)
    self.confirmed_at, self.confirmation_sent_at = Time.now

    if self.bio.blank?
      self.bio = user_info['bio'] unless user_info['bio'].blank?
    end
    if self.hireable.blank? || self.hireable == false
      self.hireable = user_info['hireable'] unless user_info['hireable'].blank?
    end
    if self.avatar_url.blank?
      self.avatar_url = user_info['avatar_url'] unless user_info['avatar_url'].blank?
    end
    if self.location.blank?
      self.location = user_info['location'] unless user_info['location'].blank?
    end
    if self.public_repos.blank?
      self.public_repos = user_info['public_repos'] unless user_info['public_repos'].blank?
    end
  end
end
