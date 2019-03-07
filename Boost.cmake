include_guard(GLOBAL)
include(FetchContentHelper)
FetchContentHelper(boost-cmake GIT "https://github.com/Orphis/boost-cmake.git" master
    ADD_SUBDIR CONFIG_SUBDIR
        BOOST_DISABLE_TESTS=ON
    )
