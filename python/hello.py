


# get_url= urllib.request.urlopen('https://www.jetbrains.com/toolbox-app/download/download-thanks.html')

# print("Response Status: "+ str(get_url.getcode()) )

import subprocess
import urllib.request
import os
from html.parser import HTMLParser

with urllib.request.urlopen('https://www.jetbrains.com/toolbox-app/') as response:
   html = response.read()

   print(html)
