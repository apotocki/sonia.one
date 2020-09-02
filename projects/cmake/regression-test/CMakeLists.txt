include (${COMMON_INCLUDE})

include_directories(${BUNDLES})
include_directories(${BUNDLES}/sonia-prime)
include_directories(${TPLS}/lexertl14/include)

set (PROJECT_NAME regression-test)
set (PROJECT_SOURCES
	${BUNDLES}/sonia-prime/applied/tests_support.cpp
    ${BUNDLES}/sonia-prime/applied/scoped_services.cpp
    ${BUNDLES}/sonia-prime/tests/bit_coder_test.cpp
    ${BUNDLES}/sonia-prime/tests/bookkeeper_test.cpp
    ${BUNDLES}/sonia-prime/tests/cmp_test.cpp
    ${BUNDLES}/sonia-prime/tests/marshaling_test.cpp
    ${BUNDLES}/sonia-prime/tests/file_persister_test.cpp
    ${BUNDLES}/sonia-prime/tests/json_parser_test.cpp
    ${BUNDLES}/sonia-prime/tests/iterators_test.cpp
    ${BUNDLES}/sonia-prime/tests/number_test.cpp
    ${BUNDLES}/sonia-prime/tests/optimized_test.cpp
    ${BUNDLES}/sonia-prime/tests/serialization_stream_test.cpp
    ${BUNDLES}/sonia-prime/tests/prime_test.cpp
    ${BUNDLES}/sonia-prime/tests/tls_crash_test.cpp
    ${BUNDLES}/sonia-prime/tests/server_test.cpp
    #${BUNDLES}/sonia-prime/tests/transceiver_test.cpp
    ${BUNDLES}/sonia-prime/tests/timer_test.cpp
    ${BUNDLES}/sonia-prime/tests/http_iterators_test.cpp
)

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

target_link_libraries(${PROJECT_NAME} ${PLATFORM_LIBS} ${BOOST_CHRONO} ${BOOST_SERIALIZATION} ${BOOST_TEST_LIB} ${BOOST_PROGRAM_OPTIONS} ${BOOST_FILESYSTEM} ${ZLIB} ${BZLIB})
#target_link_libraries(${PROJECT_NAME} ${BOOST_CHRONO} ${BOOST_TEST_LIB} ${BOOST_PROGRAM_OPTIONS})