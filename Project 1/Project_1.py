import kaggle
!kaggle datasets download ankitbansal06/retail-orders -f orders.csv

import zipfile
zipref = zipfile.ZipFile('orders.csv.zip')
zipref.extractall()
zipref.close

import pandas as pd
df = pd.read_csv('orders.csv')
df.head(20)

df = pd.read_csv('orders.csv',na_values=['Not Available','unknown'])
df['Ship Mode'].unique()

# Rename column names (Lowercase and separated by '_')
df.columns = df.columns.str.lower().str.replace(' ','_')
df.columns
df.head()

# Create new column for Discount price, Sale price and Profit
df['discount_price'] = df['list_price'] * df['discount_percent']*.01
df['sale_price'] = df['list_price'] - df['discount_price']
df['profit'] = df['sale_price'] - df['cost_price']
df

# convert order date from object data type to datetime
df['order_date'] = pd.to_datetime(df['order_date'],format="%Y-%m-%d")
df['order_date']

# Drop cost price, list price and discount percent columns
df.drop(columns=['cost_price','list_price','discount_percent'],inplace=True)
df

# Load the data to SQL Server
import mysql.connector
from mysql.connector import Error

def create_connection():
    connection = None
    try:
        connection = mysql.connector.connect(
            host='127.0.0.1',  # or 'localhost'
            user='root',
            password='admin123',  # replace with your actual password
            database='orders'  # replace with your actual database name
        )
        if connection.is_connected():
            print("Connected to MySQL server")
    except Error as e:
        print(f"Error: {e}")
    return connection

# Establish connection
connection = create_connection()

# Check connection
if connection:
    print("Connection established successfully!")
    # Close the connection
    if connection.is_connected():
        connection.close()
        print("MySQL connection is closed")
else:
    print("Failed to establish connection.")


import pandas as pd
from sqlalchemy import create_engine

# Define your MySQL connection details
user = 'root'
password = 'admin123'
host = '127.0.0.1'
database = 'orders'

# Create an SQLAlchemy engine
engine = create_engine(f'mysql+mysqlconnector://{user}:{password}@{host}/{database}')

# Write the DataFrame to a SQL table
df.to_sql('df_orders', con=engine, index=False, if_exists='append')
print("DataFrame written to table `df_orders` successfully.")

df.to_sql('df_orders', con=engine, index=False, if_exists='append')
print("DataFrame written to table `df_orders` successfully.")