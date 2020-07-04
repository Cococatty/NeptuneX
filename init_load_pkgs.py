def load_libraries():    
    ################            BAU            ################
    global os
    import os

    global glob
    import glob

    global re
    import re

    global sys   
    import sys

    global importlib
    import importlib


    import init_metadata
    global init_metadata

    ################            Basic manipulation            ################
    global np
    import numpy as np

    global pd
    import pandas as pd


    ################            NLP            ################
    global nltk
    import nltk

    global PorterStemmer
    from nltk.stem import PorterStemmer as PorterStemmer

    global WordNetLemmatizer
    from nltk.stem import WordNetLemmatizer as WordNetLemmatizer

    global spacy
    import spacy


    pd.set_option('display.max_colwidth', None)

    nltk.download('punkt', os.path.join(init_metadata.file_path_downloads, 'nlp'))
    nltk.download('stopwords', os.path.join(init_metadata.file_path_downloads, 'nlp'))
    nltk.download('wordnet', os.path.join(init_metadata.file_path_downloads, 'nlp'))
    nlp = spacy.load('en_core_web_sm')


load_libraries()
