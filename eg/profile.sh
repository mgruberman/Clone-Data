#!/bin/sh
for method in stor data fast clon json; do
  for i in 1 2 3 4 5 6 7 8 9 10; do
    echo $method
    /usr/bin/time -f '%U' perl profile.pl
  done
done
