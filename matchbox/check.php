 <?php 



require_once "../StyleJS/json/JSON.php";
$json = new Services_JSON();

$url = $_GET["url"];

$descriptorspec = array(
    0 => array("pipe", "r"),  // stdin is a pipe that the child will read from
   1 => array("pipe", "w"),  // stdout is a pipe that the child will write to
    2 => array("file", "/data/home/scape/public_html/test/error-output.txt", "a")// 2 is STDERR for process
 );

$cmd = "DISPLAY=:0 python2.7 ./FindDuplicates.py ".$url." all";

$p=proc_open ($cmd, $descriptorspec, $pipes);

$out = stream_get_contents($pipes[1]) ;

$out2 = $json->encode($out);
$parts = explode('\n', $out2);

$result = $json->encode($parts[sizeof($parts)-1]);
print($result);

proc_close($p);


?>
