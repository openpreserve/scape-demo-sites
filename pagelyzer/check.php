 <?php

require_once "../StyleJS/json/JSON.php";
$json = new Services_JSON();

$url1 = $_GET["url1"];
$url2 =  $_GET["url2"];
$type = $_GET["type"];


$descriptorspec = array(
    0 => array("pipe", "r"),  // stdin is a pipe that the child will read from
    1 => array("pipe", "w"),  // stdout is a pipe that the child will write to
    2 => array("pipe", "w") 
 );

if($type == 1)
{
	$config="config_image.xml";
}
elseif($type == 2)
{
	$config="config_content.xml";
}
else
{
	$config="config_hybrid.xml";
}
$cmd = "java -jar  Pagelyzer-0.0.1-SNAPSHOT-jar-with-dependencies.jar -url1 ".$url1." -url2 ".$url2." -config ".$config." 2>&1";

$p=proc_open ($cmd, $descriptorspec, $pipes);

$out = stream_get_contents($pipes[1]) ;
$out2 = $json->encode($out);
$parts = explode('\n', $out2);
$output = array();
for ($i = 1; $i < sizeof($parts); $i++) {
    $output[] = $json->encode($parts[$i]);
	
}
echo json_encode($output);

proc_close($p);
?>

