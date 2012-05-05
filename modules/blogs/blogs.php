<?php

// Define current module root directory
define( 'MODULE_ROOT', dirname(__FILE__) );

require MODULE_ROOT . '/Blog.php';
require MODULE_ROOT . '/BlogMapper.php';
require MODULE_ROOT . '/BlogController.php';
require PROJECT_ROOT . '/core/XSLViewLoader.php';

?>
