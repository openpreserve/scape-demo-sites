 <?php


echo exec("ps aux | grep -ie jPage | awk '{print $2}' | xargs kill -9");


?>

