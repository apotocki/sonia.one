# this one is important
SET (BUILD_MINGW False)
SET (BUILD_CLANG True)

SET (CMAKE_C_COMPILER             clang)
SET (CMAKE_CXX_COMPILER           clang++)
SET (SONIA_C_AND_CXX_COMMON "-stdlib=libc++ -std=c++17")
