shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:votable) { create(described_class.to_s.underscore.to_sym) }

  describe '#vote_up' do
    context 'when user votes up for the first time' do
      it 'increase rating by 1' do
        expect { votable.vote_up(user) }.to change(votable, :rating).by(1)
      end
    end

    context 'when user repeats voting up' do
      let!(:vote) { create(:vote, votable: votable, user: user) }

      it 'reduce rating by 1' do
        expect { votable.vote_up(user) }.to change(votable, :rating).by(-1)
      end
    end

    context 'when user voted down earlier' do
      let!(:vote) { create(:negative_vote, votable: votable, user: user) }

      it 'increase rating by 2' do
        expect { votable.vote_up(user) }.to change(votable, :rating).by(2)
      end
    end
  end

  describe '#vote_down' do
    context 'when user votes down for the first time' do
      it 'reduce rating by 1' do
        expect { votable.vote_down(user) }.to change(votable, :rating).by(-1)
      end
    end

    context 'when user repeats voting down' do
      let!(:vote) { create(:negative_vote, votable: votable, user: user) }

      it 'increase rating by 1' do
        expect { votable.vote_down(user) }.to change(votable, :rating).by(1)
      end
    end

    context 'when user voted up earlier' do
      let!(:vote) { create(:vote, votable: votable, user: user) }

      it 'reduce rating by 2' do
        expect { votable.vote_down(user) }.to change(votable, :rating).by(-2)
      end
    end
  end

  describe '#has_positive_vote?' do
    context 'when user did not vote up' do
      it 'return false' do
        expect(votable).to_not have_positive_vote(user)
      end
    end

    context 'when user voted up' do
      let!(:vote) { create(:vote, votable: votable, user: user) }
      it 'return true' do
        expect(votable).to have_positive_vote(user)
      end
    end
  end

  describe '#has_negative_vote?' do
    context 'when user did not vote down' do
      it 'return false' do
        expect(votable).to_not have_negative_vote(user)
      end
    end

    context 'when user voted down' do
      let!(:vote) { create(:negative_vote, votable: votable, user: user) }
      it 'return true' do
        expect(votable).to have_negative_vote(user)
      end
    end
  end

  describe '#rating' do
    positive = rand(10)
    negative = rand(10)

    it 'calculate sum of all associated votes' do
      create_list(:vote, positive, votable: votable)
      create_list(:negative_vote, negative, votable: votable)
      expect(votable.rating).to eq(positive - negative)
    end
  end
end 