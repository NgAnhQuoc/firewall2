<?php

use WHMCS\Database\Capsule;

class Helper
{
  public function get_service_by_id($id)
  {
    $pdo = Capsule::connection()->getPdo();
    $query = $pdo->query('SELECT * FROM tblhosting WHERE id = ' . $id);

    return $query->fetch(PDO::FETCH_ASSOC);
  }
}
