# global pd
import os, glob, re, sys, importlib, init_metadata, numpy, nltk, spacy
import pandas as pd

__all__ = ['os', 'glob', 're', 'sys', 'importlib', 'init_metadata', 
'numpy', 'pd',
'nltk', 'spacy'
 ]

pd.set_option('display.max_colwidth', None)


nltk.download('punkt', os.path.join(init_metadata.file_path_downloads, 'nlp'))
nltk.download('stopwords', os.path.join(init_metadata.file_path_downloads, 'nlp'))
nltk.download('wordnet', os.path.join(init_metadata.file_path_downloads, 'nlp'))

from nltk.tokenize import word_tokenize
from nltk.tag import pos_tag


nlp = spacy.load('en_core_web_sm')