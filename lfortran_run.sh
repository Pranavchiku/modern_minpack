echo "Enter the name of the file: " 
read name

lfortran ./src/minpack.f90 -c
lfortran ./examples/$name.f90
