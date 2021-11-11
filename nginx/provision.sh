apt-get -y update

apt-get -y install nginx

cd /

rm -rf /var/www/html 
ln -s /vagrant/www /var/www/html 

service nginx start
