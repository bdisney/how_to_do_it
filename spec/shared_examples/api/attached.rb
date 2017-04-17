shared_examples_for 'API attached' do
  let!(:attachment) { create(:attachment, attachable: attachable) }
  let!(:root) { attachable.class.to_s.underscore }

  before { get path, params: { format: :json, access_token: access_token.token } }

  it 'contains attachments list' do
    expect(response.body).to have_json_size(1).at_path("#{root}/attachments")
  end

  it 'each attachment contains attribute name' do
    expect(response.body).to be_json_eql('pic2.jpg'.to_json).at_path("#{root}/attachments/0/name")
  end

  it 'each attachment contains attribute src' do
    expect(response.body).to be_json_eql("/uploads/attachment/file/#{attachment.id}/pic2.jpg".to_json)
                                 .at_path("#{root}/attachments/0/src")
  end
end