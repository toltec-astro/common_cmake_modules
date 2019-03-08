include_guard(GLOBAL)
option(USE_INSTALLED_EIGEN3 "Use installed Eigen3" OFF)
option(FCH_EIGEN3_TAG "Branch/tag used to fetch Eigen3 source code" OFF)
if (USE_INSTALLED_EIGEN3)
    set(Eigen3_DIR ${USE_INSTALLED_EIGEN3}/share/eigen3/cmake)
    if (EXISTS ${Eigen3_DIR})
        message("Use Eigen3 from ${USE_INSTALLED_EIGEN3}")
    else()
        message("Use Eigen3 from default location")
        unset(Eigen3_DIR)
    endif()
    find_package(Eigen3 3.3 REQUIRED CONFIG)
    include(PrintProperties)
    print_target_properties(Eigen3::Eigen)
    set_target_properties(Eigen3::Eigen PROPERTIES INTERFACE_COMPILE_DEFINITIONS "EIGEN_NO_MALLOC")
    message("Found Eigen3 in ${EIGEN3_INCLUDE_DIR}")
else()
    if (NOT FCH_EIGEN3_TAG)
        message("Use Eigen3 from repo branch \"default\"")
        set(FCH_EIGEN3_TAG "default")
    endif()
    include(FetchContentHelper)
    FetchContentHelper(eigen HG "https://bitbucket.org/eigen/eigen" ${FCH_EIGEN3_TAG}
        ADD_SUBDIR CONFIG_SUBDIR
            BUILD_TESTING=OFF
        PATCH_SUBDIR
            ${FCH_PATCH_DIR}/patch.sh "eigen3*.patch"
        REGISTER_PACKAGE
            Eigen3 INCLUDE_CONTENT
                "set(EIGEN3_FOUND TRUE)\nset(EIGEN3_INCLUDE_DIR \${eigen_SOURCE_DIR})"
        )
endif()
