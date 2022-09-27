class User < ApplicationRecord
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
    validates :password, presence: true, length: { minimum: 6 }

    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                          BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost) 
    end
          
end
