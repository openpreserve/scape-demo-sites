 <?php 

	//expecting Matchbox is set up and configured
 	$output = array();
  	$command = "FindDuplicates " . "/matchbox/matchbox-samples" . " all";
	exec($command, $output);
 	$formatted = "";
   	foreach ( $output as $line ) {
   		// append each line, but make it HTML-friendly first
   		$formatted .= htmlspecialchars ( $line ) . "<br/>";
   	}

 	$result = json_encode("<br>Processed<br>" . $formatted);
 	print($result);

?>
