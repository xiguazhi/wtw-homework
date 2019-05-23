#Install nginx package and watch config files for website
nginx:
  pkg:
    - installed
  service.running:
    - enable: True
    - reload: True
    - watch:
      - pkg: nginx
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/sites-available/www.example.com
      - file: /etc/nginx/proxy.conf

#Nginx primary config file
/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://nginx/nginx.conf
    - user: root
    - group: root
    - mode: 640

#Copy example.com server block
/etc/nginx/sites-available/www.example.com:
  file.managed:
    - source: salt://nginx/sites-available/www.example.com.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

#Create Symbolic Links for www.example.com
/etc/nginx/sites-enabled/www.example.com:
  file.symlink:
    - target: /etc/nginx/sites-available/www.example.com

#Add web directory and modify using jinja template
web_directory:
  file.recurse:
    - name: /usr/share/nginx/html
    - source: salt://nginx/html
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - clean: True

#Add nginx html file to appropriate directory and modify using jinja template
#/usr/share/nginx/html/index.html: 
#  file.managed:
#    - source: salt://nginx/html/index.html.jinja
#    - template: jinja
#    - user: root
#    - group: root
#    - mode: 644

#Add nginx proxy config options
copy_proxy_var_config:
  file.managed:
    - source: salt://nginx/proxy.conf
    - name: /etc/nginx/proxy.conf
    - user: root
    - group: root
    - mode: 644
