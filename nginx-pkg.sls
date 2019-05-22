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

#Cleanup any site files not being monitored by Salt
cleanup_unknown_files:
  file.directory:
    - name: salt://nginx/sites-available/
    - clean: true

#Add example.com site config with all server blocks
/etc/nginx/sites-available/www.example.com:
  file.managed:
    - source: salt://nginx/sites-available/www.example.com.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

#Create symbolic link to example.com site 
/etc/nginx/sites-enabled/www.example.com:
  file.symlink:
    - target: /etc/nginx/sites-available/www.example.com
    - require:
      - file: /etc/nginx/sites-available/www.example.com

#Add nginx html file to appropriate directory and modify using jinja template
/usr/share/nginx/html/index.html:
  file.managed:
    - source: salt://nginx/html/index.html.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

#Add nginx proxy config options
/etc/nginx/proxy.conf:
  file.managed:
    - source: salt://nginx/proxy.conf
    - user: root
    - group: root
    - mode: 644
