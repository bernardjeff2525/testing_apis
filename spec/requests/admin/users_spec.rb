require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  describe "GET /admin/users" do
    let(:admin) {create(:user, role: :admin)}
    let(:staff) {create(:user, email: 'staff@foobar.com')}

    it 'will redirect to other page if not login' do
      get admin_users_path
      expect(response).to have_http_status(302)
    end

    it 'will redirect to other page if not admin' do
      sign_in staff
      get admin_users_path
      expect(response).to have_http_status(302)
    end

    it 'allow access admin user index page if admin' do
      sign_in admin
      get admin_users_path
      expect(response).to have_http_status(200)
    end
  end
end