class Deal < Sequel::Model
  plugin :single_table_inheritance, :type

  def self.show_records(a, b)
    u_a = User.first(id: a) #borrow
    u_b = User.first(id: b) #lend
    raise 'user not found' if u_a.nil? or u_b.nil?
    p_query_in = Payment.where(a: u_a.id, b: u_b.id)
    p_query_out = Payment.where(b: u_a.id, a: u_b.id)
    rp_query = Repayment.where(a: u_a.id, b: u_b.id)
    {
      payment: {
        records_in: p_query_in,
        records_out: p_query_out,
        total_in: p_query_in.sum(:money),
        total_out: p_query_out.sum(:money)
      },
      repayment: {
        records: rp_query,
        total: rp_query.sum(:money)
      }
    }
  end
end

class Payment < Deal
  def self.transfer(a,b,money)
    User.db.transaction do
      # for_update is a Pessimistic Locking
      u_a = User.for_update.first(id: a) #borrow
      u_b = User.for_update.first(id: b) #lend
      raise 'you are so interesting' if u_a == u_b
      raise 'user not found' if u_a.nil? or u_b.nil?
      raise 'trick or treat' if money <= 0
      if money > u_b.money
        raise 'target does not have enough money'
      else
        raise 'target does not have enough money' if u_b.money < 0
        u_a.update(:money => Sequel.+(:money, money))
        u_b.update(money: Sequel.-(:money, money))
        Payment.create(a: u_a.id, b: u_b.id, money: money, description: "#{u_a.username} request $#{money} from #{u_b.username}")
      end
    end
  end
end

class Repayment < Deal
  def self.transfer(a,b,money)
    User.db.transaction do
      # for update is a Pessimistic Locking
      u_a = User.for_update.first(id: a) #borrow
      u_b = User.for_update.first(id: b) #lend

      raise 'you are so interesting' if u_a == u_b
      raise 'user not found' if u_a.nil? or u_b.nil?
      raise 'trick or treat' if money <= 0
      if money > u_a.money
        raise 'target does not have enough money'
      else
        raise 'target does not have enough money' if u_a.money < 0
        borrow = Payment.where(a: a, b: b).sum(:money)
        lend = Repayment.where(a: a, b: b).sum(:money)
        debt = borrow - lend
        raise 'target does not own that much' if money > debt #他并不欠你这么多💰
        u_a.update(:money => Sequel.-(:money, money))
        u_b.update(money: Sequel.+(:money, money))
        Repayment.create(a: u_a.id, b: u_b.id, money: money, description: "#{u_a.username} return $#{money} from #{u_b.username}")
      end
    end
  end
end
