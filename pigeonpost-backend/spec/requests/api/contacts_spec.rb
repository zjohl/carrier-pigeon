require "rails_helper"

RSpec.describe "Contacts", :type => :request do

	it "can create a contact" do
		user1 = FactoryBot.create(:user)
		user2 = FactoryBot.create(:user)

		post "/api/contacts?user_email_1=#{user1.email}&user_email_2=#{user2.email}"

		expect(response).to have_http_status(:created)

		contact1 = UserContact.find_by(user_id: user1.id, contact_id: user2.id)
		contact2 = UserContact.find_by(user_id: user2.id, contact_id: user1.id)

		expect(contact1.contact_id).to eq(user2.id)
		expect(contact2.contact_id).to eq(user1.id)
	end

	it "can delete a contact" do
		user1 = FactoryBot.create(:user)
		user2 = FactoryBot.create(:user)

    UserContact.create!(user_id: user1.id, contact_id: user2.id)

    delete "/api/contacts?user_email_1=#{user1.email}&user_email_2=#{user2.email}"

		expect(response).to have_http_status(:no_content)

		contact1 = UserContact.find_by(user_id: user1.id, contact_id: user2.id)
		contact2 = UserContact.find_by(user_id: user2.id, contact_id: user1.id)

		expect(contact1).to be_nil
		expect(contact2).to be_nil
	end
end