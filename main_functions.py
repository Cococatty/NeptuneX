from project_imports import *



#####################---------DATA PREPROCESSING---------#####################

def write_dict_csv(data_dict, data_header, file_name):    
    try:
        output_file = os.path.join(init_metadata.file_path_output, file_name+'.csv')
       
        with open(output_file, 'w') as csv_file:
           
            # csv_file.write('\n'.join(data_header))
            csv_file.write('%s\n' % (data_header))

            for key in data_dict.keys():
                csv_file.write('%s, %s\n' % (key, data_dict[key]))
            
            csv_file.write('Last updated: %s\n' % (datetime.now()))
        print(output_file)
                
    except IOError:
        print('I/O error')


#####################---------GENERATE RANDOMIZERS---------#####################
def generate_randomizers(items_to_randomize, str_header, export_result=True, file_name='unknown'):
    try:
        dict_item_random = {}        
        for i in items_to_randomize:
            rand_perc = np.random.uniform(0.5, 2)
            dict_item_random[i] = rand_perc

        if (export_result):
            write_dict_csv(data_dict=dict_item_random, data_header=str_header, file_name=file_name)
        print('Finished generating RANDOMIZERS')
    except:
        print('generate_randomizers failed')


def randomize_values(df_target):
    try:
        print('I AM HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
    except:
        print('I AM HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!')



#####################---------TEMPORARY SOLUTIONS---------#####################
def randomize_all(items_to_randomize, str_header, export_result=True, file_name='unknown'):
    try:
        dict_item_random = {}        
        for i in items_to_randomize:
            rand_perc = np.random.uniform(0.5, 2)
            dict_item_random[i] = rand_perc

        if (export_result):
            write_dict_csv(data_dict=dict_item_random, data_header=str_header, file_name=file_name)
        print('Finished generating RANDOMIZERS')
    except:
        print('generate_randomizers failed')



#####################---------EXTRACT INFO---------#####################


#####################---------ARCHIVED AREA---------#####################
# writer = csv.DictWriter(csv_file, fieldnames=head_row)
                    # writer.writeheader()
                    
        # with open(file_name, 'w') as csv_file:
        #     writer = csv.DictWriter(csv_file, fieldnames=data_header)
        #     writer.writeheader()
        #     for data in data_dict:
        #         writer.writerow(data)




# print('I AM HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!')