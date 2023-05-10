import urllib.request

from html.parser import HTMLParser

get_url= urllib.request.urlopen('https://www.jetbrains.com/toolbox-app/download/download-thanks.html')

print("Response Status: "+ str(get_url.getcode()) )

