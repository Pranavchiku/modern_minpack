Modernized Minpack

### GFortran

For `example_hybrd.f90` it looks like this ( assuming you are in `minpack/examples/` directory )
```sh
gfortran -c ../src/minpack.f90
gfortran -c example_hybrd.f90 -I.
gfortran example_hybrd.o minpack.o -o example_hybrd -I.
./example_hybrd
```

### LFortran

For `example_hybrd.f90` it looks like this ( assuming you are in `minpack/` directory )
```sh
lfortran --implicit-typing --implicit-interface ./src/minpack.f90 -c
lfortran --implicit-typing --implicit-interface ./examples/example_hybrd.f90
```

### Note
Make sure to keep compiled `minpack.o` files from GFortran and LFortran in different directories 
else it will throw [#1229](https://github.com/lfortran/lfortran/issues/1229)
