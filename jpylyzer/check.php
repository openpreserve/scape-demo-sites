<?php

    // Note: have change php.ini to be able to upload larger files
    // upload_max_filesize = 50M
    // post_max_size = 192M

    //function recurIterate(node) {
    //    $outString .= "<li>" . $elem.getName() . "</li>";

    //    foreach($node as $child) {
    //        $outString .= recurIterate($child);
    //    }
    //    return $outString;
    //}

    //expecting Jpylyzer is set up and configured
    $output = array();
    $command = "jpylyzer " . escapeshellarg($_FILES['jp2ToValidate']["tmp_name"]);
    exec($command, $output);
    $xml = implode("", $output);
    $jpOut = simplexml_load_string($xml);
    $formatted = "<p>" . $jpOut->toolInfo->toolName . "-" . $jpOut->toolInfo->toolVersion . "<br />";
    $formatted .= "Valid JP2: " . $jpOut->isValidJP2 . "<br />";
    $formatted .= "File Type: " . $jpOut->properties->fileTypeBox->br . "<br />";
    $formatted .= "Height: " . $jpOut->properties->jp2HeaderBox->imageHeaderBox->height . "<br />";
    $formatted .= "Width: " . $jpOut->properties->jp2HeaderBox->imageHeaderBox->width . "</p>";
    //print($result);
    foreach($jpOut->tests as $test) {
        foreach($test as $elem) {
            $formatted .= $elem->getName() . "<br/>";
        }
    }
    $result = json_encode($formatted);
    print($result);


?>
