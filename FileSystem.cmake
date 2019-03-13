include_guard(GLOBAL)
# the apple clang does not have fs
if (CMAKE_CXX_COMPILER_ID STREQUAL AppleClang)
    message(FATAL_ERROR "Apple clang compiler is not supported, use `brew install llvm` instead.")
endif()
add_library(cpp_filesystem INTERFACE)
target_link_libraries(cpp_filesystem INTERFACE c++fs)
add_library(cpp::filesystem ALIAS cpp_filesystem)
