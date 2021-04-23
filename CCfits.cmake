include_guard(GLOBAL)
include(FetchContent)
include(ExternalProject)
find_program(MAKE_EXE NAMES gmake nmake make)

set(cfitsio_url "http://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio_latest.tar.gz")
set(cfitsio_prefix "${CMAKE_BINARY_DIR}/_eps")
set(cfitsio_src "${cfitsio_prefix}/src/cfitsio")
set(cfitsio_configure ${cfitsio_src}/configure --enable-ssse3 --disable-curl --prefix=${cfitsio_prefix})
set(cfitsio_make ${MAKE_EXE} libcfitsio.a)
set(cfitsio_install ${MAKE_EXE} install)

FetchContent_Declare(
    cfitsio
    URL ${cfitsio_url}
    LOG_DOWNLOAD 1
    )
FetchContent_GetProperties(cfitsio)
if(NOT cfitsio_POPULATED)
    message("Setting up cfitsio from ${cfitsio_url}")
    FetchContent_Populate(cfitsio)
    set(cfitsio_SOURCE_DIR ${cfitsio_SOURCE_DIR} PARENT_SCOPE)
    set(cfitsio_BINARY_DIR ${cfitsio_BINARY_DIR} PARENT_SCOPE)
endif()
ExternalProject_Add(
    cfitsio
    PREFIX ${cfitsio_prefix}
    URL ${cfitsio_url}
    LOG_DOWNLOAD 1
    LOG_BUILD 1
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${cfitsio_configure}
    BUILD_COMMAND ${cfitsio_make}
    INSTALL_COMMAND ${cfitsio_install}
    )

add_library(ep_cfitsio STATIC IMPORTED)
set_property(TARGET ep_cfitsio PROPERTY IMPORTED_LOCATION ${cfitsio_prefix}/lib/libcfitsio.a)
set_property(TARGET ep_cfitsio PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${cfitsio_prefix}/include ${cfitsio_SOURCE_DIR})
add_dependencies(ep_cfitsio cfitsio)
add_library(cmake_utils::cfitsio ALIAS ep_cfitsio)

# CCfits
set(CCfits_url "https://heasarc.gsfc.nasa.gov/fitsio/CCfits/CCfits-2.5.tar.gz")
set(CCfits_prefix "${CMAKE_BINARY_DIR}/_eps")
set(CCfits_src "${CCfits_prefix}/src/CCfits")
set(CCfits_configure ${CCfits_src}/configure --prefix=${CCfits_prefix} --with-cfitsio=${cfitsio_prefix} --enable-static --disable-shared)
set(CCfits_make ${MAKE_EXE} libCCfits.la)
set(CCfits_install ${MAKE_EXE} install)

FetchContent_Declare(
    CCfits
    URL ${CCfits_url}
    LOG_DOWNLOAD 1
    )
FetchContent_GetProperties(CCfits)
if(NOT CCfits_POPULATED)
    message("Setting up CCfits from ${CCfits_url}")
    FetchContent_Populate(CCfits)
    set(ccfits_SOURCE_DIR ${ccfits_SOURCE_DIR} PARENT_SCOPE)
    set(ccfits_BINARY_DIR ${ccfits_BINARY_DIR} PARENT_SCOPE)
     # copy ccfits headers to a directory
    file(GLOB CCfits_headers
       "${ccfits_SOURCE_DIR}/*.h"
    )
    set(CCfits_headers ${CCfits_headers} ${ccfits_SOURCE_DIR}/CCfits)
    set(CCfits_tmp_include_dir ${ccfits_SOURCE_DIR}/include)
    set(CCfits_tmp_headers_dir ${CCfits_tmp_include_dir}/CCfits)
    file(MAKE_DIRECTORY ${CCfits_tmp_headers_dir})
    file(COPY ${CCfits_headers} DESTINATION ${CCfits_tmp_headers_dir})
endif()

ExternalProject_Add(
    CCfits
    PREFIX ${CCfits_prefix}
    URL ${CCfits_url}
    LOG_DOWNLOAD 1
    LOG_BUILD 1
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${CCfits_configure}
    BUILD_COMMAND ${CCfits_make}
    INSTALL_COMMAND ${CCfits_install}
    )

# make sure ccfits compiles after cfitsio
add_dependencies(CCfits cfitsio)

add_library(ep_CCfits STATIC IMPORTED)
set_property(TARGET ep_CCfits PROPERTY IMPORTED_LOCATION ${CCfits_prefix}/lib/libCCfits.a)
set_property(TARGET ep_CCfits PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${CCfits_prefix}/include ${CCfits_tmp_include_dir})
target_link_libraries(ep_CCfits
    INTERFACE
    ep_cfitsio
    )
add_dependencies(ep_CCfits CCfits)
add_library(cmake_utils::CCfits ALIAS ep_CCfits)
