<?php

namespace VnxFirewall\AdminUI;



class AdminArea
{
  public static function outputAdminServiceTabFields($smarty = null)
  {
    $outputFields = array();

    $vm_info = $smarty->getTemplateVars('vm_info');

    function printFirewallStatus($status = "ON")
    {
      return '<span style="color: ' . ($status == "ON" ? 'green' : 'red') . '; font-weight: bold; font-size: 20px; margin-left: 10px;">' . $status . '</span>';
    }

    $powerState = $vm_info->summary->runtime->powerState;

    if ($powerState == 'poweredOn') {
      $outputFields['Firewall Status'] = printFirewallStatus();
    } elseif ($powerState == 'poweredOff') {
      $outputFields['Firewall Status'] = printFirewallStatus('OFF');
    }

    $numCpu = $vm_info->summary->config->numCpu;
    $overallCpuUsage = $vm_info->summary->quickStats->overallCpuUsage;

    if ($overallCpuUsage && $numCpu) {
      $outputFields['CPU'] = '<span style="font-weight: bold; font-size: 14px; margin-left: 10px;">' . $numCpu . ' CPU(s), ' . $overallCpuUsage . ' MHz used</span>';
    }

    if ($vm_info->summary->runtime->powerState != 'poweredOn') {
      return $outputFields;
    }

    $domain_manager = $smarty->fetch(dirname(__FILE__) . '/Templates/DomainManager/domain_manager.tpl');

    $view_graph = $smarty->fetch(dirname(__FILE__) . '/Templates/Graph/view_graph.tpl');

    $view_logs = $smarty->fetch(dirname(__FILE__) . '/Templates/Logs/view_logs.tpl');

    $outputFields[''] = $domain_manager . $view_graph . $view_logs;

    return $outputFields;
  }
}
