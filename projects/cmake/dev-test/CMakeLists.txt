include (${COMMON_INCLUDE})

include_directories(${BUNDLES})
include_directories(${BUNDLES}/sonia-prime)
include_directories(${BUNDLES}/sonia-net)

set (BUNDLE_NAME dev-test)
set (BUNDLE_SOURCES
	${BUNDLES}/sonia-prime/applied/tests_support.cpp
    #${BUNDLES}/sonia-prime/tests/signal_test.cpp
    #${BUNDLES}/sonia-prime/tests/aio_test.cpp
    #${BUNDLES}/sonia-net/tests/transceiver_test.cpp
    ${BUNDLES}/sonia-prime/tests/net_service_test.cpp
    #${BUNDLES}/sonia-prime/tests/test.cpp
)

add_executable(${BUNDLE_NAME} ${BUNDLE_SOURCES})
#add_definitions(${FACADE_DEFINITIONS})
#set_target_properties(${BUNDLE_NAME} PROPERTIES FOLDER "test")

sonia_link_library(${BUNDLE_NAME} sonia-prime-lib)
sonia_link_library(${BUNDLE_NAME} sonia-prime)
#sonia_link_library(${BUNDLE_NAME} sonia-net)

#if (BUILD_MINGW)

#elseif (BUILD_ANDROID)

#else ()
#    target_link_libraries(${MODULE_NAME} ${BOOST_LOCALE} ${OPENSSL})
#endif()

target_link_libraries(${BUNDLE_NAME} ${PLATFORM_LIBS} ${BOOST_SYSTEM} ${BOOST_CHRONO} ${BOOST_SERIALIZATION} ${BOOST_TEST_LIB} ${BOOST_PROGRAM_OPTIONS} ${BOOST_FILESYSTEM} ${ZLIB} ${BZLIB})

#target_link_libraries(${BUNDLE_NAME} ${BOOST_CHRONO} ${BOOST_TEST_LIB} ${BOOST_PROGRAM_OPTIONS})