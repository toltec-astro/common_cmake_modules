include_guard(GLOBAL)
include(FetchContentHelper)
FetchContentHelper(benchmark GIT https://github.com/google/benchmark.git v1.4.1 ADD_SUBDIR
        CONFIG_SUBDIR
            BENCHMARK_ENABLE_GTEST_TESTS=OFF
        )
FetchContentHelper(googletest GIT https://github.com/google/googletest.git release-1.8.1 ADD_SUBDIR)
enable_testing()
# https://gitlab.kitware.com/cmake/community/wikis/doc/tutorials/EmulateMakeCheck
add_custom_target(check COMMAND ${CMAKE_CTEST_COMMAND})
include(GoogleTest)
