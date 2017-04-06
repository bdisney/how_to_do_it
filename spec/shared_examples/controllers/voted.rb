shared_examples_for 'voted' do

  sign_in_user
  record_name = described_class.controller_name.singularize.to_sym
  let(:record) { create(record_name) }
  let(:users_record) { create(record_name, user: @user) }

  def send_request(action, member)
      process action, method: :patch, params: { id: member.id }, format: :js
    end

  describe 'PATCH #vote_up' do
    context 'when user votes for someones record' do
      it 'assigns requested record to @votable' do
        send_request(:vote_up, record)
        expect(assigns(:votable)).to eq(record)
      end

      it 'increase rating by 1' do
        expect { send_request(:vote_up, record) }.to change(record, :rating).by(1)
      end

      it 'responds with json' do
        send_request(:vote_up, record)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'when user votes for his own record' do
      it 'assigns requested record to @votable' do
        send_request(:vote_up, users_record)
        expect(assigns(:votable)).to eq(users_record)
      end

      it 'does not save vote to db' do
        expect { send_request(:vote_up, users_record) }
            .to_not change(Vote, :count)
      end

      it 'responds with status code 422' do
        send_request(:vote_up, users_record)
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PATCH #vote_down' do
    context 'when user votes for someones record' do
      it 'assigns requested record to @votable' do
        send_request(:vote_down, record)
        expect(assigns(:votable)).to eq(record)
      end

      it 'reduce rating by 1' do
        expect { send_request(:vote_down, record) }.to change(record, :rating).by(-1)
      end

      it 'responds with json' do
        send_request(:vote_down, record)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'when user votes for his own record' do
      it 'assigns requested record to @votable' do
        send_request(:vote_down, users_record)
        expect(assigns(:votable)).to eq(users_record)
      end

      it 'does not save vote to db' do
        expect { send_request(:vote_down, users_record) }
            .to_not change(Vote, :count)
      end

      it 'responds with status code 422' do
        send_request(:vote_down, users_record)
        expect(response.status).to eq(422)
      end
    end
  end
end 