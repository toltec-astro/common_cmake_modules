include_guard(GLOBAL)
set(FCH_PATCH_DIR ${CMAKE_CURRENT_LIST_DIR}/patches CACHE INTERNAL "")

include(FetchContent)
# let find_package pick up our subproject
# see https://gitlab.kitware.com/cmake/cmake/issues/17735
function(register_source_package name)
    set(svargs INCLUDE_CONTENT)
    set(mvargs INCLUDE)
    cmake_parse_arguments(PARSE_ARGV 1 RSP "" "${svargs}" "${mvargs}")
    set(include "")
    foreach(include_file ${RSP_INCLUDE})
        set(include "${include}\ninclude(${include_file})")
    endforeach()
    file(WRITE
        "${CMAKE_BINARY_DIR}/_pkgs/${name}/${name}Config.cmake"
        ${include}
        ${RSP_INCLUDE_CONTENT}
        )
    set(${name}_DIR ${CMAKE_BINARY_DIR}/_pkgs/${name} CACHE PATH "find_package helper")
    message("Generate package file: ${name}Config.cmake")
    message("${name}_DIR: ${${name}_DIR}")
endfunction()

function(FetchContentHelper name vc url tag)
    set(options ADD_SUBDIR)
    set(mvargs CONFIG_SUBDIR PATCH_SUBDIR REGISTER_PACKAGE)
    cmake_parse_arguments(PARSE_ARGV 4 FCH "${options}" "" "${mvargs}")

    set(declare_args
        ${name}
        ${vc}_REPOSITORY ${url}
        ${vc}_TAG        ${tag}
        GIT_PROGRESS     ON
        )
    if(FCH_PATCH_SUBDIR)
        list(GET FCH_PATCH_SUBDIR 0 patchcmd)
        list(GET FCH_PATCH_SUBDIR 1 patcharg)
        message("Use patch ${patchcmd} ${patcharg}")
        set(declare_args ${declare_args} PATCH_COMMAND ${patchcmd} ${patcharg})
    endif()
    FetchContent_Declare(${declare_args})
    FetchContent_GetProperties(${name})
    if(NOT ${name}_POPULATED)
        message("Setting up ${name} from ${url}")
        FetchContent_Populate(${name})
        set(${name}_SOURCE_DIR ${${name}_SOURCE_DIR} PARENT_SCOPE)
        set(${name}_BINARY_DIR ${${name}_BINARY_DIR} PARENT_SCOPE)
        if(FCH_ADD_SUBDIR)
            foreach(config ${FCH_CONFIG_SUBDIR})
                string(REPLACE "=" ";" configkeyval ${config})
                list(LENGTH configkeyval len)
                if (len GREATER_EQUAL 2)
                    list(GET configkeyval 0 configkey)
                    list(SUBLIST configkeyval 1 -1 configvals)
                    string(REPLACE ";" "=" configval "${configvals}")
                else()
                    message(FATAL_ERROR "Invalid config: ${configkeyval}")
                endif()
                message("Set ${configkey} = ${configval}")
                set(${configkey} ${configval} CACHE INTERNAL "" FORCE)
            endforeach()
            message("${name}_SOURCE_DIR: ${${name}_SOURCE_DIR}")
            message("${name}_BINARY_DIR: ${${name}_BINARY_DIR}")
            add_subdirectory(${${name}_SOURCE_DIR} ${${name}_BINARY_DIR} EXCLUDE_FROM_ALL)
            if (FCH_REGISTER_PACKAGE)
                register_source_package(${FCH_REGISTER_PACKAGE})
            endif()
        endif()
    endif()
endfunction(FetchContentHelper)
