import sys, os

sys.path.append(os.path.abspath('C:\\Projects\\NeptuneX\\'))
# sys.path.append(os.getcwd)

from project_imports import *

from importlib import *
# project_imports = importlib.reload(project_imports)
# init_metadata = importlib.reload(init_metadata)


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


#####################---------CC---------#####################

#########---------FOREIGN DETAILS EXTRACTION---------#########
########    EXTRACT BY REGEXP
## CC
# foreign_amount	Foreign Details
# foreign_fee	Foreign Details
break_foreign_details = lambda x: x.str.extract(
    r'(?P<foreign_date>\d+/\d+/\d+)\s+(?P<foreign_amount>\d+.\d+)\s+(?P<foreign_currency>\w+)\s+(?P<foreign_process>[\w\s]+)\$\s+(?P<foreign_fee>\d+.\d+)\s+(?P<foreign_process_currency>\w+)',
    expand=True)

# df_foreign_details = df_cc_source.apply(lambda x: break_foreign_details(df_cc_source.loc[:,'foreign_details']), axis=1)
col_detail = df_cc_source.loc[:, 'foreign_details'].astype('str')
df_foreign_details = break_foreign_details(col_detail)

df_foreign_details['source_id'] = pd.Series(range(0, len(df_foreign_details)))

df_cc_source = pd.merge(df_cc_source, df_foreign_details, how='left', on='source_id')


col_cc_source = [
    'source_id', 'source_acct', 
    'trans_date', 'trans_amount', 'other_party', 'trans_category',
    'foreign_details', 'foreign_city', 'foreign_country',
    'foreign_date', 'foreign_amount',
    'foreign_currency', 'foreign_process', 'foreign_fee',
    'foreign_process_currency',]

df_cc = pd.DataFrame(df_cc_source, columns=col_cc_source)
df_cc = df_cc.replace(np.nan, 0, regex=True)


def str_to_float(x):
    return x.str.replace(',', '').astype('float')

df_cc = pd.DataFrame(df_cc_source, columns=col_cc_source)
df_cc[['foreign_amount', 'foreign_fee']] = df_cc[ ['foreign_amount', 'foreign_fee']].apply(str_to_float, axis=1)


########    EXTRACT BY NLP

# ## NLP field value manipulation
## CC
# trans_merchant	Other Party
# trans_city	Other Party
# trans_country	Other Party




#####################---------DAILY---------#####################
df_daily = df_daily_source.replace(np.nan, '', regex=True)

#########---------FOREIGN DETAILS EXTRACTION---------#########
# trans_time	Reference
# trans_merchant	Other Party
# trans_city	Other Party
# trans_country	Other Party

########    EXTRACT BY NLP, Word Embeddings
def ner_pos_tag_a_col(col_detail):
    sent = nltk.word_tokenize(col_detail)
    sent = nltk.pos_tag(sent)
    return sent

col_otherparty = (df_daily['other_party']).astype('str')
# ner_foreign_details = df_daily_source.apply(lambda x: ner_pos_tag_a_col(x[:,'other_party']), axis=1)
ner_foreign_details = col_otherparty.apply(lambda x: ner_pos_tag_a_col(x))
ner_foreign_details



df_daily = df_daily_source.replace(np.nan, 0, regex=True)
# df_daily_source['other_party'].astype('str').apply(lambda x: list(nlp(x).ents))
# df_daily_source['other_party'].apply(lambda x: list(nlp(x).ents))




#####################---------RANDOMIZE ALL VALUES WO RULES---------#####################
# df_cc['trans_amount'] = df_cc['trans_amount'] * np.random.uniform(0.5, 2)
# df_cc['foreign_amount'] = df_cc['foreign_amount'].str.replace(',', '').astype('float') * np.random.uniform(0.5, 2)
# df_cc['foreign_fee'] = df_cc['foreign_fee'] * np.random.uniform(0.5, 2)

df_cc[['trans_amount', 'foreign_amount', 'foreign_fee']] = df_cc[['trans_amount', 'foreign_amount', 'foreign_fee']].apply(lambda x: x*np.random.uniform(0.5, 2), axis=1)

df_daily['trans_amount'] = df_daily['trans_amount'] * np.random.uniform(0.5, 2)


# datetime.datetime.strptime(df_daily['trans_date'], '%d/%m/%y')
df_daily['trans_date'] = pd.to_datetime(df_daily['trans_date']) + timedelta(days=np.random.randint(low=-10, high=10))
df_cc['trans_date'] = pd.to_datetime(df_cc['trans_date']) + timedelta(days=np.random.randint(low=-10, high=10))



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




#####################---------EXPORT---------#####################
file_daily = os.path.join(init_metadata.file_path_output, 'df_daily.csv')
file_cc = os.path.join(init_metadata.file_path_output, 'df_cc.csv')

if os.path.exists(file_daily): os.remove(file_daily)
if os.path.exists(file_cc): os.remove(file_cc)


df_daily.to_csv(file_daily, index=False)
df_cc.to_csv(file_cc, index=False)
# , sep='\t'

print('Finished EXPORT')
