include_guard(GLOBAL)
include(ExternalProjectHelper)

ExternalProjectHelper(
    cfitsio
    CONTENT_DECLARE
        URL "http://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio_latest.tar.gz"
    PROJECT_ADD
        BUILD_IN_SOURCE 1
    CONFIGURE_ARGS
        --enable-ssse3 --disable-curl
    MAKE_ARGS
        libcfitsio.a
    MAKE_INSTALL_ARGS
        "install"
    LIBS
        libcfitsio.a
    INCLUDE_SOURCE_DIRS
        "."
    )
add_library(cmake_utils::cfitsio ALIAS eph_cfitsio)

# CCfits
ExternalProjectHelper(
    ccfits
    CONTENT_DECLARE
        URL "https://heasarc.gsfc.nasa.gov/fitsio/CCfits/CCfits-2.6.tar.gz"
    PROJECT_ADD
        BUILD_IN_SOURCE 1
    ADD_ENV
        LIBS=-lz
    CONFIGURE_ARGS
    --with-cfitsio-include=${EPH_PREFIX}/include --with-cfitsio-libdir=${EPH_PREFIX}/lib --enable-static --disable-shared
    MAKE_ARGS
        libCCfits.la
    MAKE_INSTALL_ARGS
        install-data-am install-libLTLIBRARIES
    LIBS
        libCCfits.a

    DEPS
        cfitsio
    )


message(${cfitsio_SOURCE_DIR})

message("Setting up CCfits headers")
file(GLOB CCfits_headers "${ccfits_SOURCE_DIR}/*.h")
set(CCfits_headers ${CCfits_headers} ${ccfits_SOURCE_DIR}/CCfits)
set(CCfits_tmp_include_dir ${ccfits_SOURCE_DIR}/include)
set(CCfits_tmp_headers_dir ${CCfits_tmp_include_dir}/CCfits)
file(MAKE_DIRECTORY ${CCfits_tmp_headers_dir})
file(COPY ${CCfits_headers} DESTINATION ${CCfits_tmp_headers_dir})
add_library(cmake_utils::ccfits ALIAS eph_ccfits)
print_target_properties(eph_cfitsio_libcfitsio)
print_target_properties(eph_cfitsio)
print_target_properties(eph_ccfits_libCCfits)
print_target_properties(eph_ccfits)
