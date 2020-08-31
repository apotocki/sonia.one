cmake_minimum_required (VERSION 3.0)

set (SONIA_APP_VERSION_MAJOR 0)
set (SONIA_APP_VERSION_MINOR 1)
set (REVISION_NAME "undefined")

set (BUILD_ROOT ${CMAKE_CURRENT_SOURCE_DIR})
set (PROJECT_HOME ${BUILD_ROOT}/../..)
set (BUNDLES ${PROJECT_HOME}/bundles)
set (TPLS ${PROJECT_HOME}/tpls)

# Setting up project name
if (DEFINED ENV{PROJECT_NAME})
	set (PROJECT_NAME "$ENV{PROJECT_NAME}")
else (DEFINED ENV{PROJECT_NAME})
	set (PROJECT_NAME "sonia")
endif (DEFINED ENV{PROJECT_NAME})
message("Project name: " ${PROJECT_NAME})
project (${PROJECT_NAME})

configure_file (
    "${PROJECT_HOME}/build_config.hpp.in"
    "${PROJECT_HOME}/build_config.hpp"
)

# Configurable options
if ("${BUILD_TYPE}" STREQUAL "STATIC")
	set (LIBRARY_TYPE STATIC)
    message("Build type: 'STATIC' : Build all components linking them statically into binary")
else()
	set (LIBRARY_TYPE SHARED)
	message("Build type: 'SHARED' : Link all components as shared libraries")
endif()

option(FORCE_LINK_TIME_OPTIMIZATION "Shall we compile with -fwhopr")

function(sonia_add_library type src bin)
    set (LIBRARY_TYPE ${type})
    add_subdirectory(${src} "${CMAKE_CURRENT_BINARY_DIR}/${bin}")
endfunction(sonia_add_library)

function(sonia_link_library MODULE_NAME name)
	get_property(IMPORTER_FLAGS GLOBAL PROPERTY ${name}-import-flags)
	add_definitions(${IMPORTER_FLAGS})
	target_link_libraries(${MODULE_NAME} ${name})
endfunction(sonia_link_library)

set (COMMON_INCLUDE "${BUILD_ROOT}/Common.cmake")

#set_source_files_properties(${PROJECT_HOME}/buildinfo.hpp PROPERTIES GENERATED TRUE HEADER_FILE_ONLY TRUE)

#include_directories(${PROJECT_HOME})
#include_directories(${PROJECT_HOME}/modules/polymorphic-core)
#include_directories(${PROJECT_HOME}/modules/vocabulary)

# libs
sonia_add_library(STATIC ${BUNDLES}/sonia-prime/projects/cmake/sonia-prime-lib sonia-prime-lib)
sonia_add_library(${LIBRARY_TYPE} ${BUNDLES}/sonia-prime/projects/cmake/sonia-prime sonia-prime)
#sonia_add_library(${LIBRARY_TYPE} ${BUNDLES}/sonia-net/projects/cmake/sonia-net sonia-net)

#executable
add_subdirectory(dev-test)
add_subdirectory(regression-test)
add_subdirectory(angel)