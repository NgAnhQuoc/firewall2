<?php

namespace VnxLogcenterAPI;

require_once  __DIR__ . '/LogcenterAPI.php';

use VnxLogcenterAPI\LogcenterAPI;

class GraphAPI extends LogcenterAPI
{
  public function __construct($ep, $retries = 5, $guzzleOptions = [])
  {
    $endpoint = 'https://push.logcenter.k8s.vietnix.xyz/filebeat-webfw-' . $ep . '-*/_search';
    $guzzleOptions = ['headers' => ['Content-Type' => 'application/json', 'Authorization' => 'Basic ZGV2Oko3NFhOdjVXMkI3Snl2OA==']];
    parent::__construct($endpoint, $retries, $guzzleOptions);
  }

  public function getData($postfield = [])
  {
    return $this->request('GET', '', $postfield);
  }
}
