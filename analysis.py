import os, mysql.connector, pandas as pd
import matplotlib.pyplot as plt
from getpass import getpass
conn=mysql.connector.connect(host='localhost',user='root',password=getpass('MySQL password: '),database='foodfleet_hybrid')
cur=conn.cursor()
cur.execute('SELECT * FROM vw_restaurant_analytics')
df=pd.DataFrame(cur.fetchall(),columns=cur.column_names)
print(df.head())
df['hour']=pd.to_datetime(df['ordered_at']).dt.hour
hours=df.groupby('hour').size()
hours.plot(title='Orders by hour');plt.savefig('peak-hours.png');plt.close()
print(df.groupby('restaurant')['delivery_minutes'].mean())
df.groupby('restaurant')['delivery_minutes'].mean().plot(title='Delivery minutes')
plt.tight_layout();plt.savefig('delivery-times.png');plt.close()
cur.close();conn.close()
