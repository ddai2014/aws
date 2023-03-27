<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>David's Demo Site</title>
</head>
<body>
    <div>
        <h1>David's Demo Site</h1>
    </div>
<?php
require 'aws.phar';
$url = 'http://169.254.169.254/latest/meta-data/';	
$publicIp = file_get_contents($url . 'public-ipv4');
$az = file_get_contents($url . 'placement/availability-zone');
$instanceID = file_get_contents($url . 'instance-id');
echo '<hr>';
echo '<div>';
echo '	<h2>Server Information: <br>';
echo '	    IP Address: <font color="red">' . $publicIp . '</font><br>';
echo '	   Region/Availability Zone: <font color="red">' . $az . '</font><br>';
echo '	   Instance ID: <font color="red">' . $instanceID . '</font></h2>';
echo '</div>';
?>
</body>
</html>
