"Hello world"  | out-file hello_world.txt
$hello_world_content = get-content hello_world.txt;
$hello_world_content = $hello_world_content.Replace('world', 'PowerShell')
$hello_world_content
$hello_world_content | out-file hello_world.txt;  