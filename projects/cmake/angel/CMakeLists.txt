include (${COMMON_INCLUDE})

include_directories(${BUNDLES})
include_directories(${BUNDLES}/sonia-prime)

set (PROJECT_NAME angel)
set (PROJECT_SOURCES
    ${BUNDLES}/sonia-prime/applied/scoped_services.cpp
)

if ( CMAKE_SYSTEM_NAME STREQUAL "Windows")
    set (PROJECT_SOURCES ${PROJECT_SOURCES}
        ${BUNDLES}/sonia-prime/applied/win_console.cpp
    )
elseif ( CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set (PROJECT_SOURCES ${PROJECT_SOURCES}
        ${BUNDLES}/sonia-prime/applied/linux_console.cpp
    )
endif ()

add_executable(${PROJECT_NAME} ${PROJECT_SOURCES})
#add_definitions(${FACADE_DEFINITIONS})
#set_target_properties(${PROJECT_NAME} PROPERTIES FOLDER "test")

sonia_link_library(${PROJECT_NAME} sonia-prime-lib)
sonia_link_library(${PROJECT_NAME} sonia-prime)

#if (BUILD_MINGW)

#elseif (BUILD_ANDROID)

#else ()
#    target_link_libraries(${MODULE_NAME} ${BOOST_LOCALE} ${OPENSSL})
#endif()

target_link_libraries(${PROJECT_NAME} ${PLATFORM_LIBS} ${ZLIB} ${BOOST_SYSTEM} ${BOOST_CHRONO} ${BOOST_SERIALIZATION} ${BOOST_TEST_LIB} ${BOOST_PROGRAM_OPTIONS} ${BOOST_FILESYSTEM})
#target_link_libraries(${PROJECT_NAME} ${BOOST_CHRONO} ${BOOST_TEST_LIB} ${BOOST_PROGRAM_OPTIONS})