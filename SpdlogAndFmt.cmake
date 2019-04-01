include_guard(GLOBAL)
include(FetchContentHelper)
FetchContentHelper(fmt GIT "https://github.com/fmtlib/fmt.git" "master"
    ADD_SUBDIR
    )
set_target_properties(fmt PROPERTIES INTERFACE_COMPILE_DEFINITIONS "FMT_USE_CONSTEXPR")
FetchContentHelper(spdlog GIT "https://github.com/gabime/spdlog.git" v1.x
    ADD_SUBDIR CONFIG_SUBDIR
    SPDLOG_FMT_EXTERNAL=ON
    )
# translate log level
string(TOLOWER "${LOGLEVEL}" loglevel)
set(SPDLOG_ACTIVE_LEVEL "")
if (loglevel STREQUAL "trace")
    set(SPDLOG_ACTIVE_LEVEL "SPDLOG_ACTIVE_LEVEL=SPDLOG_LEVEL_TRACE")
elseif (loglevel STREQUAL "debug")
    set(SPDLOG_ACTIVE_LEVEL "SPDLOG_ACTIVE_LEVEL=SPDLOG_LEVEL_DEBUG")
elseif (loglevel STREQUAL "info")
    set(SPDLOG_ACTIVE_LEVEL "SPDLOG_ACTIVE_LEVEL=SPDLOG_LEVEL_INFO")
elseif (loglevel STREQUAL "warn")
    set(SPDLOG_ACTIVE_LEVEL "SPDLOG_ACTIVE_LEVEL=SPDLOG_LEVEL_WARN")
elseif (loglevel STREQUAL "error")
    set(SPDLOG_ACTIVE_LEVEL "SPDLOG_ACTIVE_LEVEL=SPDLOG_LEVEL_ERROR")
endif()
set_target_properties(spdlog PROPERTIES
    INTERFACE_COMPILE_DEFINITIONS
        "SPDLOG_FMT_EXTERNAL;${SPDLOG_ACTIVE_LEVEL}"
    )
