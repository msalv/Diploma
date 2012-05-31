<?php

/*
 * Sample local settings
 * Individual for every project.
 * Edit and rename it to local_settings.php
 */

// Current template
define('TEMPLATE_ROOT', PROJECT_ROOT . '/templates/default/');

// DB connection settings
const DB_ENGINE = 'mysql';
const DB_HOST = 'localhost';
const DB_NAME = 'diploma';

const DB_USER = 'root';
const DB_PASS = 'root';

define('CONN_STRING', DB_ENGINE . ':host='. DB_HOST . ';dbname=' . DB_NAME);

/**
 * PDO_ERRMODE
 * Options:
 *     PDO::ERRMODE_SILENT
 *     PDO::ERRMODE_WARNING
 *     PDO::ERRMODE_EXCEPTION
 */
const PDO_ERRMODE = PDO::ERRMODE_SILENT;

/* 
 * SMS notifications settings
 * SMS gateway provided by Yakoon.com (sponsor! actually it's not a sponsor).
 * Password should be hashed with md5.
 */
const SMS_USER = 'username';
const SMS_PASS = '5f4dcc3b5aa765d61d8327deb882cf99'; // == md5('password');

?>
