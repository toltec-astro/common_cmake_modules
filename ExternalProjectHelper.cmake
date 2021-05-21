include_guard(GLOBAL)
include(FetchContent)
include(ExternalProject)

set(EPH_PREFIX "${CMAKE_BINARY_DIR}/_eps")
set(EPH_LIBDIR ${EPH_PREFIX}/lib)
set(EPH_INCDIR ${EPH_PREFIX}/include)
file(MAKE_DIRECTORY ${EPH_INCDIR})

function(ExternalProjectHelper name)
    set(mvargs CONTENT_DECLARE PROJECT_ADD CONFIGURE_ARGS MAKE_ARGS MAKE_INSTALL_ARGS LIBS INCLUDE_SOURCE_DIRS DEPS)
    cmake_parse_arguments(PARSE_ARGV 1 EPH "" "" "${mvargs}")

    set(declare_args
        ${name}
        ${EPH_CONTENT_DECLARE}
        LOG_DOWNLOAD ON
        )
    message(STATUS "declare external project ${name}: ${declare_args}")
    FetchContent_Declare(${declare_args})
    FetchContent_GetProperties(${name})
    if(NOT ${name}_POPULATED)
        message("Setting up ${name} with ${EPH_CONTENT_DECLARE}")
        FetchContent_Populate(${name})
        set(${name}_SOURCE_DIR ${${name}_SOURCE_DIR} PARENT_SCOPE)
        set(${name}_BINARY_DIR ${${name}_BINARY_DIR} PARENT_SCOPE)
    endif()
    set(build_byproducts "${EPH_LIBS}")
    list(TRANSFORM build_byproducts PREPEND "${EPH_LIBDIR}/")
    message(STATUS "build byproducts: ${build_byproducts}")
    # file(MAKE_DIRECTORY ${name}_SOURCE_DIR)
    # file(WRITE "${name}_SOURCE_DIR/eph_source_tag" "${name}")
    find_program(MAKE_EXE NAMES gmake nmake make)
    ExternalProject_Add(
        ${name}
        SOURCE_DIR ${${name}_SOURCE_DIR}
        PREFIX ${EPH_PREFIX}
        LOG_BUILD ON
        ${EPH_PROJECT_ADD}
        CONFIGURE_COMMAND ./configure --prefix=${EPH_PREFIX} ${EPH_CONFIGURE_ARGS}
        BUILD_COMMAND ${MAKE_EXE} ${EPH_MAKE_ARGS}
        INSTALL_COMMAND ${MAKE_EXE} ${EPH_MAKE_INSTALL_ARGS}
        BUILD_BYPRODUCTS ${build_byproducts}
        )
    set(inc_src_dirs ${EPH_INCLUDE_SOURCE_DIRS})
    list(TRANSFORM inc_src_dirs PREPEND ${${name}_SOURCE_DIR}/)
    message(STATUS "include source dirs: ${inc_src_dirs}")
    set(static_libs)
    foreach(lib ${EPH_LIBS})
        get_filename_component(libstem ${lib} NAME_WE  [CACHE])
        set(target_name eph_${name}_${libstem})
        set(static_libs ${static_libs} ${target_name})
        add_library(${target_name} STATIC IMPORTED GLOBAL)
        set_property(TARGET ${target_name} PROPERTY IMPORTED_LOCATION ${EPH_LIBDIR}/${lib})
        set_property(TARGET ${target_name} PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${EPH_INCDIR} ${inc_src_dirs})
    endforeach()
    # set(EPH_${NAME}_LIBS ${static_libs} PARENT_SCOPE)
    message(STATUS "static libs: ${static_libs}")

    set(dep_libs)
    foreach(dep ${EPH_DEPS})
        add_dependencies(${name} eph_${dep})
        set(dep_libs ${dep_libs} eph_${dep})
    endforeach()
    message(STATUS "dep libs: ${dep_libs}")

    add_library(eph_${name} INTERFACE)
    target_link_libraries(
        eph_${name} INTERFACE
        ${static_libs}
        ${dep_libs}
        )
    add_dependencies(eph_${name} ${name})
endfunction()
