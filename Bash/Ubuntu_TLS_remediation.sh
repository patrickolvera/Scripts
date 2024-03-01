# 1) Check what service is using the vulnerable port
ss -tunlp | grep [port]

# 2) For Apache service 
vim /etc/apache2/mods-enabled/ssl.conf
    # Find the line "SSLProtocol" and add -TLSv1 -TLSv1.1
    # Save the changes

# 3) Restart the apache server
systemctl restart apache2
    #confirm apache is running without errors
systemctl status apache2

