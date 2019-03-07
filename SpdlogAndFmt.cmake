include_guard(GLOBAL)
include(FetchContentHelper)
FetchContentHelper(fmt GIT "https://github.com/fmtlib/fmt.git" 5.2.1
    ADD_SUBDIR
    )
FetchContentHelper(spdlog GIT "https://github.com/gabime/spdlog.git" v1.x
    ADD_SUBDIR CONFIG_SUBDIR
    SPDLOG_FMT_EXTERNAL=ON
    )
