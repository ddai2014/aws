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
require 'AWSSDK/aws.phar';
$az = file_get_contents('http://169.254.169.254/latest/meta-data/placement/availability-zone');
$ipAddress = file_get_contents('http://169.254.169.254/latest/meta-data/public-ipv4');
$instanceID = file_get_contents('http://169.254.169.254/latest/meta-data/instance-id');
echo '<hr>';
echo '<div>';
echo '	<h2>Server Information</h2>';
echo '	<p>IP Address: ' . $ipAddress . '<br>';
echo '	   Region/Availability Zone: ' . $ipAddress . '<br>';
echo '	   Instance ID: ' . $instanceID . '</p>';
echo '</div>';
?>
</body>
</html>
