<?php header("HTTP/1.0 404 Not Found"); ?>
<!DOCTYPE html>
<html>
    <head>
        <title>404 Not Found</title>
        <meta charset="UTF-8" />
    </head>
    <body>
        <h1>Not Found</h1>
        <p>The requested URL <?php echo $uri[0]; ?> was not found on this server.</p>
        <hr />
    </body>
</html>