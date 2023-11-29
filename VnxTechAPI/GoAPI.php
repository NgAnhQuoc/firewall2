<?php

namespace VnxTechAPI;

require_once  __DIR__ . '/InFwAPI.php';

use VnxTechAPI\InFwAPI;

class GoAPI extends InFwAPI
{
  public function __construct($fwip, $retries = 5, $guzzleOptions = [])
  {
    $endpoint = ':8080/v1/api/waf/';
    parent::__construct($endpoint, $fwip, $retries, $guzzleOptions);
  }

  public function getVersion()
  {
    return $this->request('GET', 'version', [], [], ['connect_timeout' => 2]);
  }

  public function reload()
  {
    return $this->request('GET', 'reload');
  }

  public function getListVhost()
  {
    return $this->request('GET', 'listvhost');
  }

  public function addIp($fwip, $gatewayip, $vlan)
  {
    $body = [
      'fwip' => $fwip,
      'gatewayip' => $gatewayip,
      'vlan' => $vlan
    ];
    return $this->request('POST', 'addip', $body);
  }

  public function createVhost($fwIP, $beIP, array $vhost, $sslMode = 'none', $customSSL = 'none', $cert = 'none', $key = 'none', $forceSSL = 'none')
  {
    $body = [
      'fwIP' => $fwIP,
      'beIP' => $beIP,
      'vhost' => $vhost,
      'sslMode' => $sslMode,
      'customSSL' => $customSSL,
      'cert' => $cert,
      'key' => $key,
      'enable' => true,
      'forceSSL' => $forceSSL
    ];
    return $this->request('POST', 'createvhost', $body);
  }

  public function updateVhost($fwIP, $beIP, array $vhost, $sslMode, array $fields)
  {
    $body = [
      'fwIP' => $fwIP,
      'beIP' => $beIP,
      'vhost' => $vhost,
      'sslMode' => $sslMode
    ];

    if ($fields) {
      foreach ($fields as $key => $value) {
        $body[$key] = $value;
      }
    }

    return $this->request('POST', 'editvhost', $body);
  }

  public function deleteVhost($vhost)
  {
    return $this->request('DELETE', 'deletevhost/' . $vhost);
  }

  public function suspendFW()
  {
    return $this->request('GET', 'suspend');
  }

  public function unsuspendFW()
  {
    return $this->request('GET', 'unsuspend');
  }

  public function listIpFW()
  {
    return $this->request('GET', 'connections/ip');
  }

  public function totalConnection()
  {
    return $this->request('GET', 'connections');
  }

  public function getConnectClientToFW($clientIP)
  {
    return $this->request('GET', 'connections/ipsrc/' . $clientIP);
  }

  public function getTopConnectToFW($fwIP)
  {
    return $this->request('GET', 'connections/topconns/' . $fwIP);
  }

  public function enableVhost($vhost)
  {
    return $this->request('POST', 'enablevhost/' . $vhost);
  }

  public function disableVhost($vhost)
  {
    return $this->request('POST', 'disablevhost/' . $vhost);
  }

  // ----------------------------------------------------------------
  // Data transfer
  // ----------------------------------------------------------------
  public function getDataTranferETCD($key)
  {
    return $this->request('GET', 'etcd/get/' . $key);
  }

  public function setDataTranferETCD($key, $value)
  {
    return $this->request('POST', 'etcd/set/' . $key . '/' . $value);
  }

  public function delDataTranferETCD($key)
  {
    return $this->request('DELETE', 'etcd/delete/' . $key);
  }
}
