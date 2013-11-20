 <?php 


require_once "../json/JSON.php";
$json = new Services_JSON();

$url1 = $_GET["url1"];
$url2 =  $_GET["url2"];
$type=  $_GET["type"];

$ok = 1;


if ($type ==0) {
    $cmd = "./scape-xcorrsound-master/build/apps/waveform-compare".$url1." ".$url2." 2>&1";
} elseif ($type ==1) {
    $cmd = "./scape-xcorrsound-master/build/apps/sound-match".$url1." ".$url2." 2>&1";
} elseif ($type ==2) {
    $cmd = "./scape-xcorrsound-master/build/apps/overlap-analysis".$url1." ".$url2." 2>&1";
}else
{
	echo "type error";
	$ok = 0;
}

if($ok ==1)
{
	exec($cmd, $output);
	$result = $json->encode($output);
	print($result);
}


?>
