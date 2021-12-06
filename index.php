<?php
// require 'vendor/autoload.php';
require 'src/gender.php';

$name = $_GET['name'];
$sex = (new NameChecker)->getSex($name);

header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json; charset=utf-8');
echo json_encode(['name' => $name, 'sex' => $sex]);