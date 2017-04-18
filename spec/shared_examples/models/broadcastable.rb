shared_examples_for 'broadcastable' do
  klass_name = described_class.to_s
  describe "#{klass_name} broadcasting" do
    subject { build(klass_name.underscore.to_sym) }

    let!(:job) { "#{klass_name.pluralize}BroadcastJob".constantize }

    it 'broadcasts object after create' do
      allow(job).to receive(:perform_later).with(subject)
      subject.save!
    end
  end
end