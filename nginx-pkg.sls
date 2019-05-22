nginx:
  pkg:
    - installed
  service.running:
    - watch:
      - pkg: nginx
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/sites-available/www.example.com
      - file: /etc/nginx/proxy.conf

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://nginx/nginx.conf
    - user: root
    - group: www-data
    - mode: 640

/etc/nginx/sites-available/www.example.com:
  file.managed:
    - source: salt://nginx/sites-available/www.example.com.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

/etc/nginx/sites-enabled/www.example.com:
  file.symlink:
    - target: /etc/nginx/sites-available/www.example.com
    - require:
      - file: /etc/nginx/sites-available/www.example.com

/usr/share/nginx/html/index.html:
  file.managed:
    - source: salt://nginx/html/index.html.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
/etc/nginx/proxy.conf:
  file.managed:
    - source: salt://nginx/proxy.conf
    - user: root
    - group: root
    - mode: 644
