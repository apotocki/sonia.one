include (${COMMON_INCLUDE})

include_directories(${BUNDLES})
include_directories(${BUNDLES}/sonia-prime)

set (BUNDLE_NAME angel)
set (BUNDLE_SOURCES

)

if ( CMAKE_SYSTEM_NAME STREQUAL "Windows")
    set (BUNDLE_SOURCES ${BUNDLE_SOURCES}
        ${BUNDLES}/sonia-prime/applied/win_console.cpp
    )
elseif ( CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set (BUNDLE_SOURCES ${BUNDLE_SOURCES}
        ${BUNDLES}/sonia-prime/applied/linux_console.cpp
    )
endif ()

add_executable(${BUNDLE_NAME} ${BUNDLE_SOURCES})
#add_definitions(${FACADE_DEFINITIONS})
#set_target_properties(${BUNDLE_NAME} PROPERTIES FOLDER "test")

sonia_link_library(${BUNDLE_NAME} sonia-prime-lib)
sonia_link_library(${BUNDLE_NAME} sonia-prime)

#if (BUILD_MINGW)

#elseif (BUILD_ANDROID)

#else ()
#    target_link_libraries(${MODULE_NAME} ${BOOST_LOCALE} ${OPENSSL})
#endif()

target_link_libraries(${BUNDLE_NAME} ${PLATFORM_LIBS} ${BOOST_SYSTEM} ${BOOST_CHRONO} ${BOOST_SERIALIZATION} ${BOOST_TEST_LIB} ${BOOST_PROGRAM_OPTIONS} ${BOOST_FILESYSTEM})
#target_link_libraries(${BUNDLE_NAME} ${BOOST_CHRONO} ${BOOST_TEST_LIB} ${BOOST_PROGRAM_OPTIONS})