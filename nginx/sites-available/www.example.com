#Default Server block
server {
       listen 3200 default_server;
       server_name _;
       access_log /var/log/nginx/wrongdomain.log;
       error_page 404 /custom_404.html;
       location / {
           return 404;
       }
       location = /custom_404.html {
       }
       
}
#Example.com Server Block
server {

       listen 3200;
       server_name www.example.com example.com;
       access_log /var/log/nginx/3200.log main;
              
       location / {
		proxy_pass http://nginx-test;
	}
       location = /custom_404.html {
       }

}

#Proxy Server Block
server {
       listen localhost:3400;
       server_name www.example.com example.com;
       access_log /var/log/nginx/3400.log main;
       location / { 
               try_files $uri /index.html;
        }
       location = /custom_404.html {
       }
}
        
