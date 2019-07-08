include (${COMMON_INCLUDE})

include_directories(${BUNDLES})
include_directories(${BUNDLES}/sonia-prime)
include_directories(${BUNDLES}/sonia-net)

set (PROJECT_NAME dev-test)
set (PROJECT_SOURCES
	${BUNDLES}/sonia-prime/applied/tests_support.cpp
    ${BUNDLES}/sonia-prime/applied/scoped_services.cpp
    #${BUNDLES}/sonia-prime/tests/signal_test.cpp
    #${BUNDLES}/sonia-prime/tests/aio_test.cpp
    ${BUNDLES}/sonia-prime/tests/transceiver_test.cpp
    #${BUNDLES}/sonia-prime/tests/net_service_test.cpp
    #${BUNDLES}/sonia-prime/tests/epoll_experiment.cpp
    #${BUNDLES}/sonia-prime/tests/test.cpp
    ${BUNDLES}/sonia-prime/tests/timer_test.cpp
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

target_link_libraries(${PROJECT_NAME} ${PLATFORM_LIBS} ${BOOST_TEST_LIB} ${BOOST_REGEX} ${BOOST_CHRONO} ${BOOST_THREAD} ${BOOST_SERIALIZATION} ${BOOST_TEST_LIB} ${BOOST_PROGRAM_OPTIONS} ${BOOST_FILESYSTEM} ${ZLIB} ${BZLIB})

#target_link_libraries(${PROJECT_NAME} ${BOOST_CHRONO} ${BOOST_TEST_LIB} ${BOOST_PROGRAM_OPTIONS})