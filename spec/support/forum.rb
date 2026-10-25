# frozen_string_literal: true

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before do
    stub_request(:get, 'https://foro.makigas.es/api/discussions')
      .with(query: hash_including('page' => { 'limit' => '5' }, 'sort' => '-createdAt'))
      .to_return(
        headers: { 'Content-Type' => 'application/json' },
        body: Rails.root.join('spec/fixtures/forum/discussions.json').read
      )
  end
end
