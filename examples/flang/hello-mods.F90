program hello_mods
    use, intrinsic :: iso_c_binding, only: c_size_t
    use, intrinsic :: iso_fortran_env, only: output_unit
    implicit none

    ! Declare a variable of type c_size_t
    integer(c_size_t) :: my_size

    ! Assign a value to it
    my_size = 4096_c_size_t

    ! Write to standard output using output_unit
    write(output_unit, *) "Hello, World!"
    write(output_unit, *) "The value of c_size_t is:", my_size

end program hello_mods
