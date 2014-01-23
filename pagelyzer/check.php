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
	$cmd = "DISPLAY=:1 java -jar  jPagelyzer.jar -get score -cmode images -url1 ".$url1." -url2 ".$url2." 2>&1";
}
elseif($type == 2)
{
	$cmd = "DISPLAY=:1 java -jar  jPagelyzer.jar -get score -cmode structure -url1 ".$url1." -url2 ".$url2." 2>&1";
}
else
{
	$cmd = "DISPLAY=:1 java -jar  jPagelyzer.jar -get score -cmode hybrid -url1 ".$url1." -url2 ".$url2." 2>&1";
}

$p=proc_open ($cmd, $descriptorspec, $pipes);

$out = stream_get_contents($pipes[1]) ;
$out2 = $json->encode($out);
$parts = explode('\n', $out2);
$result = $json->encode($parts[sizeof($parts)-2]);
print($result);
proc_close($p);
?>

