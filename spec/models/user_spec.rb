require 'rails_helper'

RSpec.describe User, :type => :model do
   it { should have_many :questions }
   it { should have_many :answers }
   it { should have_many :comments }

   it { should respond_to :email }
   it { should respond_to :password }
   it { should respond_to :password_confirmation }
end