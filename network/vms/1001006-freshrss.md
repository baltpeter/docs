# FreshRSS

RSS aggregator, available at freshrss.altpeter.me.

## Setup

1. Install dependencies: `apt install curl mysql-server apache2 php php-xml php-curl php-mysql php-json php-mbstring php-gmp php-intl php-zip`

2. Enable required Apache modules: `a2enmod headers expires rewrite`

3. Secure MySQL by running `mysql_secure_installation`, create the database and user by running `mysql -e "CREATE DATABASE freshrss; GRANT ALL PRIVILEGES ON freshrss.* TO 'freshrss'@'localhost' IDENTIFIED BY 'abc'"` and save the password as `~/.my.cnf`:
    ```
    [client]
    user=freshrss
    password=abc
    ```

4. Download and unpack FreshRSS: `wget https://github.com/FreshRSS/FreshRSS/archive/master.zip -O frss-tmp.zip; unzip frss-tmp.zip; mv FreshRSS-master/* /var/www; rm -r frss-tmp.zip FreshRSS-master`

5. Configure the Apache virtual host in `/etc/apache2/sites-enabled/000-default.conf`:
    ```
    <VirtualHost *:80>
        DocumentRoot /var/www/p          

        <Directory /var/www/p>
                AllowOverride AuthConfig FileInfo Indexes Limit
                Require all granted
        </Directory>

        ErrorLog ${APACHE_LOG_DIR}/freshrss_error.log
        CustomLog ${APACHE_LOG_DIR}/freshrss_access.log combined

        AllowEncodedSlashes On
    </VirtualHost>
    ```

6. Make sure Apache has access to all necessary files: `chown -R www-data:www-data /var/www`

7. Restart Apache: `systemctl restart apache2`

8. Open the web page in a browser and walk through the installation wizard.

9. Create a cronjob using `crontab -e` to automatically update the feeds: `*/5 * * * * www-data php -f /var/www/app/actualize_script.php > /tmp/FreshRSS.log 2>&1`

10. Install the ThreePanesView extension: `wget https://framagit.org/nicofrand/xextension-threepanesview/-/archive/master/xextension-threepanesview-master.zip -O tpv-tmp.zip; unzip tpv-tmp.zip -d /var/www/extensions; rm -r tpv-tmp.zip`

11. If necessary, fix the `base_url` in `/var/www/data/config.php`.

## Updates

Updates can be installed through the web interface.

## References

* https://freshrss.github.io/FreshRSS/en/admins/02_Installation.html
* https://www.dreamvps.com/tutorials/freshrss-installation-ubuntu/
* https://freshrss.github.io/FreshRSS/en/admins/03_Updating.html