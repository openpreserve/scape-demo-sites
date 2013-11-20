<?php
/*
$allowedExts = array("gif", "jpeg", "jpg", "png");
$temp = explode(".", $_FILES["file"]["name"]);
$extension = end($temp);
if ((($_FILES["file"]["type"] == "image/gif")
        || ($_FILES["file"]["type"] == "image/jpeg")
        || ($_FILES["file"]["type"] == "image/jpg")
        || ($_FILES["file"]["type"] == "image/pjpeg")
        || ($_FILES["file"]["type"] == "image/x-png")
        || ($_FILES["file"]["type"] == "image/png"))
        && ($_FILES["file"]["size"] < 20000)
        && in_array($extension, $allowedExts))
  {
*/

$inputfiles = array("file1" , "file2");
foreach ($inputfiles as &$filename) {
   if ($_FILES[$filename]["error"] > 0)
   {
      echo "Return Code: " . $_FILES[$filename]["error"] . "<br>";
   }
   else
   {
      echo "Upload: " . $_FILES[$filename]["name"] . "<br>";
      echo "Type: " . $_FILES[$filename]["type"] . "<br>";
      echo "Size: " . ($_FILES[$filename]["size"] / 1024) . " kB<br>";
      echo "Temp file: " . $_FILES[$filename]["tmp_name"] . "<br>";

      if (file_exists("upload/" . $_FILES[$filename]["name"]))
      {
         echo $_FILES[$filename]["name"] . " already exists. ";
      }
      else
      {
         move_uploaded_file($_FILES[$filename]["tmp_name"], "upload/" . $_FILES[$filename]["name"]);
         echo "Stored in: " . "upload/" . $_FILES[$filename]["name"];
      }
  }
}
/*
  }
  else
  {
        echo "Invalid file";
  }
*/
?>
