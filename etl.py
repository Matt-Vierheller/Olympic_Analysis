import pandas as pd
from sqlalchemy import create_engine
from urllib.parse import quote_plus

password = input('Type password!:')
def get_engine():
    encoded_password = quote_plus(password)
    engine = create_engine(f'postgresql://postgres:{encoded_password}@localhost:5432/olympics')

    # Test the connection
    try:
        with engine.connect() as conn:
            print("✅ Connected to PostgreSQL!")
        return engine
    except Exception as e:
        print(f"❌ Connection failed: {e}")
        return None

def load_data(engine):
    #extract: REad CSV files
    print("Reading CSV files..")
    athlete_events = pd.read_csv('athlete_events.csv')
    noc_regions = pd.read_csv('noc_regions.csv')
    print(f'Events: {len(athlete_events)} rows')
    print(f'Regions: {len(noc_regions)} rows')

    #Transform: Clean Data
    print('Cleaning Data...')
    athlete_events['Medal'] = athlete_events['Medal'].fillna('None')
    noc_regions['notes'] = noc_regions['notes'].fillna('')

    #Load: insert into PostgreSQL
    print('Loading data into PostgreSQL...')
    athlete_events.to_sql('athlete_events', con = engine, if_exists = 'replace',
                     index = False)
    print('athlete_even table created!')
    noc_regions.to_sql('noc_regions', con = engine, if_exists = 'replace',
                   index = False)
    print('noc_regions table created')



    #combine the cities and countries for host data
    print('Creating host cities table...')
    host_data = {
        'City': ['Athina', 'Paris', 'St. Louis', 'London', 'Stockholm', 'Antwerpen', 
             'Paris', 'Amsterdam', 'Los Angeles', 'Berlin', 'London', 'Helsinki',
             'Melbourne', 'Roma', 'Tokyo', 'Mexico City', 'Munich', 'Montreal',
             'Moskva', 'Los Angeles', 'Seoul', 'Barcelona', 'Atlanta', 'Sydney',
             'Athina', 'Beijing', 'London', 'Rio de Janeiro',
             'Chamonix', 'St. Moritz', 'Lake Placid', 'Garmisch-Partenkirchen',
             'St. Moritz', 'Oslo', 'Cortina d\'Ampezzo', 'Squaw Valley',
             'Innsbruck', 'Grenoble', 'Sapporo', 'Innsbruck', 'Lake Placid',
             'Sarajevo', 'Calgary', 'Albertville', 'Lillehammer', 'Nagano',
             'Salt Lake City', 'Torino', 'Vancouver', 'Sochi'],
        'Host_Country': ['Greece', 'France', 'USA', 'UK', 'Sweden', 'Belgium',
                     'France', 'Netherlands', 'USA', 'Germany', 'UK', 'Finland',
                     'Australia', 'Italy', 'Japan', 'Mexico', 'Germany', 'Canada',
                     'Russia', 'USA', 'South Korea', 'Spain', 'USA', 'Australia',
                     'Greece', 'China', 'UK', 'Brazil',
                     'France', 'Switzerland', 'USA', 'Germany',
                     'Switzerland', 'Norway', 'Italy', 'USA',
                     'Austria', 'France', 'Japan', 'Austria', 'USA',
                     'Yugoslavia', 'Canada', 'France', 'Norway', 'Japan',
                     'USA', 'Italy', 'Canada', 'Russia']
                }

    host_df = pd.DataFrame(host_data)
    host_df.to_sql('host_cities', con = engine, if_exists = 'replace',
               index = False)
    print("host_cities table created")
    print('All done! Your data is not in PostgreSQL!')

if __name__ == '__main__':
    engine = get_engine()
    load_data(engine)