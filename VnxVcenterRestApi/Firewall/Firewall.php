<?php

namespace VnxVcenterRestApi\Endpoints\Vcenter;

trait Firewall
{
  public function guestIndentity($name)
  {
    return $this->request('GET', 'vm/' . $name . '/guest/identity', []);
  }

  public function listGuestProcess($vm_id, $password)
  {
    $form_params = [
      "action" => "list"
    ];

    $body = [
      'credentials' => [
        "interactive_session" => false,
        "password" => $password,
        "type" => "USERNAME_PASSWORD",
        "user_name" => "root"
      ]
    ];

    return $this->request('POST', 'vm/' . $vm_id . '/guest/processes', $body, $form_params);
  }

  public function mapIp($vm_id, $password, $ip, $gateway, $netmask, $vlan, $username = 'root')
  {
    $form_params = [
      "action" => "create"
    ];

    $body = [
      'credentials' => [
        "type" => "USERNAME_PASSWORD",
        "interactive_session" => false,
        "password" => $password,
        "user_name" => $username
      ],
      'spec' => [
        "arguments" => "/root/scripts/init_ip_proxy.sh {$ip}/{$netmask} {$gateway} {$vlan}",
        "path" => "/bin/bash",
        "working_directory" => "/root/scripts"
      ]
    ];

    return $this->request('POST', 'vm/' . $vm_id . '/guest/processes', $body, $form_params);
  }

  public function changePassword($vm_id, $current_password, $new_password, $username = 'root')
  {
    $form_params = [
      "action" => "create"
    ];

    $body = [
      'credentials' => [
        'interactive_session' => false,
        'password' => $current_password,
        "type" => "USERNAME_PASSWORD",
        "user_name" => $username
      ],
      'spec' => [
        "arguments" => "-e '{$new_password}\n{$new_password}' | passwd root",
        "path" => "/usr/bin/echo",
        "working_directory" => "/root/scripts"
      ]
    ];

    return $this->request('POST', 'vm/' . $vm_id . '/guest/processes', $body, $form_params);
  }

  public function initImage($vm_id, $ip, $hostname, $password, $username = 'root')
  {
    $form_params = [
      "action" => "create"
    ];

    $body = [
      'credentials' => [
        "interactive_session" => false,
        "password" => $password,
        "type" => "USERNAME_PASSWORD",
        "user_name" => $username
      ],
      'spec' => [
        "arguments" => "/root/scripts/init_image_api.sh &",
        "path" => "/bin/bash",
        "working_directory" => "/root/scripts"
      ]
    ];

    return $this->request('POST', 'vm/' . $vm_id . '/guest/processes', $body, $form_params);
  }

  public function updateImage($vm_id, $ip, $hostname, $password, $username = 'root')
  {
    $form_params = [
      "action" => "create"
    ];

    $body = [
      'credentials' => [
        "interactive_session" => false,
        "password" => $password,
        "type" => "USERNAME_PASSWORD",
        "user_name" => $username
      ],
      'spec' => [
        "arguments" => "/etc/scripts/update_image_api.sh >/var/log/update_debug.log 2>&1",
        "path" => "/bin/bash",
        "working_directory" => "/root/scripts"
      ]
    ];

    return $this->request('POST', 'vm/' . $vm_id . '/guest/processes', $body, $form_params);
  }

  public function deleteScript($vm_id, $password, $username = 'root')
  {
    $form_params = [
      "action" => "create"
    ];

    $body = [
      'credentials' => [
        "interactive_session" => false,
        "password" => $password,
        "type" => "USERNAME_PASSWORD",
        "user_name" => $username
      ],
      'spec' => [
        "arguments" => "-rf init_*",
        "path" => "/usr/bin/rm",
        "working_directory" => "/root/scripts"
      ]
    ];

    return $this->request('POST', 'vm/' . $vm_id . '/guest/processes', $body, $form_params);
  }

  public function getGuestProcess($vm_id, $pid, $password, $username = 'root')
  {
    $form_params = [
      "action" => "get"
    ];

    $body = [
      'credentials' => [
        "type" => "USERNAME_PASSWORD",
        "interactive_session" => false,
        "password" => $password,
        "user_name" => $username
      ]
    ];

    return $this->request('POST', 'vm/' . $vm_id . '/guest/processes/' . $pid, $body, $form_params);
  }

  public function powerDetail($vm_id)
  {
    $result = $this->request('GET', 'vm/' . $vm_id . '/power', []);

    return $result['state'] ?? null;
  }

  public function powerOn($vm_id)
  {
    $form_params = [
      "action" => "start"
    ];

    $body = [];

    $status = $this->powerDetail($vm_id);

    if ($status && $status != 'POWERED_ON') {
      $this->request('POST', 'vm/' . $vm_id . '/power', $body, $form_params);
    }

    return $this->powerDetail($vm_id) == 'POWERED_ON';
  }

  public function powerOff($vm_id)
  {
    $form_params = [
      "action" => "stop"
    ];

    $body = [];

    $status = $this->powerDetail($vm_id);

    if ($status && $status != 'POWERED_OFF') {
      $this->request('POST', 'vm/' . $vm_id . '/power', $body, $form_params);
    }

    return $this->powerDetail($vm_id) == 'POWERED_OFF';
  }

  public function deleteFirewall($vm_id)
  {
    return $this->request('DELETE', 'vm/' . $vm_id, []);
  }
}
