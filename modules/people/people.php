<?php

    echo "<h1>Users module</h1><br />";
    
    if ( isset($username) ) {
        echo "Show $username info";
    }
    else {
        echo "Show list of users";
    }

?>
