 <?php 

	//expecting Matchbox is set up and configured
 	$output = array();
  	$command = "python2.7 ./FindDuplicates.py " . escapeshellarg($_FILES['matchboxToValidate']["tmp_name"]) . " all";
	print($command);
   	exec($command, $output);
	print($output);

?>
