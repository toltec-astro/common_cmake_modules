include_guard(GLOBAL)
option(USE_INSTALLED_EIGEN3_AND_CERES "Use installed Eigen3 and Ceres-solver" OFF)
option(FCH_EIGEN3_TAG "Branch/tag used to fetch Eigen3 source code" OFF)
option(FCH_CERES_TAG "Branch/tag used to fetch Ceres-solver source code" OFF)
if (USE_INSTALLED_EIGEN3_AND_CERES)
    if (EXISTS ${USE_INSTALLED_EIGEN3_AND_CERES})
        set(Eigen3_DIR ${USE_INSTALLED_EIGEN3_AND_CERES})
        set(Ceres_DIR ${USE_INSTALLED_EIGEN3_AND_CERES})
        message("Use Eigen3 and Ceres-solver from ${USE_INSTALLED_EIGEN3_AND_CERES}")
    endif()
    find_package(Eigen3 REQUIRED CONFIG)
    set_target_properties(Eigen3::Eigen PROPERTIES INTERFACE_COMPILE_DEFINITIONS "EIGEN_NO_MALLOC")
    message("Found Eigen3 in ${EIGEN3_INCLUDE_DIR}")
    find_package(Ceres REQUIRED CONFIG)
    message("Found Ceres-solver in ${Ceres_INCLUDE_DIR}")
else()
    if (NOT FCH_EIGEN3_TAG)
        message("Use Eigen3 from branch default")
        set(FCH_EIGEN3_TAG "default")
    endif()
    if (NOT FCH_CERES_TAG)
        message("Use Ceres-solver from branch master")
        set(FCH_CERES_TAG "master")
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
    FetchContentHelper(ceres GIT "https://github.com/ceres-solver/ceres-solver.git" ${FCH_CERES_TAG}
        ADD_SUBDIR CONFIG_SUBDIR
            EIGEN_PREFER_EXPORTED_EIGEN_CMAKE_CONFIGURATION=ON
            EIGENSPARSE=ON
            SUITESPARSE=ON
            CXSPARSE=OFF
            GFLAGS=OFF
            MINIGLOG=ON
            CXX11=ON
            OPENMP=ON
            TBB=OFF
            CXX11_THREADS=OFF
            EXPORT_BUILD_DIR=ON
            BUILD_DOCUMENTATION=OFF
            BUILD_TESTING=OFF
            BUILD_EXAMPLES=OFF
            BUILD_BENCHMARKS=OFF
        PATCH_SUBDIR
            ${FCH_PATCH_DIR}/patch.sh "ceres*.patch"
        )
endif()
