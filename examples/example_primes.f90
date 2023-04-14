module find_fit_module

!! This module contains a general function find_fit() for a nonlinear least
!! squares fitting. The function can fit any nonlinear expression to any data.

use minpack_module, only: wp, lmdif1

implicit none

private


public :: find_fit

contains

subroutine find_fit(data_x, data_y, expr, pars)
! Fits the (data_x, data_y) arrays with the function expr(x, pars).
! The user can provide any nonlinear function 'expr' depending on any number of
! parameters 'pars' and it must return the evaluated expression on the
! array 'x'. The arrays 'data_x' and 'data_y' must have the same
! length.
real(wp), intent(in) :: data_x(:)
real(wp), intent(in) :: data_y(:)
interface
    function expr(x, pars) result(y)
        import :: wp
        implicit none
        real(wp), intent(in) :: x(:)
        real(wp), intent(in) :: pars(:)
        real(wp) :: y(size(x))
    end function expr
end interface
real(wp), intent(inout) :: pars(:)

real(wp) :: tol, fvec(size(data_x))
integer :: iwa(size(pars)), info, m, n
real(wp), allocatable :: wa(:)

tol = sqrt(epsilon(1.0_wp))
m = size(fvec)
n = size(pars)
allocate(wa(m*n + 5*n + m))
call lmdif1(fcn, m, n, pars, fvec, tol, info, iwa, wa, size(wa))
if (info /= 1) error stop "failed to converge"

contains

    subroutine fcn(m, n, x, fvec, iflag)
    integer, intent(in) :: m
    integer, intent(in) :: n
    integer, intent(inout) :: iflag
    real(wp), intent(in) :: x(n)
    real(wp), intent(out) :: fvec(m)
    fvec(1) = iflag ! Suppress compiler warning
    fvec = data_y - expr(data_x, x)
    end subroutine fcn

end subroutine find_fit

end module find_fit_module

program example_primes

!! Find a nonlinear fit of the form `a*x*log(b + c*x)` to a list of primes.

use find_fit_module, only: find_fit
use minpack_module, only: wp
use iso_fortran_env, only: nwrite => output_unit

implicit none

real(wp) :: pars(3)
real(wp) :: y(20) = real([2.0_wp, 3.0_wp, 5.0_wp, 7.0_wp, 11.0_wp, 13.0_wp, 17.0_wp, 19.0_wp, 23.0_wp, 29.0_wp, 31.0_wp, &
                                    37.0_wp, 41.0_wp, 43.0_wp, 47.0_wp, 53.0_wp, 59.0_wp, 61.0_wp, 67.0_wp, 71.0_wp], wp)
real(wp) :: x(20)
integer :: i
pars = [1.0_wp, 1.0_wp, 1.0_wp]
x = [(real(i, wp), i=1,size(y))]
call find_fit(x, y, expression, pars)

write(nwrite, '(1p,5x,a/(5x,3e15.7))') 'pars: ',pars

contains

function expression(x, pars) result(y)
real(wp), intent(in) :: x(:)
real(wp), intent(in) :: pars(:)
real(wp) :: y(size(x)), d(size(x))
real(wp) :: a, b, c
a = pars(1)
b = pars(2)
c = pars(3)
d = b + c*x
y = a*x*log(d)
end function expression

end program example_primes
