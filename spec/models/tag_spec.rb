require 'rails_helper'

RSpec.describe Tag, :type => :model do
  it { should validate_presence_of(:tag_name) }
  it { should have_many(:questions) }
  it { should validate_uniqueness_of(:tag_name).case_insensitive }
	it { should ensure_length_of(:tag_name).is_at_most(GlobalConstants::TAG_NAME_MAX_LENGTH) }

  before { @tag = Tag.new(tag_name: 'some-tag')}

  describe 'when tag format is wrong' do
  	it 'should be invalid' do
  		tags = ['some tag', 'some_tag']
  		tags.each do |invalid_tag|
  			@tag.tag_name = invalid_tag
  			expect(@tag).not_to be_valid
  		end
  	end
	end

	pending 'should not validate these examples: 12345, 12-34, 1-tag'

  describe 'when tag format is valid' do
  	it 'should be valid' do
  		tags = %w[some-tag sometag tag4 tag-tag-3 tag# tag.net 3tag]
  		tags.each do |valid_tag|
  			@tag.tag_name = valid_tag
  			expect(@tag).to be_valid
  		end
  	end
  end
end
