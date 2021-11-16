include (${COMMON_INCLUDE})

include_directories(${BUNDLES})
include_directories(${BUNDLES}/sonia-prime)
include_directories(${TPLS}/lexertl14/include)

set (PROJECT_NAME regression-test)
set (PROJECT_SOURCES
    ${BUNDLES}/sonia-prime/applied/tests_main.cpp
    #${BUNDLES}/sonia-prime/applied/tests_support.cpp
)

add_executable(${PROJECT_NAME} ${PROJECT_SOURCES})

sonia_link_library(${PROJECT_NAME} sonia-tests-lib)
sonia_link_library(${PROJECT_NAME} sonia-prime)
sonia_link_library(${PROJECT_NAME} sonia-prime-lib)
