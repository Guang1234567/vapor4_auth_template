# Get Started

本文简要描述如何借助此项目快速搭建一个后端程序.

## 用法

1. 安装 vapor cli 工具

```bash
brew install vapor
```


2. 基于模板创建项目

```bash
vapor new demo_swift_server_vapor_auth --template https://github.com/Guang1234567/vapor4_auth_template
```


## 直接借助 docker 运行 (推荐)

3. 安装并登陆 docker

https://www.docker.com/get-started

安装成功以及登陆后的截图 (macOS)

![](/global/img/docker.png)


4. 通过 docker 来运行

```bash

# 1)
cd demo_swift_server_vapor_auth

# 2)
docker pull lihansey/vapor4_auth_template:latest

# 3)
docker-compose up app

# 4) 此时程序正常运行中...

# 5) 生成或者升级数据库
docker-compose up migrate

# 5) 安全地停止程序
docker-compose down
# or
docker-compose down --volumes  # --volumes 表示退出程序的同时清理数据库里面的表记录, 但不删除表本身

# 6) 重新运行
docker-compose up app

# 7) 注意此时(重新运行后)不需要重新生成或者升级数据库
❌ docker-compose up migrate 

```


## 手动配置环境运行

3. 安装编译链

**Swift 5.2.4**

Date: May 20, 2020  

Tag: [swift-5.2.4-RELEASE](https://github.com/apple/swift/releases/tag/swift-5.2.4-RELEASE)

Platform | Toolchain | Docker Tag                                                               
--- | --- | ---
[Xcode 11.5](https://itunes.apple.com/app/xcode/id497799835 "Download")\* | [Toolchain](https://swift.org/builds/swift-5.2.4-release/xcode/swift-5.2.4-RELEASE/swift-5.2.4-RELEASE-osx.pkg "Download") <br/> [(Debugging Symbols)](https://swift.org/builds/swift-5.2.4-release/xcode/swift-5.2.4-RELEASE/swift-5.2.4-RELEASE-osx-symbols.pkg "Debugging Symbols") | Unavailable
[Ubuntu 16.04](https://swift.org/builds/swift-5.2.4-release/ubuntu1604/swift-5.2.4-RELEASE/swift-5.2.4-RELEASE-ubuntu16.04.tar.gz "Download") |           [Toolchain](https://swift.org/builds/swift-5.2.4-release/ubuntu1604/swift-5.2.4-RELEASE/swift-5.2.4-RELEASE-ubuntu16.04.tar.gz "Download") <br/> [(PGP Signature)](https://swift.org/builds/swift-5.2.4-release/ubuntu1604/swift-5.2.4-RELEASE/swift-5.2.4-RELEASE-ubuntu16.04.tar.gz.sig "PGP Signature") | [5.2.4-xenial](https://hub.docker.com/_/swift "5.2.4-xenial")
[Ubuntu 18.04](https://swift.org/builds/swift-5.2.4-release/ubuntu1804/swift-5.2.4-RELEASE/swift-5.2.4-RELEASE-ubuntu18.04.tar.gz "Download") | [Toolchain](https://swift.org/builds/swift-5.2.4-release/ubuntu1804/swift-5.2.4-RELEASE/swift-5.2.4-RELEASE-ubuntu18.04.tar.gz "Download") <br/> [(PGP Signature)](https://swift.org/builds/swift-5.2.4-release/ubuntu1804/swift-5.2.4-RELEASE/swift-5.2.4-RELEASE-ubuntu18.04.tar.gz.sig "PGP Signature")| [5.2.4-bionic](https://hub.docker.com/_/swift "5.2.4-bionic")
[Ubuntu 20.04](https://swift.org/builds/swift-5.2.4-release/ubuntu2004/swift-5.2.4-RELEASE/swift-5.2.4-RELEASE-ubuntu20.04.tar.gz "Download") | [Toolchain](https://swift.org/builds/swift-5.2.4-release/ubuntu2004/swift-5.2.4-RELEASE/swift-5.2.4-RELEASE-ubuntu20.04.tar.gz "Download") <br/> [(PGP Signature)](https://swift.org/builds/swift-5.2.4-release/ubuntu2004/swift-5.2.4-RELEASE/swift-5.2.4-RELEASE-ubuntu20.04.tar.gz.sig "PGP Signature") | [5.2.4-focal](https://hub.docker.com/_/swift "5.2.4-focal")              
[CentOS 8](https://swift.org/builds/swift-5.2.4-release/centos8/swift-5.2.4-RELEASE/swift-5.2.4-RELEASE-centos8.tar.gz "Download") | [Toolchain](https://swift.org/builds/swift-5.2.4-release/centos8/swift-5.2.4-RELEASE/swift-5.2.4-RELEASE-centos8.tar.gz "Download") <br/> [(PGP Signature)](https://swift.org/builds/swift-5.2.4-release/centos8/swift-5.2.4-RELEASE/swift-5.2.4-RELEASE-centos8.tar.gz.sig "PGP Signature") | [5.2.4-centos8](https://hub.docker.com/_/swift "5.2.4-centos8")          
[Amazon Linux 2](https://swift.org/builds/swift-5.2.4-release/amazonlinux2/swift-5.2.4-RELEASE/swift-5.2.4-RELEASE-amazonlinux2.tar.gz "Download") | [Toolchain](https://swift.org/builds/swift-5.2.4-release/amazonlinux2/swift-5.2.4-RELEASE/swift-5.2.4-RELEASE-amazonlinux2.tar.gz "Download") <br/> [(PGP Signature)](https://swift.org/builds/swift-5.2.4-release/amazonlinux2/swift-5.2.4-RELEASE/swift-5.2.4-RELEASE-amazonlinux2.tar.gz.sig "PGP Signature") | [5.2.4-amazonlinux2](https://hub.docker.com/_/swift "5.2.4-amazonlinux2")

*Swift 5.2.4 is available as part of [Xcode 11.5](https://itunes.apple.com/app/xcode/id497799835).

4. 安装 [postgres](https://postgresapp.com/downloads.html)

推荐下载下面截图这个 all-in-one 版本, 截图时间: 2020-08-11

![](/global/img/db_postgres.png)

https://github.com/PostgresApp/PostgresApp/releases/download/v2.3.5/Postgres-2.3.5-10-11-12.dmg

5. 编译运行

```bash
  cd demo_swift_server_vapor_auth

  swift build -Xswiftc -g -c debug && .build/debug/Run --log debug --env development.custom_name
```


6. 升级数据库

```bash
.build/debug/Run migrate --log debug --env development.custom_name
```

7. 调试 API

例子截取自 `./Tests/AppRestApiTests/Controllers/UserController.http`

```http
# 创建新 user

POST http://{{host}}/users HTTP/1.1
content-type: application/json

{
  "name": "Vapor",
  "email": "test@vapor.codes",
  "password": "secret",
  "confirmPassword": "secret"
}

```


## 借助 docker 帮助测试人员测试

此章节主要描述以下几点:

- 开发者借助 docker 发布一个`测试镜像_version_001`帮助测试人员快速部署测试环境.

- `测试人员(A_tester)` 如何基于 `测试镜像_version_001` 创建自己的镜像 `测试镜像_version_001_A_tester` 来共享测试数据给 `测试人员(B_tester, C_tester, ...)`

- `测试人员(A_tester, B_tester, C_tester, ...)` 在镜像 `测试镜像_version_001_A_tester`的环境上测出 bug 时, 可以将此镜像共享给开发者快速部署bug 重现的环境

1. 开发者和测试人员都要安装并登陆 docker

https://www.docker.com/get-started

安装成功以及登陆后的截图 (macOS)

![](/global/img/docker.png)

2. 开发者制作 "第一个版本的镜像"

> 有源码才能制作出 "第一个版本的镜像", 如果测试人员有源码也能制作!!!

```bash
# 1) 制作出 "第一个版本的镜像"
docker-compose build

# 2) 查看制作出来的镜像
docker images

```

![](/global/img/docker_build_image.png)


| REPOSITORY | TAG | IMAGE ID | CREATED | SIZE |
| --- | --- | --- | --- | --- |
| lihansey/vapor4_auth_template | latest | 9b8e689dc3f9 | 2 hours ago | 550MB |


```bash
# 3) 开发者将 docker-compose.staging.yml 拷贝 or 其他方式(git)给到测试人员
```


```file: docker-compose.staging.yml```
```yaml
# Docker Compose file for Vapor
#
# Install Docker on your system to run and test
# your Vapor app in a production-like environment.
#
# Note: This file is intended for testing and does not
# implement best practices for a production deployment.
#
# Learn more: https://docs.docker.com/compose/reference/
#
#   Build images: docker-compose build
#      Start app: docker-compose up app
# Start database: docker-compose up db
# Run migrations: docker-compose up migrate
#       Stop all: docker-compose down (add -v to wipe db)
# Wiping database
#       Stop with wipe: docker-compose down --volumes
#       or
#       docker volume ls
#       docker volume rm xxx_db_data
#
version: '3.7'

volumes:
  db_data:

x-shared_environment: &shared_environment
  LOG_LEVEL: ${LOG_LEVEL:-debug}
  DATABASE_HOST: db
  DATABASE_NAME: vapor_database_dev_custom
  DATABASE_USERNAME: vapor_username_dev_custom
  DATABASE_PASSWORD: vapor_password_dev_custom
  POSTGRES_USER: vapor_username_dev_custom
  POSTGRES_PASSWORD: vapor_password_dev_custom
  POSTGRES_DB: vapor_database_dev_custom

services:
  app:
    image: lihansey/vapor4_auth_template:latest
    build:
      context: .
    environment:
      <<: *shared_environment
    depends_on:
      - db
    ports:
      - '8080:8080'
#    user: '0' # uncomment to run as root for testing purposes even though Dockerfile defines 'vapor' user.
#    command: ["serve", "--env", "production", "--hostname", "0.0.0.0", "--port", "8080"]
    command: ["serve", "--hostname", "0.0.0.0", "--port", "8080"]
  migrate:
    image: lihansey/vapor4_auth_template:latest
    build:
      context: .
    environment:
      <<: *shared_environment
    depends_on:
      - db
    command: ["migrate", "--yes"]
    deploy:
      replicas: 0
  revert:
    image: lihansey/vapor4_auth_template:latest
    build:
      context: .
    environment:
      <<: *shared_environment
    depends_on:
      - db
    command: ["migrate", "--revert", "--yes"]
    deploy:
      replicas: 0
  db:
    image: postgres:12-alpine
    volumes:
      - ./docker/db_data:/var/lib/postgresql/data/pgdata
    environment:
      PGDATA: /var/lib/postgresql/data/pgdata
      <<: *shared_environment
    ports:
      - '5432:5432'
```

需要注意的是下面这两段代码, 测试人员可根据自身需求进行改动:

```yaml
x-shared_environment: &shared_environment
  LOG_LEVEL: ${LOG_LEVEL:-debug}                    # 不要改
  DATABASE_HOST: db                                 # 不要改
  DATABASE_NAME: vapor_database_dev_custom          # 可改
  DATABASE_USERNAME: vapor_username_dev_custom      # 可改
  DATABASE_PASSWORD: vapor_password_dev_custom      # 可改
  POSTGRES_USER: vapor_username_dev_custom          # 可改
  POSTGRES_PASSWORD: vapor_password_dev_custom      # 可改
  POSTGRES_DB: vapor_database_dev_custom            # 可改
```
和

```yaml
  db:
    image: postgres:12-alpine
    volumes:
      - ./docker/db_data:/var/lib/postgresql/data/pgdata
```

其中 `./docker/db_data` 是宿主机器的数据库数据存储目录, docker 虚拟机将 `/var/lib/postgresql/data/pgdata` 映射到此目录上.


```bash
# 4) 测试人员进入 docker-compose.staging.yml 所在目录, 然后运行后端程序

docker-compose -f docker-compose.staging.yml up app
```

```bash
# 5) 测试人员(A_tester)测出个 bug or 想共享数据库数据给其他测试人员(B_tester, C_tester, ...), 此时需先备份数据

# 查看当前数据库容器的 id
╰─ docker container ls

CONTAINER ID        IMAGE
39b93dd95d5d        lihansey/vapor4_auth_template:latest
e41a632d0a1a        postgres:12-alpine

# e41a632d0a1a 就是当前数据库容器的 id, 接着敲下面的命令备份数据库
╰─ docker run -i -t --rm --volumes-from e41a632d0a1a  -v $(pwd)/docker/backup:/backup postgres:12-alpine tar czvf /backup/backup_db_postgres_data_2020_08_11_21_40.tar -C /var/lib/postgresql/data/pgdata .

```

```bash
# 6) 其他测试人员(B_tester, C_tester, ...) 拿到 ./backup/backup_db_postgres_data_2020_08_11_21_40.tar 后,将其恢复

# 首先备份自己当前环境的数据
╰─ docker container ls
CONTAINER ID        IMAGE
79c93dd95d5d        lihansey/vapor4_auth_template:latest
a51a672d0a1a        postgres:12-alpine

╰─ docker run -i -t --rm --volumes-from a51a672d0a1a  -v $(pwd)/docker/backup:/backup postgres:12-alpine tar czvf /backup/backup_db_postgres_data_2020_08_11_22_00_my.tar -C /var/lib/postgresql/data/pgdata .

# 接着,关闭 docker 运行环境 
# (要做下面的恢复操作才需要关闭, 如果是测出 bug, 只需不停地调用上面的命令备份数据即可, 然后把 backup_db_postgres_data_2020_08_11_22_00_my.tar 的下载链接粘贴到 issue 界面)
docker-compose down

# 接着,敲下面的命令恢复数据库数据
rm -rf ./docker/db_data && mkdir -p ./docker/db_data && tar xzvf ./docker/backup/backup_db_postgres_data_2020_08_11_21_40.tar -C ./docker/db_data

# 最后,重新运行 docker
docker-compose -f docker-compose.staging.yml up app

# 继续测试继续报 bug ...
```


## 重要命令回顾

- 运行

```bash
docker-compose -f docker-compose.staging.yml up app
```

- 关闭

```bash
docker-compose down

# or

docker-compose down --volumes # 关闭的同时清空数据
```

- 查看当前运行的服务

```bash
docker container ls
```

- 备份数据库

```bash
╰─ docker container ls
CONTAINER ID        IMAGE
79c93dd95d5d        lihansey/vapor4_auth_template:latest
a51a672d0a1a        postgres:12-alpine

╰─ docker run -i -t --rm --volumes-from a51a672d0a1a  -v $(pwd)/docker/backup:/backup postgres:12-alpine tar czvf /backup/backup_db_postgres_data_2020_08_11_22_00_my.tar -C /var/lib/postgresql/data/pgdata .
```

- 恢复数据库

```bash
rm -rf ./docker/db_data && mkdir -p ./docker/db_data && tar xzvf ./docker/backup/backup_db_postgres_data_2020_08_11_21_40.tar -C ./docker/db_data
```



