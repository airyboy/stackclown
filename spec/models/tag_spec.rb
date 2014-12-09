require 'rails_helper'

RSpec.describe Tag, :type => :model do
  it { should validate_presence_of(:tag_name) }
  it { should have_many(:questions) }
  it { should validate_uniqueness_of(:tag_name).case_insensitive }

  before { @tag = Tag.new(tag_name: "some-tag")}

  describe 'when tag format is wrong' do
  	it 'should be invalid' do
  		tags = ['some tag', 'some_tag', '4321']
  		tags.each do |invalid_tag|
  			@tag.tag_name = invalid_tag
  			expect(@tag).not_to be_valid
  		end
  	end
  end

  describe 'when tag format is valid' do
  	it 'should be valid' do
  		tags = ['some-tag', 'sometag', 'tag4', 'tag-tag-3', 'tag#', 'tag.net', '3tag']
  		tags.each do |valid_tag|
  			@tag.tag_name = valid_tag
  			expect(@tag).to be_valid
  		end
  	end
  end
end
