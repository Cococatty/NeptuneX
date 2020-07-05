import sys, os

sys.path.append(os.path.abspath('C:\\Projects\\NeptuneX\\'))
# sys.path.append(os.getcwd)

from project_imports import *

from importlib import *
# project_imports = importlib.reload(project_imports)
init_metadata = importlib.reload(init_metadata)


#####################---------LOAD DATA---------##################### 
load_file = glob.glob(init_metadata.file_path_data.format(init_metadata.file_key_CC,'*'))
df_cc_source = pd.read_csv(load_file[0])

load_file = glob.glob(init_metadata.file_path_data.format(init_metadata.file_key_daily,'*'))
df_daily_source = pd.read_csv(load_file[0])
# load_file


#####################---------BASIC MANIPULATION---------##################### 

# Assign Unique ID
df_daily_source['source_id'] = df_daily_source.index
df_cc_source['source_id'] = df_cc_source.index

# set acct type
df_daily_source['source_acct'] = 'Daily'
df_cc_source['source_acct'] = 'CC'

# rename fields
df_daily_source = df_daily_source.rename(columns={'Date':'trans_date', 'Amount':'trans_amount', 'Description':'trans_category', 'Particulars':'analysis_code'})
df_cc_source = df_cc_source.rename(columns={'Transaction Date':'trans_date', 'Amount':'trans_amount', 
'Other Party':'other_party', 'Credit Plan Name':'trans_category', 'Analysis Code':'analysis_code', 'City':'foreign_city','Country Code':'foreign_country'})

df_cc_source.columns = (df_cc_source.columns.str.replace(' ', '_')).str.lower()
df_daily_source.columns = (df_daily_source.columns.str.replace(' ', '_')).str.lower()

print('Finished BASIC MANIPULATION')


#####################---------FOREIGN DETAILS EXTRACTION---------##################### 

########    EXTRACT BY REGEXP
## CC
# foreign_amount	Foreign Details
# foreign_fee	Foreign Details
break_foreign_details = lambda x: x.str.extract(
    r'(?P<foreign_date>\d+/\d+/\d+)\s+(?P<foreign_amt>\d+.\d+)\s+(?P<foreign_currency>\w+)\s+(?P<foreign_process>[\w\s]+)\$\s+(?P<foreign_fee>\d+.\d+)\s+(?P<foreign_process_currency>\w+)',
    expand=True)

# df_foreign_details = df_cc_source.apply(lambda x: break_foreign_details(df_cc_source.loc[:,'foreign_details']), axis=1)
col_detail = df_cc_source.loc[:, 'foreign_details'].astype('str')
df_foreign_details = break_foreign_details(col_detail)

df_foreign_details['source_id'] = pd.Series(range(0, len(df_foreign_details)))

df_cc_source = pd.merge(df_cc_source, df_foreign_details, how='left', on='source_id')


df_cc_source_cols = [
    'source_id', 'source_acct', 
    'trans_date', 'trans_amount', 'other_party', 'trans_category',
    'foreign_details', 'foreign_city', 'foreign_country',
    'foreign_date', 'foreign_amt',
    'foreign_currency', 'foreign_process', 'foreign_fee',
    'foreign_process_currency',]

df_cc = pd.DataFrame(df_cc_source, columns=df_cc_source_cols)

########    EXTRACT BY NLP

# ## NLP field value manipulation
## CC
# trans_merchant	Other Party
# trans_city	Other Party
# trans_country	Other Party


## Testing setup
# col_foreign_details = df_cc_source[df_cc_source.Foreign_Details.notnull()]['Foreign_Details']
# print(col_foreign_details)
# col_foreign_details.to_csv('foreign_detils_col.csv', columns=['id', 'item'])
# # 


# nlp()

# col_foreign_details







# Daily
# trans_time	Reference
# trans_merchant	Other Party
# trans_city	Other Party
# trans_country	Other Party


#####################---------COMBINE DATAFRAMES---------##################### 


##---------AFTER THE CONSOLIDATED DF IS BUILT---------

#####################---------RANDOMIZE VALUES---------##################### 
def to_complete():
    main_functions.generate_randomizers(
        items_to_randomize=init_metadata.list_item_toRandom,
        str_header='item, rand_perc',    
        export_result=True, 
        file_name='meta_randomization')

    main_functions.randomize_values(df_target=df_final)

    print('Finished RANDOMIZING VALUES')

#####################---------REMOVE SENSITIVE INFORMATION---------##################### 
## Names
## Geospatial (Address, Location) 






#####################---------Inspecting, Debugging---------##################### 
# import inspect
# lines = inspect.getsource(main_function.write_dict_csv)
# print(lines)


## Reloading

#####################---------ARCHIVED AREA---------##################### 
# sys.path.append(os.path.abspath('C:\\Projects\\NeptuneX\\'))
# sys.path.append(os.getcwd)
# from importlib import reload  
# import main_function

# main_function = reload(main_function)


