<?php

file_put_contents("result.txt",  $_POST['app'] . "\n", FILE_APPEND);
exit();
?>
