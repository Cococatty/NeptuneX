# global pd
import os, glob, re, sys, importlib, csv, init_metadata, main_functions, nltk, spacy
import pandas as pd
import numpy as np
from datetime import *
# datetime, 

__all__ = ['os', 'glob', 're', 'sys', 'importlib', 'csv', 'datetime', 
'init_metadata', 'main_functions',
'np', 'pd', 'nltk', 'spacy'
]


init_metadata = importlib.reload(init_metadata)
main_functions = importlib.reload(main_functions)

pd.set_option('display.max_colwidth', None)

nltk.download('punkt', os.path.join(init_metadata.file_path_downloads, 'nlp'))
nltk.download('stopwords', os.path.join(init_metadata.file_path_downloads, 'nlp'))
nltk.download('wordnet', os.path.join(init_metadata.file_path_downloads, 'nlp'))

from nltk.tokenize import word_tokenize
from nltk.tag import pos_tag


nlp = spacy.load('en_core_web_sm')

sys.path.append(os.path.abspath('C:\\Projects\\NeptuneX\\'))

#####################---------CUSTOM FILES---------##################### 
