echo "Enter the name of the file: " 
read name

gfortran -c ../src/minpack.f90
gfortran -c $name.f90 -I.
gfortran $name.o minpack.o -o $name -I.
./$name
