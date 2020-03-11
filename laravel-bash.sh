#! /bin/bash
# Script untuk menguduh laravel project dan melakukan setup ke xampp linux.

echo '\033[0;31mMasukkan Nama Project dan Versi Laravel'
echo '\033[1;30m======================================='

echo '\033[0;31mNama Project :'
read nama

echo '\033[0;31mMasukkan Versi Project (bisa tidak diisi) :'
read versi

## pindah ke direktori Ngoding tempat project laravel
## sesuaikan dengan lokasi project anda
echo '\033[0;32m+ \033[0mPindah ke direktori Templates'
cd $HOME/Templates

## Periksa jika nama project yang dimasukkan sudah ada
if [ -d $nama ]; then
  echo '\033[0;31mâœ– nama project '"$nama"' sudah ada'
  exit
fi

## Download Laravel
echo '\033[0;32m+ \033[0mMengunduh Laravel...'
composer create-project --prefer-dist laravel/laravel $nama $versi
echo '\033[0;32m+ \033[0m...Selesai Mengunduh Laravel...\n'

## Menambahkan host ke /etc/hosts
echo '\033[0;32m+ \033[0mMenambahkan '"$nama"' ke /etc/hosts'
echo "127.0.0.1 "$nama".test" | sudo tee -a /etc/hosts > /dev/null
echo '\033[0;32m+ \033[0m...Selesai Menambahkan Host...\n'

## Membuat Alias Pada httpd.conf
echo '\033[0;32m+ \033[0mMenambahkan Aliases '"$nama"' ke httpd.conf'
sudo tee -a /opt/lampp/etc/httpd.conf > /dev/null << EOT

# $nama.test
Alias /$nama "/home/ipulmisaja/Templates/$nama/"
<Directory "/home/ipulmisaja/Templates/$nama/">
	AllowOverride All
	Order allow,deny
	Allow from all
</Directory>
EOT
echo '\033[0;32m+ \033[0m...Selesai Menambahkan Aliases...\n'

## Membuat Virtual Host Baru pada httpd-vhosts.conf
echo '\033[0;32m+ \033[0mMenambahkan VirtualHost '"$nama"' ke httpd-vhost.conf'
sudo tee -a /opt/lampp/etc/extra/httpd-vhosts.conf > /dev/null << EOT

# $nama.test
<VirtualHost *:80>
    ServerAdmin webmaster@$nama.test
    DocumentRoot "/home/ipulmisaja/Templates/$nama/public"
    ServerName $nama.test
    ServerAlias www.$nama.test
    ErrorLog "logs/$nama.dev-error_log"
    CustomLog "logs/$nama.dev-error_log" common
</VirtualHost>
EOT

echo '\033[0;32m+ \033[0m...Selesai Menambahkan VirtualHost...\n'

# Info
echo '\033[0;32m+ \033[0m...Seluruh Rangkaian Proses Sudah Selesai, Happy Coding...'
