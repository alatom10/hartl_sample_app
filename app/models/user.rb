class User < ApplicationRecord
    has_many :microposts, dependent: :destroy # dependent: :destroy is similar to on delete cascade, if a user is destroyed then destroy the microposts
    # before_save { self.email = email.downcase }
    # before_save { email.downcase! } # alternartive way of writing the above
    #  the above save was removed in 11.1 pg 629 and replaced with a method reference as below
    attr_accessor :remember_token, :activation_token ,:reset_token
    before_save :downcase_email
    before_create :create_activation_digest

    validates :name, presence: true, length: { maximum: 50 }
    #note the above is the same as: validates(:name, prescence: true)

    # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i    
    # capital letters above indicate a constant

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    # above is a more robust regexp when compared to the first
    validates :email,
                 presence: true, 
                length: { maximum: 255 },
                 format: { with: VALID_EMAIL_REGEX },
                 uniqueness: true #adds a check to ensure no duplicates of this can be created
                # uniqueness: { case_sensitive: false } #Rails infers that uniqueness should be true as well.

    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true #note that even though allow_nil is set, our has_secure_password method prevents null passwords but this allows updates to be null if a user edits their profile but not password
    
    # Returns the hash digest of the given string.
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                          BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end # see page 484
   
    # Returns a random token.
    def User.new_token
        SecureRandom.urlsafe_base64
    end

    # Remembers a user in the database for use in persistent sessions.
    def remember
        self.remember_token = User.new_token 
        update_attribute(:remember_digest, User.digest(remember_token))
        remember_digest #added pg 545
    end

    # Returns a session token to prevent session hijacking. # We reuse the remember digest for convenience.
    def session_token
        remember_digest || remember
    end

    # Returns true if the given token matches the digest.
    # def authenticated?(remember_token) 
    #     return false if remember_digest.nil?
    #     BCrypt::Password.new(remember_digest).is_password?(remember_token) #pg 511 for explanation
    # end
    # we replaced the above with a more generic method below:

    # Returns true if the given token matches the digest. chapter 11.4 pg652
    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end


    # Forgets a user.
    def forget 
        update_attribute(:remember_digest, nil)
    end

    # Activates an account.
    def activate
        # update_attribute(:activated,    true)
        # update_attribute(:activated_at, Time.zone.now) 
        # the above can be done in 1 line to prevent multiple db calls
        update_columns(activated: true, activated_at: Time.zone.now)
    end

    # Sends activation email.
    def send_activation_email 
        UserMailer.account_activation(self).deliver_now
    end

  # Sets the password reset attributes.
    def create_reset_digest
        self.reset_token = User.new_token 
        update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
        
    end

    # Sends password reset email.
    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end

    # Returns true if a password reset has expired. 
    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end

    # Defines a proto-feed.
# See "Following users" for the full implementation. 
    def feed
        Micropost.where("user_id = ?", id) #the question mark ensures that id is properly escaped before being included in the sql query, avoiding sql injection
    end

    private
    # Converts email to all lower-case.
        def downcase_email
            self.email = email.downcase
        end

    # Creates and assigns the activation token and digest.
        def create_activation_digest
            self.activation_token = User.new_token 
            self.activation_digest = User.digest(activation_token)
        end
end
