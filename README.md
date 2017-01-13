#lls-p2p

## Description

使用Cuba Sequel Postgres Mina Thin     

1.12 21pm~23:30pm 完成项目的部署以及创建用户查看用户账户的api。    
查看用户的时候如果输入了非法的uid，会使用User.new来做默认处理。    
1.13 9am~12am 完成借款以及还款的api。    
这里借款以及还款时候需要注意的条件还是挺多的，除了账户需要账户余额之外，还需要判断用户是不是向另外一个用户借了那么多钱。同时api请求也需要判断ab用户是否存在。如果不存在，则raise一个用户不存在的error。    

## API Example

### 创建一个用户    
POST /api/v1/users     
1: -d "username=banana&password=banana"    
2: -d "username=banana&password=banana&money=100"    

### 查看一个用户
GET /api/v1/users/:id

### 发起借款请求
POST /api/v1/payment    
-d "a=a的idb=b的id&money=10"    
a: 借款人 b:被借款人

### 发起还款请求
POST /api/v1/repayment    
-d "a=a的idb=b的id&money=10"    
a: 还款人 b:被还款人