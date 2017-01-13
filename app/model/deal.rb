class Deal < Sequel::Model
  plugin :single_table_inheritance, :type

  def self.show_records(a, b)
    u_a = User.first(id: a) #borrow
    u_b = User.first(id: b) #lend
    raise 'user not found' if u_a.nil? or u_b.nil?
    p_query = Payment.where(a: u_a.id, b: u_b.id)
    rp_query = Repayment.where(a: u_a.id, b: u_b.id)
    {
      payment: {
        records: p_query,
        total: p_query.map(&:money).reduce(:+)
      },
      repayment: {
        records: rp_query,
        total: rp_query.map(&:money).reduce(:+)
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

      raise 'trick or treat' if money <= 0
      if money > u_a.money
        raise 'target does not have enough money'
      else
        raise 'target does not have enough money' if u_a.money < 0
        borrow = Payment.where(a: a, b: b).map(&:money).reduce(:+) || 0
        lend = Repayment.where(a: a, b: b).map(&:money).reduce(:+) || 0
        debt = borrow - lend
        raise 'target does not own that much' if money > debt
        u_a.update(:money => Sequel.-(:money, money))
        u_b.update(money: Sequel.+(:money, money))
        Repayment.create(a: u_a.id, b: u_b.id, money: money, description: "#{u_a.username} request $#{money} from #{u_b.username}")
      end
    end
  end
end
