#!/bin/sh
for method in data fast json stor clon; do
  echo $method
  for i in 1 2 3 4 5 6 7 8 9 10; do
    /usr/bin/time -f '%U' perl profile.pl $method 100000
  done
done
