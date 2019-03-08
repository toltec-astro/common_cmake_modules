include_guard(GLOBAL)
option(USE_INSTALLED_BOOST "Use installed Boost" OFF)
if (USE_INSTALLED_BOOST)
    if (EXISTS ${USE_INSTALLED_BOOST})
        set(BOOST_ROOT ${USE_INSTALLED_BOOST})
        set(Boost_NO_SYSTEM_PATHS ON)
        message("Use Boost from ${USE_INSTALLED_BOOST}")
    endif()
    find_package(Boost 1.68 REQUIRED)
    message("Found boost in ${Boost_INCLUDE_DIRS}")
else()
    include(FetchContentHelper)
    FetchContentHelper(boost-cmake GIT "https://github.com/Orphis/boost-cmake.git" master
        ADD_SUBDIR CONFIG_SUBDIR
            BOOST_DISABLE_TESTS=ON
        )
endif()