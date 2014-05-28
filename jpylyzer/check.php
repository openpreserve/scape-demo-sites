<?php

    // Note: have change php.ini to be able to upload larger files
    // upload_max_filesize = 50M
    // post_max_size = 192M

    //expecting Jpylyzer is set up and configured
    $output = array();
    if ($_POST['jp2ToValidateFromUrl'] != "") {
        $myFile = tempnam(sys_get_temp_dir(), "tempFile");
        file_put_contents($myFile, fopen($_POST['jp2ToValidateFromUrl'], 'r'));
    } else {
        $myFile = $_FILES['jp2ToValidate']["tmp_name"];
    }
    $command = "jpylyzer " . escapeshellarg($myFile);
    exec($command, $output);
    $xml = implode("", $output);
    $jpOut = simplexml_load_string($xml);
    $result = json_encode($xml);
    print("jpylyzerResultTree.showAll(" . $result . ")");

?>
