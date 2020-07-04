import csv
import glob
import os
import init_metadata

# os.getcwd()

# file_path_output = 'C:\\Projects\\NeptuneX\\output\\'
# global 


def write_dict_csv(data_dict, data_header, file_name):
    try:
        output_file = os.path.join(init_metadata.file_path_data, file_name+'.csv')
       
        with open(output_file, 'w') as csv_file:
           
            # csv_file.write('\n'.join(data_header))
            csv_file.write('%s\n' % (data_header))

            for key in data_dict.keys():
                csv_file.write('%s, %s\n' % (key, data_dict[key]))
        
    except IOError:
        print('I/O error')




#####################           ARCHIVED AREA           #####################
# writer = csv.DictWriter(csv_file, fieldnames=head_row)
                    # writer.writeheader()
                    
        # with open(file_name, 'w') as csv_file:
        #     writer = csv.DictWriter(csv_file, fieldnames=data_header)
        #     writer.writeheader()
        #     for data in data_dict:
        #         writer.writerow(data)




