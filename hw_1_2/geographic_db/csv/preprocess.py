import pandas as pd

input_dir = 'raw_csv_files/'
output_dir = 'processed_csv_files/'

#### CONTINENTS 
df = pd.read_csv(input_dir + 'continents.csv')
# Remove useless columns
df_post = df.drop(columns='wikiDataId')
df_post.to_csv(output_dir + 'continents.csv', index=False)

#### SUBCONTINENTS 
df = pd.read_csv(input_dir + 'subcontinents.csv')
# Rewrite Headers (from regions to continents)
df = df.rename(columns={'region_id' : 'continent_id'})
# Remove useless columns
df_post = df.drop(columns='wikiDataId')
df_post.to_csv(output_dir + 'subcontinents.csv', index=False)

#### COUNTRIES
df = pd.read_csv(input_dir + 'countries.csv')
# Rewrite Headers (from regions to continents)
df = df.rename(columns={'region_id' : 'continent_id', 'subregion_id' : 'subcontinent_id'})
# Rewrite float indices as int, replacing temporarily null values with zeros 
df['continent_id'] = df['continent_id'].fillna(0)
df['subcontinent_id'] = df['subcontinent_id'].fillna(0)
df['continent_id']=df['continent_id'].astype(int)
df['subcontinent_id']=df['subcontinent_id'].astype(int)
df['continent_id'] = df['continent_id'].replace(0, None)
df['subcontinent_id'] = df['subcontinent_id'].replace(0, None)
# Remove useless columns
columns = ['emoji',
           'emojiU',
           'iso2',
           'region',
           'subregion',
           'tld',
           'native',
           'currency_symbol',
           'currency',
           'numeric_code',
           'timezones'
           ]
df_post = df.drop(columns=columns)
df_post.to_csv(output_dir + 'countries.csv', index=False)

#### STATES
df = pd.read_csv(input_dir + 'states.csv')
# Remove useless columns
columns = ['country_name',
           'country_code',
           'state_code'
           ]
df_post = df.drop(columns=columns)
df_post.to_csv(output_dir + 'states.csv', index=False)

#### CITIES
df = pd.read_csv(input_dir + 'cities.csv')
# Remove useless columns
columns = ['state_code',
           'country_code',
           'state_name',
           'country_name',
           'wikiDataId'
           ]
df_post = df.drop(columns=columns)

# Remove tuples with null name (violate integrity constraint name not null)
df_post = df_post.dropna(subset=['name'])
df_post.to_csv(output_dir + 'cities.csv', index=False)