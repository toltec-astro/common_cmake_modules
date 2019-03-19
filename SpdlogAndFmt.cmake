include_guard(GLOBAL)
include(FetchContentHelper)
FetchContentHelper(fmt GIT "https://github.com/fmtlib/fmt.git" "master"
    ADD_SUBDIR
    )
FetchContentHelper(spdlog GIT "https://github.com/gabime/spdlog.git" v1.x
    ADD_SUBDIR CONFIG_SUBDIR
    SPDLOG_FMT_EXTERNAL=ON
    )
set_target_properties(spdlog PROPERTIES INTERFACE_COMPILE_DEFINITIONS "SPDLOG_ACTIVE_LEVEL=SPDLOG_LEVEL_TRACE")
