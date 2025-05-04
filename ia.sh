mkdir -p /mnt/external/0/tmp
cd /mnt/external/0/tmp
curl -LO https://github.com/EgorV-cmyk/special-octo-computing-machine/archive/refs/tags/pre-release.tar.gz &&
tar -xf * &&
rm -rf *.tar.gz
chmod 777 /mnt/external/0/tmp/*/install.sh
echo "Run /mnt/external/0/tmp/*/install.sh"
