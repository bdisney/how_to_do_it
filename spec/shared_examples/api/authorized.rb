shared_examples_for 'API authorized' do
  let!(:request_params) { try(:params) || {} }

  context 'unauthorized' do
    it 'responds with code 401 if request does not have access_token' do
      send(http_method, path, params: request_params.merge(format: :json))
      expect(response.status).to eq(401)
    end

    it 'responds with code 401 if access_token is invalid' do
      send(http_method, path, params: request_params.merge(format: :json, access_token: '123456'))
      expect(response.status).to eq(401)
    end
  end

  context 'authorized' do
    let!(:success_code) { http_method == :post ? 201 : 200 }

    it 'responds with success status code' do
      send(http_method.to_sym, path, params: request_params.merge(format: :json, access_token: access_token.token))
      expect(response.status).to eq(success_code)
    end
  end
end