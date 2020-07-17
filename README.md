<p align="center">
    <img src="https://user-images.githubusercontent.com/1342803/43925087-512bb1de-9bf4-11e8-869f-057af9afadb9.png" width="320" alt="Auth Template">
    <br>
    <br>
    <a href="http://docs.vapor.codes/3.0/">
        <img src="http://img.shields.io/badge/read_the-docs-2196f3.svg" alt="Documentation">
    </a>
    <a href="https://discord.gg/vapor">
        <img src="https://img.shields.io/discord/431917998102675485.svg" alt="Team Chat">
    </a>
    <a href="LICENSE">
        <img src="http://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
    </a>
    <a href="https://circleci.com/gh/vapor/auth-template">
        <img src="https://circleci.com/gh/vapor/auth-template.svg?style=shield" alt="Continuous Integration">
    </a>
    <a href="https://swift.org">
        <img src="http://img.shields.io/badge/swift-5.2-brightgreen.svg" alt="Swift 4.1">
    </a>
</p>



## Usage

```bash
# 1)

brew install vapor

# 2)

vapor new demo_swift_server_vapor_auth --template https://github.com/Guang1234567/vapor4_auth_template
```

## Develop on `localhost`

### macOS

#### Serving `HTTPS` by `nginx`

1) Certificate generation 
    
    Also because HTTP/2 is a secure protocol by default, you'll need your own SSL certificate. You can generate a self-signed cert.pem and a cert.key files with the following command (fill out the details with some fake data and press enter).
    
    ```bash
        cd ./etc/nginx
        
        openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout cert.key -out cert.pem
    ```

2) install `nginx`
    
    https://docs.vapor.codes/4.0/deploy/nginx/
    
    ```bash
        brew install nginx
    ```
   
3) cfg ngnix
    
    https://github.com/Guang1234567/vapor4_auth_template/blob/b0f2b7e441faee47b11a329a966f18d6ad4b625f/etc/nginx/nginx.conf#L117-L153
    
    4) start `nginx`
    
    ```bash
        nginx -c ~/dev_kit/workspace/demo_swift_server_vapor_auth/etc/nginx/nginx.conf
    ```

5) check `HTTPS` Env
   
    Using your smartphone which under the same wifi with your macbookpro to browse:
   
    ```bash
        http://<your macOS IP>:8080/
        
        
        For example (Dont copy!):
        http://10.0.0.28:8080/
    ```
   
   then will see:
   
   ```html
        Welcome to nginx!
        
        If you see this page, the nginx web server is successfully installed and working. Further configuration is required.
        
        For online documentation and support please refer to nginx.org.
        Commercial support is available at nginx.com.
        
        Thank you for using nginx.
   ```
   
6) other command for nginx
   
   ```bash
   
   # quit nginx
   
   nginx -s quit
   
   
   # dry run and test
   
   nginx -c ~/dev_kit/workspace/demo_swift_server_vapor_auth/etc/nginx/nginx.conf -t

   ```
   
#### Start vapor web application and serving on `http://127.0.0.1:8080`
      
  ```bash
    swift build -Xswiftc -g -c debug && .build/debug/Run --log debug --env development.custom_name
  ```
      
  > note:
  >
  > [issue: Crashed when calling Bcrypt.hash](https://github.com/vapor/vapor/issues/2229#issuecomment-653721292) on
  >
  > - macOS catalina 10.15.6 with xcode 11.6
  > - macOS catalina 10.15.5 with xcode 11.5
   
  
then access vapor web application via `HTTPS`
      
  - on smartphone
  
  ```bash
   https://10.0.0.28/
   
   or
   
   https://10.0.0.28:443/
  ```
  
  - on PC
  
   ```bash
    https://127.0.0.1/
    
    or
    
    https://127.0.0.1:443/
   ```
  
  then both will see:
  
  ```html
    It works!
  ```
      
#### Test API via CLion with `swift plugin`

https://github.com/Guang1234567/vapor4_auth_template/blob/b0f2b7e441faee47b11a329a966f18d6ad4b625f/Tests/AppRestApiTests/Controllers/UserController.http#L1-L9
   
### Ubuntu

// in the process ... ( I dont have the Ubuntu -_-|| )