echo "Enter the name of the file: " 
read name

lfortran --implicit-typing --implicit-interface ./src/minpack.f90 -c
lfortran --implicit-typing --implicit-interface ./examples/$name.f90
