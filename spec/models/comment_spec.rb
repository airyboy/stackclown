require 'rails_helper'

RSpec.describe Comment, :type => :model do
  it { should validate_presence_of(:body) }
  it { should ensure_length_of(:body).is_at_most(1000) }
end
