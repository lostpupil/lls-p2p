class V1::DealApi < V1
end
V1::DealApi.define do
  on get do

  end

  on post do
    on 'payment', param('a'), param('b'), param('money') do |a, b, money|
      begin
        payment = Payment.transfer(a, b, money.to_i)
        as_json do
          {data: {payment: payment}}
        end
      rescue Exception => e
        as_json 403 do
          {err: e}
        end
      end
    end

    on 'repayment', param('a'), param('b'), param('money') do |a, b, money|
      begin
        repayment = Repayment.transfer(a, b, money.to_i)
        as_json do
          {data: {repayment: repayment}}
        end
      rescue Exception => e
        as_json 403 do
          {err: e}
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
