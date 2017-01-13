class Deal < Sequel::Model
  plugin :single_table_inheritance, :type
end

class Payment < Deal
  def self.transfer(a,b,money)
    User.db.transaction do
      # for update is a Pessimistic Locking
      u_a = User.for_update.first(id: a) #borrow
      u_b = User.for_update.first(id: b) #lend

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

  end
end
