
$mysql_download_link = "https://downloads.mysql.com/archives/get/p/8/file/mysql-workbench-community-8.0.33-winx64.msi"

$download_link = "https://cdn.mysql.com/archives/mysql-workbench/mysql-workbench-community-8.0.33-winx64.msi"

$scrape_object = Invoke-WebRequest -Uri $download_link -OutFile "~/Downloads/test/test.msi "


