clc
clear all
close all

currentPath = fileparts(mfilename('fullpath'));

voxels = h5read([currentPath, '/id.h5'], '/14'); % change file name and dataset name here

voxels = squeeze(voxels); % in h5, the dimension is 1 * x * y * z
% after squeeze(), the dimension turns to be x * y * z

data = xlsread([currentPath, '/data.xlsx']); % the data file of ellipsoids

data(:, [1 2]) = []; % the first two columns are non sense

% radii_ = data(:, [1 2 3]);
% center_ = data(:, [4 5 6]);
axis_1 = data(:, [7 8 9]); % extract the unit diectional vectors of the principle axes
AS = find(axis_1(:, 3) < 0); % find those z components smaller than zero
axis_1(AS, :) = -axis_1(AS, :); % here I want all directional vectors pointing upward!!!
% axis_2 = data(:, [10 11 12]);
% axis_3 = data(:, [13 14 15]);

clear data % optimize the memory


particles_1st_axis_X = zeros(size(voxels, 1), size(voxels, 2), size(voxels, 3), 'single');
% create a N1 * N2 * N3 matrix, the size of this matrix = the size of the voxels

as = find(voxels == 0); % 0 represent environment
particles_1st_axis_X(as) = -2; clear as;
% if the voxels are labelled as environment, then,
% in 'particles_1st_axis_X', the corresponding elements turn to be -2

particles_1st_axis_Y = particles_1st_axis_X;
particles_1st_axis_Z = particles_1st_axis_Y;
% create two matrices, zero matrices

for i = 1:size(axis_1, 1) % from particle 1 to N, N = the number of particles
    a = find(voxels == i); % find all voxels' values = i (i is the particle ID)
    particles_1st_axis_X(a) = single(axis_1(i, 1)); % the corresponding elements = principle axis
    particles_1st_axis_Y(a) = single(axis_1(i, 2));
    particles_1st_axis_Z(a) = single(axis_1(i, 3));
    
    % particles_1st_axis_X, ...Y, ...Z 
    % here denote the three components of the principle axis
    
    disp([num2str(i), '/', num2str(size(axis_1, 1)), ', size of a: ', num2str(size(a, 1))]);
    clear a
end

filename_1 = "Particles_1st_axis_X.h5";
h5create(filename_1, "/X", size(particles_1st_axis_X));
h5write(filename_1, "/X", single(particles_1st_axis_X))

filename_2 = "Particles_1st_axis_Y.h5";
h5create(filename_2, "/Y", size(particles_1st_axis_Y));
h5write(filename_2, "/Y", single(particles_1st_axis_Y))

filename_3 = "Particles_1st_axis_Z.h5";
h5create(filename_3, "/Z", size(particles_1st_axis_Z));
h5write(filename_3, "/Z", single(particles_1st_axis_Z))

save('axis_1st_XYZ_data.mat')
