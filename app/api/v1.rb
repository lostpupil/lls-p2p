class V1 < Cuba; end
V1.define do
  on get do
    on root do
      as_json { {data: 'hello world'} }
    end
  end
  on post do
  end
end
