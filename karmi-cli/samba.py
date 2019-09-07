#!/Library/Frameworks/Python.framework/Versions/3.7/bin/python3


import sqlite3
conn = sqlite3.connect('/Users/christopher/Documents/GitHub/docker-samba4/karmi-cli/db/samba.db')

c = conn.cursor()

c.execute("INSERT INTO general ( 'key', 'value' ) VALUES ('netbios name','pdc')")
conn.commit()
conn.close()





