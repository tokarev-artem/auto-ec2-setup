<?php
  $servername = "localhost";
  $username = "{{ domain_name }}";
  $password = "{{ db_pass }}";

  $conn = new mysqli($servername, $username, $password);

  if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
  }
  echo "Connected successfully";
?>