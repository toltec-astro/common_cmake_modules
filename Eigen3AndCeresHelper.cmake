include_guard(GLOBAL)
macro(BuildEigen3AndCeres)
    set(svargs EIGEN3 CERES)
    cmake_parse_arguments(BEC "" "${svargs}" "")
    if (NOT BEC_EIGEN3)
        message("Use Eigen3 from branch default")
        set(BEC_EIGEN3 "default")
    endif()
    if (NOT BEC_CERES)
        message("Use Ceres-solver from branch master")
        set(BEC_CERES "master")
    endif()
    include(FetchContentHelper)
    FetchContentHelper(eigen HG "https://bitbucket.org/eigen/eigen" ${BEC_EIGEN3}
        ADD_SUBDIR CONFIG_SUBDIR
            BUILD_TESTING=OFF
        REGISTER_PACKAGE
            Eigen3 INCLUDE_CONTENT
                "set(EIGEN3_FOUND TRUE)\nset(EIGEN3_INCLUDE_DIR \${eigen_SOURCE_DIR})"
        )
    FetchContentHelper(ceres GIT "https://github.com/ceres-solver/ceres-solver.git" ${BEC_CERES}
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
            ${PATCH_DIR}/patches/patch.sh "ceres*.patch"
        )
endmacro()
macro(UseEigen3AndCeres prefix)
    if (prefix)
        set(Eigen3_DIR ${prefix})
        set(Ceres_DIR ${prefix})
    endif()
    find_package(Eigen3 REQUIRED CONFIG)
    set_target_properties(Eigen3::Eigen PROPERTIES INTERFACE_COMPILE_DEFINITIONS "EIGEN_NO_MALLOC")
    find_package(Ceres REQUIRED COMPONENTS C++11)
endmacro()
