<?php
class API
{
  const endpoint = "103.200.20.121:8080/v1/api/waf/";

  public function __construct()
  {
  }

  public function del_domain($domain)
  {
    try {
      $action = 'deletevhost';

      $curl = curl_init();
      curl_setopt_array($curl, array(
        CURLOPT_URL => self::endpoint . $action . '/' . $domain,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_ENCODING => '',
        CURLOPT_MAXREDIRS => 10,
        CURLOPT_TIMEOUT => 0,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        CURLOPT_CUSTOMREQUEST => 'DELETE'
      ));

      $response = curl_exec($curl);

      if (curl_error($curl)) {
        return [
          'success' => false,
          'errors' => true,
          'message' => curl_error($curl)
        ];
      }
      curl_close($curl);

      $result = json_decode($response, true);
      return $result;
    } catch (\Throwable $e) {
      logModuleCall(
        'vietnix_firewall2',
        __FUNCTION__,
        [],
        $e->getMessage(),
        $e->getTraceAsString()
      );
    }
    return 'success';
  }
  public function add_domain($domain, $fwip, $backend, $sslredirect, $sslmode)
  {
    try {
      $action = 'createvhost';
      $postfields = [
        'fwip' => $fwip,
        'originServer' => $backend,
        'vhost' => [
          $domain
        ]
      ];

      $curl = curl_init();
      curl_setopt_array($curl, array(
        CURLOPT_URL => self::endpoint . $action,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_ENCODING => '',
        CURLOPT_MAXREDIRS => 10,
        CURLOPT_TIMEOUT => 0,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        CURLOPT_CUSTOMREQUEST => 'POST',
        CURLOPT_POSTFIELDS => json_encode($postfields)
      ));

      $response = curl_exec($curl);

      if (curl_error($curl)) {
        return [
          'success' => false,
          'errors' => true,
          'message' => curl_error($curl)
        ];
      }
      curl_close($curl);

      $result = json_decode($response, true);
      return $result;
    } catch (\Throwable $e) {
      logModuleCall(
        'vietnix_firewall2',
        __FUNCTION__,
        [],
        $e->getMessage(),
        $e->getTraceAsString()
      );
    }
    return 'success';
  }

  public function get_listvhost()
  {
    try {
      $action = 'listvhost';
      $curl = curl_init();

      curl_setopt_array($curl, array(
        CURLOPT_URL => self::endpoint . $action,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_ENCODING => '',
        CURLOPT_MAXREDIRS => 10,
        CURLOPT_TIMEOUT => 0,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        CURLOPT_CUSTOMREQUEST => 'GET',
      ));

      $response = curl_exec($curl);
      if (curl_error($curl)) {
        return [
          'success' => false,
          'errors' => true,
          'message' => curl_error($curl)
        ];
      }
      curl_close($curl);

      $result = json_decode($response, true);
      return $result;
    } catch (\Throwable $e) {
      logModuleCall(
        'vietnix_firewall2',
        __FUNCTION__,
        [],
        $e->getMessage(),
        $e->getTraceAsString()
      );

      return '';
    }
  }
  public function reload_fw()
  {
    try {
      $action = 'reload';
      $curl = curl_init();

      curl_setopt_array($curl, array(
        CURLOPT_URL => self::endpoint . $action,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_ENCODING => '',
        CURLOPT_MAXREDIRS => 10,
        CURLOPT_TIMEOUT => 0,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        CURLOPT_CUSTOMREQUEST => 'GET',
      ));

      $response = curl_exec($curl);
      if (curl_error($curl)) {
        return [
          'success' => false,
          'errors' => true,
          'message' => curl_error($curl)
        ];
      }
      curl_close($curl);

      return [
        'success' => true,
        'errors' => null,
        'result' => $response
      ];
    } catch (\Throwable $e) {
      logModuleCall(
        'vietnix_firewall2',
        __FUNCTION__,
        [],
        $e->getMessage(),
        $e->getTraceAsString()
      );

      return '';
    }
  }

  public function get_version()
  {
    try {
      $action = 'version';
      $curl = curl_init();

      curl_setopt_array($curl, array(
        CURLOPT_URL => self::endpoint . $action,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_ENCODING => '',
        CURLOPT_MAXREDIRS => 10,
        CURLOPT_TIMEOUT => 0,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        CURLOPT_CUSTOMREQUEST => 'GET',
      ));

      $response = curl_exec($curl);
      if (curl_error($curl)) {
        return [
          'success' => false,
          'errors' => true,
          'message' => curl_error($curl)
        ];
      }
      curl_close($curl);

      return [
        'success' => true,
        'errors' => null,
        'result' => $response
      ];
    } catch (\Throwable $e) {
      logModuleCall(
        'vietnix_firewall2',
        __FUNCTION__,
        [],
        $e->getMessage(),
        $e->getTraceAsString()
      );

      return '';
    }
  }
}
