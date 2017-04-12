require 'rails_helper'

RSpec.describe HighVoltage::PagesController, type: :controller do
  %w(privacy terms).each do |page|
    context "on GET to /pages/#{page}" do
      before do
        get :show, params: { id: page }
      end

      it 'responds with status 200' do
        expect(response.status).to eq(200)
      end

      it "renders #{page} template" do
        expect(response).to render_template(page)
      end
    end
  end
end