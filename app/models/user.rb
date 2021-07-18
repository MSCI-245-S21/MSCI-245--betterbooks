class User < ApplicationRecord   
    validates_presence_of :name
    validates_length_of :name, maximum: 70    
    #validates_presence_of :email, uniqueness: true
    #validates :email, uniqueness: true
    validates_uniqueness_of :email, :message => "This email is already taken. Try with another email"
    validates_length_of :email, maximum: 255
    validates_format_of :email, with:  /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i 
    
    before_save :lowercase_email
    
    
    def lowercase_email
        self.email= email.downcase.strip
        
    end
        
    

end
