 <?php 

// This is a test page not over yet we have problems related to run selenium etc. 

require_once "../StyleJS/json/JSON.php";
$json = new Services_JSON();

$url1 = $_GET["url1"];
$url2 =  $_GET["url2"];
$type = $_GET["type"];
print($type);
echo exec("ps aux | grep -ie JPage | awk '{print $2}' | xargs kill -9");
echo exec("ps aux | grep -ie Xvfb | awk '{print $2}' | xargs kill -9");

$descriptorspec = array(
    0 => array("pipe", "r"),  // stdin is a pipe that the child will read from
    1 => array("pipe", "w"),  // stdout is a pipe that the child will write to
     2 => array("file", "/data/home/scape/public_html/test/error-output.txt", "a")
 );



$path = getenv('PATH');
$nepath =$path.":/home/scape/bin/firefox/";
print($nepath);
putenv("PATH=$nepath");  
echo  getenv('PATH');



$date  = time();
print($date);
$cmd = "Xvfb :".$date." -screen 0 1024x768x24 &";
print($cmd);

echo exec($cmd);

$cmd = "DISPLAY=:".$date." java -jar  JPagelyzer.jar -get score -cmode images -url1 ".$url1." -url2 ".$url2." -local 2>&1";
print($cmd);




?>
