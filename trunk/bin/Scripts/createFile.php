<?php
	$error = false;
	// if variables aren't empty
	if ( isset($_GET["text"]) && isset($_GET["url"]) ) {
		$url = "../".$_GET["url"];
		$text = $_GET["text"];
		
		$file = fopen($url, "w+");
		// if the file is created
		if ( $file ) {
			// if I can write in it
			if ( !fwrite($file, $text) ) {
				$error = true;
			}
			fclose($file);
		}
		else {
			$error = true;
		}
	}
	
	if ( $error ) {
		echo "error";
	}
	else {
		echo "done";
	}
?>