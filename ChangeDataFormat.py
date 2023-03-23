import h5py
import numpy as np # you need to install HDF5 API (python)

file_name = ['Particles_1st_axis_X.h5', 'Particles_1st_axis_Y.h5', 'Particles_1st_axis_Z.h5'];
DataSetname = ['X', 'Y', 'Z'];

for i in [0, 1, 2]:
    f1 = h5py.File(file_name[i], 'r+')

    data = np.array(f1[DataSetname[i]][:])
    # data = f1.get(DataSetname[i]).value
    f1.close()

    data_vvv = np.float32(data);

    # print(type(data[0, 0, 0]))
    f2 = h5py.File('new_' + file_name[i], "w")    # mode = {'w', 'r', 'a'}

    d = f2.create_dataset(DataSetname[i], data=data_vvv)

    f2.close()