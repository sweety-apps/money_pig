<?php

function parseParam() {
}

function get($url) {
	$newUrl = $url.'?'.$_SERVER["QUERY_STRING"];

  	$options = array(   
    	'http' => array(   
      	'method' => 'GET',   
      	'header' => 'Content-type:application/x-www-form-urlencoded',   
      	'content' => '',   
      	'timeout' => 10 // 超时时间（单位:s）
		)   
  	);   
 	$context = stream_context_create($options);   
  	$result = file_get_contents($newUrl, false, $context);   
  	
	return $result;   
}

?>