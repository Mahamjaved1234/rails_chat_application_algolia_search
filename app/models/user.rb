class User 
  include Mongoid::Document
  include Mongoid::Timestamps
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
        #  :recoverable, :rememberable, :validatable
        #  field :title, type: String
        #  field :body, type: String
end
