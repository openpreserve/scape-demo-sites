<?php

    // for debuging php via a browser's javascript console
    // (firebug extension in firefox or native in chrome):
    //require_once('/vagrant/dev-tools/php-console-master/src/PhpConsole/__autoload.php');
    //$handler = PhpConsole\Handler::getInstance();
    //$handler->start();


    // Note: have change php.ini to be able to upload larger files
    // upload_max_filesize = 50M
    // post_max_size = 192M


    function parseFlintXml($checkedFile) {
        if ($checkedFile['result'] == "failed") {
            $outString = "<li class='failed'>CheckResult: *" . $checkedFile['result'] . "*";
        } else {
            $outString = "<li>CheckResult: *" . $checkedFile['result'] . "*";
        }

        $outString .= "<ul class='check-result'>";
        foreach($checkedFile->checkCategory as $cat) {
            if ($cat['result'] != "failed") {
                $outString .= "<li class='happy'>" . $cat['name'] . ": *" . $cat['result'] . "*</li>";
            } else {
                $outString .= "<li>" . $cat['name'] . ": *" . $cat['result'] . "*</li>";
            }
        }
        $outString .= "</ul>";
        $outString .= "</li>";

        return $outString;
    }

    $outputDir = sys_get_temp_dir() . "/flintTempDir";
    if(!(file_exists($outputDir) && is_dir($outputDir))) {
        mkdir($outputDir, 755);
    }

    //expecting flint is set up and configured
    $output = array();
    if ($_POST['flintValidateFromUrl'] != "") {
        $myFile = tempnam(sys_get_temp_dir(), "tempFile");
        file_put_contents($myFile, fopen($_POST['flintValidateFromUrl'], 'r'));
    } else {
        $myFile = $_FILES['flintValidate']["tmp_name"];
        //$handler->debug("file temporarily saved under " . $myFile);
    }

    $command = "java -jar /home/vagrant/flint/flint.jar " . escapeshellarg($myFile) . " --output " . $outputDir;

    //$handler->debug("running flint with command: " . $command);

    exec($command, $output);

    $xml = simplexml_load_file($outputDir . "/results.xml");


    $formatted = "<ul class='output'>";
    foreach($xml as $checkedFile) {
        $formatted .= parseFlintXml($checkedFile);
    }
    $formatted .=  "</ul>";

    print(json_encode($formatted));

?>
