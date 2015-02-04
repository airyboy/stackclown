require "rails_helper"

RSpec.describe UserMailer, :type => :mailer do
  let(:user) { create(:user) }

  describe "activation_needed_email" do
    let(:mail) { UserMailer.activation_needed_email(user) }

    it "renders the headers" do
      expect(mail.subject).to eq('Welcome to StackClown')
      expect(mail.to).to eq([user.email])
      # expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(user.screen_name)
    end
  end

  describe "activation_success_email" do
    let(:mail) { UserMailer.activation_success_email(user) }

    it "renders the headers" do
      expect(mail.subject).to eq('Your account at Stackclown is now activated')
      expect(mail.to).to eq([user.email])
      # expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match('You have successfully activated your StackClown account')
    end
  end

end
