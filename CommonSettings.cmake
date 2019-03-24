include_guard(GLOBAL)
set(COMMON_SETTINGS_MINIMUM_VERSION "3.12")
if(${CMAKE_VERSION} VERSION_LESS ${COMMON_SETTINGS_MINIMUM_VERSION})
    message(FATAL_ERROR "The common settings require minimum cmake version ${COMMON_SETTINGS_MINIMUM_VERSION}")
endif()
## No build-in-src guard
file(TO_CMAKE_PATH "${PROJECT_BINARY_DIR}/CMakeLists.txt" LOC_PATH)
if(EXISTS "${LOC_PATH}")
    message(FATAL_ERROR "You cannot build in a source directory (or any directory with a CMakeLists.txt file). Please make a build subdirectory. Feel free to remove CMakeCache.txt and CMakeFiles.")
endif()
## CMake settings
if (NOT CMAKE_BUILD_TYPE)
    message(STATUS "No build type selected, default to RelWithDebInfo")
    set(CMAKE_BUILD_TYPE "RelWithDebInfo" CACHE STRING "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel." FORCE)
endif()
if (NOT LOGLEVEL)
    message(STATUS "No compile time log level specified, default to build type")
    set(loglevel "Debug")
    if (CMAKE_BUILD_TYPE MATCHES "^(Release|MinSizeRel)$")
        set(loglevel "Info")
    endif()
    set(LOGLEVEL ${loglevel} CACHE STRING "Choose the log level, options are: Info, Debug, Trace." FORCE)
endif()
message(STATUS "Log level at compile time: ${LOGLEVEL}")
# Platform specifics
if (APPLE)
    set(CMAKE_MACOSX_RPATH 1)
    # https://stackoverflow.com/a/33067191/1824372
    SET(CMAKE_C_ARCHIVE_CREATE   "<CMAKE_AR> Scr <TARGET> <LINK_FLAGS> <OBJECTS>")
    SET(CMAKE_CXX_ARCHIVE_CREATE "<CMAKE_AR> Scr <TARGET> <LINK_FLAGS> <OBJECTS>")
    SET(CMAKE_C_ARCHIVE_FINISH   "<CMAKE_RANLIB> -no_warning_for_no_symbols -c <TARGET>")
    SET(CMAKE_CXX_ARCHIVE_FINISH "<CMAKE_RANLIB> -no_warning_for_no_symbols -c <TARGET>")
    # brew installed llvm clang
    if (CMAKE_CXX_COMPILER_ID STREQUAL Clang)
        get_filename_component(compiler_bindir ${CMAKE_CXX_COMPILER} DIRECTORY)
        get_filename_component(compiler_libdir ${compiler_bindir}/../lib ABSOLUTE)
        message("Link CXX libs from ${compiler_libdir}")
        set(CMAKE_EXE_LINKER_FLAGS "-L${compiler_libdir} -Wl,-rpath,${compiler_libdir}")
    endif()
else()
    set(CMAKE_LINK_WHAT_YOU_USE TRUE)
endif()
# Paths and directories
include(GNUInstallDirs)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}" ${CMAKE_MODULE_PATH})
# Options
set_property(GLOBAL PROPERTY ALLOW_DUPLICATE_CUSTOM_TARGETS TRUE)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
option(VERBOSE "Print addtional messages from CMake" ON)
include(PrintProperties)
# generate a dummy clang-tidy file to suppress warning from deps
file(WRITE "${CMAKE_BINARY_DIR}/.clang-tidy" "
---
Checks: '-*,llvm-twine-local'
...
")

