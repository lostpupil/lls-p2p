#lls-p2p

## Description

使用Cuba Sequel Postgres Mina Thin     

1.12 21pm~23:30pm 完成项目的部署以及创建用户查看用户账户的api。    
查看用户的时候如果输入了非法的uid，会使用User.new来做默认处理。

## API Example

### 创建一个用户    
POST /api/v1/users     
1: -d "username=banana&password=banana"    
2: -d "username=banana&password=banana&money=100"    

### 查看一个用户
GET /api/v1/users/:id
