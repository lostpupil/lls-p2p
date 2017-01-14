#lls-p2p

## Description

使用Cuba Sequel Postgres Mina Thin     
https://github.com/lostpupil/cubanana    

1.12 21pm~23:30pm 完成项目的部署以及创建用户查看用户账户的api。    
查看用户的时候如果输入了非法的uid，会使用User.new来做默认处理。    
1.13 9am~12am 完成借款以及还款的api。    
这里借款以及还款时候需要注意的条件还是挺多的，除了账户需要账户余额之外，还需要判断用户是不是向另外一个用户借了那么多钱。同时api请求也需要判断ab用户是否存在。如果不存在，则raise一个用户不存在的error。也需要判断a和b是同一个人。   
1.13 晚上想了一下，发现我一开始只是查询了一半的记录，只有自己的借款，但是没有自己被借款的记录，大意了。    

为了方便，这边其实在货币上面都是用的Integer作为单位，单位是分，考虑到Decimal可能对于货币更加适合，但是这边为了简化一些操作于是就用了Integer。    

BTW,似乎用户系统在这边并不需要，好像除了存储用户名和密码之外并不需要去验证API的权限，所以我这边就没有加上奇怪的gem，这个用户模块是我之前自己写的，基本上实现了不明文存储，然后至于api鉴权这边我在plugin里面写了一个gate_keeper的方法，这样就需要做一个登陆的接口，返回auth_token以及user_id，然后我会在gate_keeper的地方去做权限验证。如果不符合就返回401 unauthorized。

## API Example

### 创建一个用户    
POST /api/v1/users     
1: -d "username=banana&password=banana"    
2: -d "username=banana&password=banana&money=100"    

### 查看一个用户
GET /api/v1/users/:id    
成功会返回用户的id，money，以及交易的记录，交易的total

### 发起借款请求
POST /api/v1/deals/payment    
-d "a=a的idb=b的id&money=10"    
a: 借款人 b:被借款人

### 发起还款请求
POST /api/v1/deals/repayment    
-d "a=a的idb=b的id&money=10"    
a: 还款人 b:被还款人

### 查看a与b之前的交易记录以及金额
GET /api/v1/deals    
example: GET /api/v1/deals?a=cd39f5b5-557f-4727-9ce7-0d4c3df6f050&b=4863161c-b68d-47a2-a1ec-caab04863d23

### Demo Account
apple 132df720-3ca8-4b14-9f5e-0e2202164b5b     
banana 639b1ce0-7d1f-46cb-a45e-4d9be4e1a794    
watermelon 6eb8b743-2984-4b69-8b1a-e508df878d36

## 一些奇怪的问题
之前一直觉得cuba的dsl，写起来很整齐，就会觉得很整齐的代码其实本身也需要去重构。Cuba的api框架比Grape少了很多诸如参数验证的地方，这需要你在代码中去自己做判断，如果使用Cuba的话，是没有必要拆分这么多的目录层次以及文件的，这样其实本身违反了simplicity的原则，但是为了项目的可读，可扩展性，于是做出了一些折中的举动。