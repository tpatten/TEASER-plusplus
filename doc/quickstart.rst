.. _quickstart:

Quick Start
===========

Usage in C++ Projects
---------------------

TEASER++ supports integration with other CMake projects. When installing TEASER++, CMake will export the following targets that can be included in other CMake projects using ``find_package()``:

- ``teaserpp::teaser_registration``: the core registration library
- ``teaserpp::teaser_io``: library for importing `.ply` files
- ``teaserpp::teaser_features``: convenience wrappers around the PCL FPFH library, and simple feature matching functions

A minimally-working `CMakeList.txt` looks something like this::

   cmake_minimum_required(VERSION 3.10)
   project(teaserpp_example)

   set (CMAKE_CXX_STANDARD 14)

   find_package(Eigen3 REQUIRED)
   find_package(teaserpp REQUIRED)

   # Change this line to include your own executable file
   add_executable(cpp_example cpp_example.cpp)

   # Link to teaserpp & Eigen3
   target_link_libraries(cpp_example Eigen3::Eigen teaserpp::teaser_registration teaserpp::teaser_io)

A minimal TEASER++ C++ program looks something like this:

.. code-block:: cpp

   #include <teaser/registration.h>

   teaser::RobustRegistrationSolver::Params params;
   teaser::RobustRegistrationSolver solver(params);
   solver.solve(src, dst); // assuming src & dst are 3-by-N Eigen matrices
   auto solution = solver.getSolution();

So, what did that code do?

1. First, we included the registration header.
2. Next, we default initialized a parameter struct for controlling the behavior of our solver.
3. Next, we initialized our solver with the parameter struct.
4. We then solve the registration problem by calling the ``solve()`` function.
5. Finally, we obtain the solution.

In the `examples <https://github.com/MIT-SPARK/TEASER-plusplus/tree/master/examples>`_ folder of the project repo, you can find two C++ examples that can be compiled with CMake:

- ``teaser_cpp_ply``: showing how to import `.ply` files and perform registration with TEASER++,
- ``teaser_cpp_fpfh``: showing how to use TEASER++ with FPFH features.

For complete C++ API documentation, please refer to :ref:`api-cpp`.

Usage in Python Projects
------------------------

A minimal TEASER++ Python program looks something like this:

.. code-block:: python

   import numpy as np
   import teaserpp_python

   # Generate random data points
   src = np.random.rand(3, 20)

   # Apply arbitrary scale, translation and rotation
   scale = 1.5
   translation = np.array([[1], [0], [-1]])
   rotation = np.array([[0.98370992, 0.17903344,    -0.01618098],
                        [-0.04165862, 0.13947877,    -0.98934839],
                        [-0.17486954, 0.9739059,    0.14466493]])
   dst = scale * np.matmul(rotation, src) + translation

   # Add two outliers
   dst[:, 1] += 10
   dst[:, 9] += 15

   # Populate the parameters
   solver_params = teaserpp_python   .RobustRegistrationSolver.Params()
   solver_params.cbar2 = 1
   solver_params.noise_bound = 0.01
   solver_params.estimate_scaling = True
   solver_params.rotation_estimation_algorithm = (
       teaserpp_python.RobustRegistrationSolver   .ROTATION_ESTIMATION_ALGORITHM.GNC_TLS
   )
   solver_params.rotation_gnc_factor = 1.4
   solver_params.rotation_max_iterations = 100
   solver_params.rotation_cost_threshold = 1e-12
   print("TEASER++ Parameters are:", solver_params)
   teaserpp_solver = teaserpp_python   .RobustRegistrationSolver(solver_params)

   solver = teaserpp_python.RobustRegistrationSolver(solver_params)
   solver.solve(src, dst)

   solution = solver.getSolution()

   # Print the solution
   print("Solution is:", solution)

So, what did that code do?

1. First, we imported ``numpy`` and our Python binding, named ``teaserpp_python``.
2. We generated some random correspondences.
3. Next, we initialized a parameter object for controlling the behavior of our solver. We initialized our solver with the parameter object.
4. We then solve the registration problem by calling the ``solve()`` function.
5. Finally, we obtain the solution.

Note that this is extremely similar to the C++ version by design.

In the `examples <https://github.com/MIT-SPARK/TEASER-plusplus/tree/master/examples>`_ folder of the project repo, you can find two more Python examples that are runnable:

- ``teaser_python_ply``: showing how to import `.ply` files and perform registration with TEASER++ and Open3D,
- ``teaser_python_3dsmooth``: showing how to use TEASER++ on descriptors generated by `3DSmoothNet <https://github.com/zgojcic/3DSmoothNet>`_ on the 3DMatch dataset, with Open3D visualization.

For more Python API documentation, please refer to :ref:`api-python`.

Usage in MATLAB Projects
------------------------

Contrary to the object-oriented designs in C++ and Python, in MATLAB you only have access to a single solve function, and you can pass in the parameters through named arguments:

.. code-block:: matlab

   [s, R, t, time_taken] = teaser_solve(src, dst, 'Cbar2', 1, 'NoiseBound', 0.01, ...
                                     'EstimateScaling', true, 'RotationEstimationAlgorithm', 0, ...
                                     'RotationGNCFactor', 1.4, 'RotationMaxIterations', 100, ...
                                     'RotationCostThreshold', 1e-12);

Assume we have `src` and `dst`, two 3-by-N matrices. And we know that `dst = R * src + t + e`, where `e` is bounded within 0.01. The following is a snippet of how you can use TEASER++'s MATLAB bindings to solve it:

.. code-block:: matlab

   cbar2 = 1;
   noise_bound = 0.01;
   estimate_scaling = false; % we know there's no scale difference
   rot_alg = 0; % use GNC-TLS, set to 1 for FGR
   rot_gnc_factor = 1.4;
   rot_max_iters = 100;
   rot_cost_threshold = 1e-12;

   [s, R, t, time_taken] = teaser_solve(src, dst, 'Cbar2', cbar2, 'NoiseBound', noise_bound, ...
                                        'EstimateScaling', estimate_scaling, 'RotationEstimationAlgorithm', rot_alg, ...
                                     'RotationGNCFactor', rot_gnc_factor, 'RotationMaxIterations', 100, ...
                                     'RotationCostThreshold', rot_cost_threshold);

Similarly, if we don't know the scale, here is a snippet for solving the registration problem with MATLAB bindings:

.. code-block:: matlab

   cbar2 = 1;
   noise_bound = 0.01;
   estimate_scaling = true;
   rot_alg = 0; % use GNC-TLS, set to 1 to use FGR
   rot_gnc_factor = 1.4;
   rot_max_iters = 100;
   rot_cost_threshold = 1e-12;

   [s, R, t, time_taken] = teaser_solve(src, dst, 'Cbar2', cbar2, 'NoiseBound', noise_bound, ...
                                        'EstimateScaling', estimate_scaling, 'RotationEstimationAlgorithm', rot_alg, ...
                                     'RotationGNCFactor', rot_gnc_factor, 'RotationMaxIterations', 100, ...
                                     'RotationCostThreshold', rot_cost_threshold);

For more MATLAB API documentation, please refer to :ref:`api-matlab`.

Usage In ROS Projects
---------------------

To use TEASER++ in a ROS environment, simple clone the repo to your ``catkin`` workspace.
