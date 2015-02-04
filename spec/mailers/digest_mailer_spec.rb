require "rails_helper"

RSpec.describe DigestMailer, :type => :mailer do
  describe "daily_digest" do
    let(:mail) { DigestMailer.daily_digest }

    it "renders the headers" do
      expect(mail.subject).to eq("Daily digest")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
