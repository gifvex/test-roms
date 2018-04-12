## WLA DX
[https://github.com/vhelin/wla-dx](https://github.com/vhelin/wla-dx)
* cmake
* gcc-g++
* make
```
cmake -G "Unix Makefiles"
make install
```

## test-roms
```
wla-gb -o test.o tests/$test.s
wlalink linkfile $test.gb
```
