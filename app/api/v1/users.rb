class V1::UserApi < V1
end
V1::UserApi.define do
  on get do
    on ':id' do |id|
      user = User.find(id: id)
      as_json do
        {
          data: {
            user: {
              money: user.money
            },
            payment:[],
            repayment: []
          }
        }
      end
    end
  end

  on post do
    on root do

      on param('username'), param('password') do |username, password|

        as_json do
          user = User.new(username: username)
          user.password = password
          unless req['money'].blank?
            user.money = req['money'].to_i if req['money'].to_i > 0
          end
          begin
            user.save
            as_json do
              {data: {id: user.id}}
            end
          rescue Exception => e
            as_json do
              {err: 'username already exists'}
            end
          end
        end
      end

      on true do
        as_json 403 do
          {err: 'missing params'}
        end
      end

    end
  end
end
