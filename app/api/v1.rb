class V1 < Cuba; end
V1.define do
  on 'users' do
    run V1::UserApi
  end
  
  on get do
    on root do
      as_json { {data: 'hello world'} }
    end
  end
end
