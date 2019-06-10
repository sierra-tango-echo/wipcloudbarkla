if [ ! -d /mnt/data1/users ]; then
  mkdir -p /mnt/data1/users
  ln -s /users/software /mnt/data1/users/software
fi
