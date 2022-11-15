clc
clear all
close all

currentPath = fileparts(mfilename('fullpath'));

particles_ = h5read([currentPath, '/id.h5'], '/14');

particles_ = squeeze(particles_);

data = xlsread([currentPath, '/data.xlsx']);

data(:, [1 2]) = [];

% radii_ = data(:, [1 2 3]);
% center_ = data(:, [4 5 6]);
axis_1 = data(:, [7 8 9]);
AS = find(axis_1(:, 3) < 0);
axis_1(AS, :) = -axis_1(AS, :);
% axis_2 = data(:, [10 11 12]);
% axis_3 = data(:, [13 14 15]);

clear data

vec_2 = axis_1(:, [1, 2]) ./ [vecnorm([axis_1(:, [1, 2])]')]';
phi_ = atan2(vec_2(:, 2), vec_2(:, 1)) .* 180 ./ pi; % azimuth angle

r_ = [vecnorm([axis_1(:, :)]')]';
theta_ = acos(axis_1(:, 3) ./ r_) .* 180 ./ pi; % polar angle

as = find(particles_ == 0);
particles_phi = zeros(size(particles_, 1), size(particles_, 2), size(particles_, 3), 'single');
particles_phi(as) = -500; clear as;
particles_theta = particles_phi;

for i = 1:size(axis_1, 1)
    a = find(particles_ == i);
    particles_phi(a) = single(phi_(i));
    particles_theta(a) = single(theta_(i));
    disp([num2str(i), '/', num2str(size(axis_1, 1)), ', size of a: ', num2str(size(a, 1))]);
    clear a
end

h5create("Particles_Phi.h5", "/data", size(particles_phi));
h5write("Particles_Phi.h5", "/data", single(particles_phi))

h5create("Particles_Theta.h5", "/data", size(particles_theta));
h5write("Particles_Theta.h5", "/data", single(particles_theta))

save('Ori_data.mat')
