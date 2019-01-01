# this one is important
set (BUILD_MINGW True)

# the name of the target operating system
SET(CMAKE_SYSTEM_NAME Windows)

#SET(CMAKE_MAKE_PROGRAM make)
# which compilers to use for C and C++
SET(CMAKE_C_COMPILER gcc)
SET(CMAKE_CXX_COMPILER g++)
SET(CMAKE_RC_COMPILER windres)

# here is the target environment located
#SET(CMAKE_FIND_ROOT_PATH  /usr/i586-mingw32msvc /home/alex/mingw-install )

# adjust the default behaviour of the FIND_XXX() commands:
# search headers and libraries in the target environment, search 
# programs in the host environment
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)