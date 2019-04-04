set(gitversion_dir ${CMAKE_CURRENT_LIST_DIR})

function(GenVersionHeader output_dir)
    message(STATUS "Resolving GIT Version")
    set(_build_version "unknown")
    find_package(Git)
    if(GIT_FOUND)
      execute_process(
        COMMAND ${GIT_EXECUTABLE} rev-parse --short HEAD
        WORKING_DIRECTORY "${local_dir}"
        OUTPUT_VARIABLE _build_version
        ERROR_QUIET
        OUTPUT_STRIP_TRAILING_WHITESPACE
      )
      message( STATUS "GIT hash: ${_build_version}")
    else()
      message(STATUS "GIT not found")
    endif()

    string(TIMESTAMP _time_stamp)

    configure_file(${gitversion_dir}/gitversion.h.in ${output_dir}/gitversion.h @ONLY)
endfunction()
