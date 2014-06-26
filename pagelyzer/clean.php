 <?php


echo exec("ps aux | grep -ie Pagelyzer | awk '{print $2}' | xargs kill -9");


?>

