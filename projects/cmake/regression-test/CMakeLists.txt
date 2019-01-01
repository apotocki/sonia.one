include (${COMMON_INCLUDE})

include_directories(${BUNDLES})
include_directories(${BUNDLES}/sonia-prime)
include_directories(${TPLS}/lexertl14/include)

set (BUNDLE_NAME regression-test)
set (BUNDLE_SOURCES
	${BUNDLES}/sonia-prime/applied/tests_support.cpp
    ${BUNDLES}/sonia-prime/tests/cmp_test.cpp
    ${BUNDLES}/sonia-prime/tests/file_persister_test.cpp
    ${BUNDLES}/sonia-prime/tests/json_parser_test.cpp
    ${BUNDLES}/sonia-prime/tests/iterators_test.cpp
    ${BUNDLES}/sonia-prime/tests/number_test.cpp
    ${BUNDLES}/sonia-prime/tests/optimized_test.cpp
    ${BUNDLES}/sonia-prime/tests/serialization_stream_test.cpp
    ${BUNDLES}/sonia-prime/tests/prime_test.cpp
    ${BUNDLES}/sonia-prime/tests/tls_crash_test.cpp
    ${BUNDLES}/sonia-prime/tests/server_test.cpp
    #${BUNDLES}/sonia-net/tests/cmd_transceiver_test.cpp
)

add_executable(${BUNDLE_NAME} ${BUNDLE_SOURCES})
#add_definitions(${FACADE_DEFINITIONS})
#set_target_properties(${BUNDLE_NAME} PROPERTIES FOLDER "test")

sonia_link_library(${BUNDLE_NAME} sonia-prime-lib)
sonia_link_library(${BUNDLE_NAME} sonia-prime)
sonia_link_library(${BUNDLE_NAME} sonia-net)

#if (BUILD_MINGW)

#elseif (BUILD_ANDROID)

#else ()
#    target_link_libraries(${MODULE_NAME} ${BOOST_LOCALE} ${OPENSSL})
#endif()

target_link_libraries(${BUNDLE_NAME} ${PLATFORM_LIBS} ${BOOST_SYSTEM} ${BOOST_CHRONO} ${BOOST_SERIALIZATION} ${BOOST_TEST_LIB} ${BOOST_PROGRAM_OPTIONS} ${BOOST_FILESYSTEM} ${ZLIB} ${BZLIB})
#target_link_libraries(${BUNDLE_NAME} ${BOOST_CHRONO} ${BOOST_TEST_LIB} ${BOOST_PROGRAM_OPTIONS})