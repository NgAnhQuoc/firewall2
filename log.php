<?php
if (file_exists(__DIR__ . '/class/logger.php')) {
  require_once __DIR__ . '/class/logger.php';
}

use WHMCS\Database\Capsule;
use Logger;

function setErrorLog($exception)
{
  try {
    if (!isEnableLog()) {
      return;
    }
    $log = new Logger(__DIR__ . "/Logs/error.txt");
    $log->setTimestamp("Y/m/d H:i:s");

    $msg = '';
    if ($exception instanceof Exception) {
      $msg = json_encode([$exception->getMessage(), $exception->getTraceAsString()]);
    } elseif (is_array($exception)) {
      $msg = json_encode($exception);
    } else {
      $msg = $exception;
    }

    $log->putLog($msg);
  } catch (Exception $e) {
  }
}

function setActivityLog($action, $request, $response)
{
  try {
    if (!isEnableLog()) {
      return;
    }
    $log = new Logger(__DIR__ . "/Logs/activity.txt");
    $log->setTimestamp("Y/m/d H:i:s");
    $log->putLog(json_encode([
      "action" => $action,
      "request" => $request,
      "response" => $response
    ]));
  } catch (Exception $e) {
  }
}

function isEnableLog()
{
  try {
    $enableLog = Capsule::table('tbladdonmodules')->where('module', 'vietnix_firewall_2')->where('setting', 'enable_log')->first();
    if ($enableLog->value == 'on') {
      return true;
    }
  } catch (Exception $e) {
  }

  return false;
}
