class User < ApplicationRecord
    attr_accessor :remember_token
    # before_save { self.email = email.downcase }
    before_save { email.downcase! } # alternartive way of writing the above

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
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
    
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
    def authenticated?(remember_token) 
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token) #pg 511 for explanation
    end

    # Forgets a user.
    def forget 
        update_attribute(:remember_digest, nil)
    end
end
