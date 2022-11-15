clc
clear all
close all

currentPath = fileparts(mfilename('fullpath'));

particles_ = h5read([currentPath, '/id.h5'], '/14'); % change file name and dataset name here

particles_ = squeeze(particles_);

data = xlsread([currentPath, '/data.xlsx']); % the data file of ellipsoids

data(:, [1 2]) = [];

% radii_ = data(:, [1 2 3]);
% center_ = data(:, [4 5 6]);
axis_1 = data(:, [7 8 9]);
AS = find(axis_1(:, 3) < 0);
axis_1(AS, :) = -axis_1(AS, :); % here I want all directional vectors pointing upward!!!
% axis_2 = data(:, [10 11 12]);
% axis_3 = data(:, [13 14 15]);

clear data

as = find(particles_ == 0);
particles_1st_axis_X = zeros(size(particles_, 1), size(particles_, 2), size(particles_, 3), 'single');
particles_1st_axis_X(as) = -2; clear as;
particles_1st_axis_Y = particles_1st_axis_X;
particles_1st_axis_Z = particles_1st_axis_Y;

for i = 1:size(axis_1, 1)
    a = find(particles_ == i);
    particles_1st_axis_X(a) = single(axis_1(i, 1));
    particles_1st_axis_Y(a) = single(axis_1(i, 2));
    particles_1st_axis_Z(a) = single(axis_1(i, 3));
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
