redis-server-install:
    pkg.installed:
        - pkgs:
            - redis-server

    file.managed:
        - name: /etc/redis/redis.conf
        - source: salt://elife/config/etc-redis-redis.conf
        - template: jinja
        # by default, redis runs as a purely in-memory service, no persistence
        # projects should override redis.conf if they need different settings
        - replace: False 
        - require:
            - pkg: redis-server-install
            - file: /var/run/redis
            - file: /var/log/redis-server.log
        - listen_in:
            - service: redis-server

redis-server:
    file.managed:
        - name: /etc/init.d/redis
        - source: salt://elife/config/etc-init.d-redis
        - mode: 755

    service.running:
        - require:
            - pkg: redis-server-install
            - file: redis-server-install
            - file: redis-server
        - watch:
            - file: redis-server

/var/log/redis-server.log:
    file.managed:
        - user: redis
        - mode: 640

/var/run/redis:
    file.directory:
        - user: redis
        - group: redis
        - mode: 700
        - makedirs: True
