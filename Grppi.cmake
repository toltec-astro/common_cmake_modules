include_guard(GLOBAL)
include(FetchContentHelper)
FetchContentHelper(grppi GIT "https://github.com/Jerry-Ma/grppi.git" master
    ADD_SUBDIR CONFIG_SUBDIR
        GRPPI_UNIT_TEST_ENABLE=OFF
        GRPPI_TBB_ENABLE=OFF
        )
