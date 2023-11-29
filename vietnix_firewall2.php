<?php
//----------------------------------------------------------------
// IMPORT --
//----------------------------------------------------------------
if (!defined("WHMCS")) {
	die("This file cannot be accessed directly");
}
if (file_exists(__DIR__ . '/class/helper.class.php')) {
	require_once __DIR__ . '/class/helper.class.php';
}
if (file_exists(__DIR__ . '/vmclass.php')) {
	require_once __DIR__ . '/vmclass.php';
}
if (file_exists(__DIR__ . '/manage_cfields.php')) {
	require_once __DIR__ . '/manage_cfields.php';
}
if (file_exists(__DIR__ . '/VnxVcenterRestApi/FirewallApi.php')) {
	require_once __DIR__ . '/VnxVcenterRestApi/FirewallApi.php';
}
if (file_exists(__DIR__ . '/VnxTechAPI/GoAPI.php')) {
	require_once __DIR__ . '/VnxTechAPI/GoAPI.php';
}
if (file_exists(__DIR__ . '/VnxTechAPI/NetbotApi.php')) {
	require_once __DIR__ . '/VnxTechAPI/NetbotApi.php';
}
if (file_exists(__DIR__ . '/VnxLogcenterAPI/GraphAPI.php')) {
	require_once __DIR__ . '/VnxLogcenterAPI/GraphAPI.php';
}
if (file_exists(__DIR__ . '/UI/Admin/adminarea.php')) {
	require_once __DIR__ . '/UI/Admin/adminarea.php';
}
if (file_exists(__DIR__ . '/log.php')) {
	require_once __DIR__ . '/log.php';
}

//----------------------------------------------------------------
// LIBRARY --
//----------------------------------------------------------------
use WHMCS\Database\Capsule;
use Helper;
use VnxVcenterRestApi\FirewallApi;
use VnxTechAPI\GoAPI;
use VnxTechAPI\NetbotApi;
use VnxLogcenterAPI\GraphAPI;
use VnxFirewall\AdminUI\AdminArea;

//----------------------------------------------------------------
// CORE FUNCTION --
//----------------------------------------------------------------
function vietnix_firewall2_MetaData()
{
	return array(
		'DisplayName' => 'Vietnix Firewall Web',
	);
}

function vietnix_firewall2_ConfigOptions()
{
	return 'success';
}

function vietnix_firewall2_AdminCustomButtonArray()
{
	$buttonarray = array(
		"Power Off" => "power_off",
		"Power On" => "power_on",
		"Update" => "update_image",
		// "Reset OS" => "reloados",
	);
	return $buttonarray;
}

function vietnix_firewall2_ClientAreaCustomButtonArray()
{
	$buttonarray['Cấu hình tên miền'] = 'config_domain';
	$buttonarray['Xem Logs chi tiết'] = 'view_logs';
	$buttonarray['Xem Graph chi tiết'] = 'view_graph';
	return $buttonarray;
}

function vietnix_firewall2_ClientArea($params)
{
	try {
		if (isset($_POST['cmd']) && ($_POST['cmd'] == 'check_block_ip') && isset($_POST['ipfw'])) {
			$res = vietnix_getBlockIpStatus($_POST['ipfw']);
			echo json_encode($res);
			exit;
		} elseif (isset($_POST['cmd']) && ($_POST['cmd'] == 'set_block_ip') && isset($_POST['ipfw'])) {
			$res = vietnix_setBlockIpStatus($_POST['ipfw']);
			echo json_encode($res);
			exit;
		} elseif (isset($_POST['cmd']) && ($_POST['cmd'] == 'set_unblock_ip') && isset($_POST['ipfw'])) {
			$res = vietnix_setUnblockIpStatus($_POST['ipfw']);
			echo json_encode($res);
			exit;
		} else {
			$templateFile = '/UI/Client/templates/overview.tpl';
			return array(
				'tabOverviewReplacementTemplate' => $templateFile,
			);
		}
	} catch (Exception $e) {
		// Record the error in filelog module.
		setErrorLog($e);
		return false;
	}
}

function vietnix_firewall2_CreateAccount($params)
{
	$VnxVmwareObj = new VnxVmware();
	$VnxVmwareObj->vmware_includes_files($params);
	$vms = getVcenterServerInfo();

	try {
		$vm_info = $vms->get_vm_guest($params['domain']);
		if ($vm_info) {
			return 'Error: "' . $params['domain'] . '" already exist!';
		}
	} catch (\Throwable $th) {
		return 'Error: ' . $th->getMessage();
	}

	// Param to clone VM
	$sid = $params['serviceid'];
	$domain = $params['domain'];
	$clone = true;

	/**
	 * BEGIN tạo cron job create VM
	 */
	$cron = Capsule::table("mod_vnxfw2_cron_vm")->where('sid', $params['serviceid'])->count();
	if ($cron == 0) {
		Capsule::table("mod_vnxfw2_cron_vm")->insert(['sid' => $params['serviceid'], 'status' => '0']);
		$vms->storeVmwareLogs($sid, $params['domain'], "VM creation request accepted. Waiting for cron run to complete it.", "Success");

		return 'success';
	}


	/**
	 * END tạo cron job create VM
	 */

	//------------------------------------------------------------------------------------------------
	/************************
	 * Begin mapping dedicatedIp with vlan from ip manager
	 */
	try {
		$dedicatedip = $params['model']['dedicatedip'];

		if (empty($dedicatedip)) {
			return $vms->deleteCreateVmCron($sid, "Error: dedicatedip invalid");
		}

		$get_ip_info = Capsule::select('select ip.id id, ip.ip ip, pool.mask netmask, pool.gateway gateway, pool.ns1 dns1, pool.ns2 dns2, customfield.value vlan from ip_manager_ips ip, ip_manager_ip_pools pool, ip_manager_customfields customfield where ip.pool_id = pool.id and pool.id = customfield.rel_id and ip.ip ="' . $dedicatedip . '";');

		if (empty($get_ip_info)) {
			return $vms->deleteCreateVmCron($sid, "{$dedicatedip} mapping vlan failed!");
		}

		$vlan = $get_ip_info[0]->vlan;

		$networkIp = $dedicatedip;

		$prefix = $get_ip_info[0]->netmask;
		$netmask = $vms->ipv4cidr2subnet($prefix);

		$gateway = $get_ip_info[0]->gateway;

		$dns = !empty($get_ip_info[0]->dns1) ? $get_ip_info[0]->dns1 : '';
	} catch (\Throwable $th) {
		$vms->storeVmwareLogs($sid, '', "{$dedicatedip} get vlan failed: {$th->getMessage()}", "Failed");
	}

	if (empty($vlan)) {
		return $vms->deleteCreateVmCron($sid, "{$dedicatedip} get vlan failed!");
	}
	/************************
	 * END Random select host with valid resource and vlan
	 */

	$defaultDatacenter = 'VDC-Web-Firewall';
	$defaultHost = 'webfirewall1.vietnix.vn';
	$randomHostValidResource = $vms->getHostWithValidResource($vlan, $defaultDatacenter, $defaultHost);

	if (empty($randomHostValidResource)) {
		return $vms->deleteCreateVmCron($sid, "{$dedicatedip} get host with valid resource failed!");
	}

	$datacenter_obj = $randomHostValidResource['datacenterId'];
	$dataceter_name = $randomHostValidResource['datacenterName'];
	$hostsystem_name = $randomHostValidResource['hostName'];
	$datastore_id = $randomHostValidResource['datastoreId'];

	$newVmname = $domain . '-' . $sid;

	try {
		$updateArr = [
			'domain' => $newVmname,
			'dedicatedip' => $networkIp,
			'username' => "root",
		];
		Capsule::table('tblhosting')
			->where('id', $sid)
			->update($updateArr);
	} catch (Exception $e) {
		setErrorLog($e);
	}

	$info = $vms->get_vm_info($newVmname);
	$vmslist = $VnxVmwareObj->vmware_object_to_array($info);
	if (!empty($vmslist)) {
		return 'Error: Vmname "' . $newVmname . '" already exist!';
	}

	if ($clone) {
		$cloneVmName = "TEMPLATE_UBUNTU_WEB_FW_LATEST";
		$passw_template = "jPVE2AJ152EBWt3";
		$cloneVmPassword = $params['password'];

		/**
		 * Thêm đoạn này check template có tồn tại không
		 */
		$info = $vms->get_vm_info($cloneVmName);
		$cloneVminfo = $VnxVmwareObj->vmware_object_to_array($info);
		if (!$cloneVminfo) {
			return $vms->deleteCreateVmCron($sid, 'Error: Existing Vm or VM template "' . $cloneVmName . '" Not found.');
		}
		// End check ---

		$template_conf = [];
		foreach ($cloneVminfo['RetrievePropertiesResponse']['returnval'] as $template) {
			if ($template["propSet"][0]['val'] == $cloneVmName) {
				$template_conf = $template["propSet"][1]["val"]["config"];
				continue;
			}
		}

		$cloneArr = [
			'templatename' => $cloneVmName,
			'existingpw' => $cloneVmPassword,
			'newVmname' => $newVmname,
			'networkIp' => $networkIp,
			'netmask' => $netmask,
			'gateway' => $gateway,
			'dns' => $dns,
			'hostsystem_name' => $hostsystem_name,
			'datastore_id' => $datastore_id,
			'memoryMB' => $template_conf["memorySizeMB"],
			'numCPUS' => $template_conf["numCpu"],
			'datacenter' => $randomHostValidResource['datacenterName'],
			'dcobj' => $datacenter_obj
		];

		try {
			$rsclone = $vms->cloneLinuxVm($cloneArr, $params);
			if ($rsclone == 'success') {
				// Kick start script
				$info = $vms->get_vm_info($newVmname);
				$vm_id = $info->reference->_;
				$vcenter = new FirewallApi(5);
				$vcenter->changePassword($vm_id, $passw_template, $cloneVmPassword);
				$vcenter->mapIp($vm_id, $cloneVmPassword, $dedicatedip, $gateway, $prefix, $vlan, 'root');
				// $vcenter->initImage($vm_id, $dedicatedip, $newVmname, $cloneVmPassword, 'root');
				$vcenter->updateImage($vm_id, $dedicatedip, $newVmname, $cloneVmPassword, 'root');
				$vcenter->deleteScript($vm_id, $cloneVmPassword, 'root');

				// Update goapi lastest
				//$vcenter->updateImage($vm_id, $dedicatedip, $newVmname, $cloneVmPassword, 'root');
			}

			if (Capsule::table("mod_vnxfw2_hosts_vms")->where('sid', $params['serviceid'])->count() > 0) {
				Capsule::table("mod_vnxfw2_hosts_vms")->where('sid', $params['serviceid'])->update(['hostid' => $randomHostValidResource['hostId'], 'vmname' => $newVmname]);
			} else {
				Capsule::table("mod_vnxfw2_hosts_vms")->insert(['sid' => $params['serviceid'], 'hostid' => $randomHostValidResource['hostId'], 'vmname' => $newVmname]);
			}
		} catch (Exception $ex) {
			$rsclone = $ex->getMessage();
		}
	}

	if ($rsclone == "success") {
		Capsule::table("mod_vnxfw2_cron_vm")->where('sid', $sid)->update(['status' => '1']);
		$description = "VM Succefully Created. <a href=\"clientsservices.php?id={$sid}\" target='_blank'>Service ID: {$sid}</a>";
		$status = "Success";
	}

	if ($rsclone != "success") {
		$description = "VM Creation Failed. <a href=\"clientsservices.php?id={$sid}\" target='_blank'>Service ID: {$sid}</a>, Error: {$rsclone}";
		$status = "Failed";
		try {
			if ($params['domain'] == "") {
				$updateArr = [
					'domain' => $networkIp,
					'dedicatedip' => $networkIp,
				];
			} else {
				$updateArr = [
					'dedicatedip' => $networkIp,
				];
			}

			Capsule::table('tblhosting')
				->where('id', $params['serviceid'])
				->update($updateArr);
		} catch (Exception $e) {
			setErrorLog($e);
		}
	}

	$vms->storeVmwareLogs($sid, $newVmname, $description, $status);

	return $rsclone;
}

function vietnix_firewall2_SuspendAccount($params)
{
	$dedicatedip = $params['model']['dedicatedip'];

	try {
		$goapi = new GoAPI($dedicatedip);

		$result = $goapi->suspendFW();

		setActivityLog("Suspend", array('name' => $params['domain']), $result);

		if ($result['success'] == true) {
			return 'success';
		}

		return 'error';
	} catch (\Exception $e) {
		return $e->getMessage();
	}
}

function vietnix_firewall2_UnsuspendAccount($params)
{
	$dedicatedip = $params['model']['dedicatedip'];

	try {
		$goapi = new GoAPI($dedicatedip);

		$result = $goapi->unsuspendFW();
		setActivityLog("Unsuspend", array('name' => $params['domain']), $result);

		if ($result['success'] == true) {
			return 'success';
		}
		return 'error';
	} catch (\Exception $e) {
		return $e->getMessage();
	}
}

function vietnix_firewall2_TerminateAccount($params)
{
	try {
		$vm_name = $params['domain'];

		/************************
		 * Begin Include Vmware Class
		 **/
		$VnxVmwareObj = new VnxVmware();
		$VnxVmwareObj->vmware_includes_files($params);
		$vms = getVcenterServerInfo();

		/************************
		 * Begin Get VM ID
		 **/
		$info = $vms->get_vm_info($vm_name);
		$vm_id = $info->reference->_;

		/************************
		 * Begin Delete VM
		 **/
		$firewall = new FirewallApi(5);

		$isPowerOff = $firewall->powerOff($vm_id);
		setActivityLog("Terminate", array('name' => $params['domain']), [$isPowerOff]);

		if ($isPowerOff) {
			$firewall->deleteFirewall($vm_id);
			Capsule::table("mod_vnxfw2_cron_vm")->where('sid', $params['serviceid'])->delete();

			// Remove ServiceID to domain
			$lastSeparatorPosition = strrpos($params['domain'], '-');
			$domain = substr($params['domain'], 0, $lastSeparatorPosition);
			$updateArr = [
				'domain' => $domain,
			];
			Capsule::table('tblhosting')
				->where('id', $params['serviceid'])
				->update($updateArr);

			return 'success';
		}
		return 'error';
	} catch (Exception $e) {
		setErrorLog($e);
		return $e->getMessage();
	}
}

function vietnix_firewall2_AdminServicesTabFields($params)
{
	try {
		$VnxVmwareObj = new VnxVmware();
		$VnxVmwareObj->vmware_includes_files();

		$vm_name = $params['domain'];
		$dedicatedip = $params['model']['dedicatedip'];

		$vms = getVcenterServerInfo();
		$vm_info = $vms->get_vm_info($vm_name);


		if (!$dedicatedip || $params['status'] != 'Active') {
			return [];
		}

		$listvhost = [];

		if ($vm_info->summary->runtime->powerState == 'poweredOn') {
			$res_lvhost = getListVhostsByFwID($dedicatedip);
			$listvhost = $res_lvhost ?? [];
		}

		// return $fieldsarray;
		$smarty = new Smarty();

		$smarty->assign('params', $params);

		$smarty->assign('listvhost', $listvhost);

		$smarty->assign('vm_info', $vm_info);

		$smarty->caching = false;

		return  AdminArea::outputAdminServiceTabFields($smarty);
	} catch (Exception $e) {
		setErrorLog($e);
		return $e->getMessage();
	}
}

function vietnix_firewall2_AdminServicesTabFieldsSave($params)
{
}

function vietnix_firewall2_ChangePassword($params)
{
	try {
		$vm_name = $params['domain'];
		$newPassword = $params['password'];

		/************************
		 * Begin Include Vmware Class
		 **/

		$VnxVmwareObj = new VnxVmware();
		$VnxVmwareObj->vmware_includes_files($params);
		$vms = getVcenterServerInfo();

		/************************
		 * Begin Get VM ID
		 **/
		$info = $vms->get_vm_info($vm_name);
		$vm_id = $info->reference->_;


		$currentPassword = getFirewallPassword($params);

		if (!$currentPassword) {
			return 'Failed to get current password';
		}

		$vcenter = new FirewallApi(5);

		$isPasswordChanged = null;

		try {
			$isPasswordChanged =	$vcenter->changePassword($vm_id, $currentPassword, $newPassword) ?? null;
		} catch (Exception $e) {
			setErrorLog($e);
			return $e->getMessage();
		}

		setActivityLog("Change Password", array('name' => $params['domain']), [$isPasswordChanged]);

		if ($isPasswordChanged) {
			updateFirewallPassword($currentPassword, $newPassword, $params);
			return 'success';
		}
		return 'Change password failed';
	} catch (Exception $e) {
		// Record the error in filelog module.
		setErrorLog($e);

		return $e->getMessage();
	}
}


//---------------------
// CUSTOM FUNCTION -----------------------------------------------
//---------------------
function vietnix_firewall2_add_domain($goapi, $fwip, $backend, $domain, $sslmode, array $ssldata)
{
	try {
		if ($sslmode != "none") {
			$rs = $goapi->createVhost($fwip, $backend, [$domain], $sslmode, $ssldata['customssl'], $ssldata['cert'], $ssldata['key'], $ssldata['forcessl']);
		} else {
			$rs = $goapi->createVhost($fwip, $backend, [$domain]);
		}
	} catch (Exception $e) {
		setErrorLog($e);
	}

	setActivityLog("Add domain", [$fwip, $backend, $domain, $sslmode], $rs);
	return $rs;
}

function vietnix_firewall2_update_domain($goapi, $fwip, $backend, $domain, $sslmode, array $ssldata)
{
	try {
		$fields = array();
		$list_vhost = getListVhostsByFwID($fwip);
		$keyFilter = 'vhost';
		$filtered = array_filter($list_vhost, function ($vhost) use ($keyFilter, $domain) {
			return $vhost[$keyFilter] === $domain;
		});
		$vhostfill = array_shift($filtered);

		if ($sslmode != $vhostfill['sslMode']) {
			$fields['sslMode'] = $sslmode;
		} else {
			$fields['sslMode'] = $vhostfill['sslMode'];
		}

		if ($sslmode != 'none') {
			$fields['customSSL'] = $ssldata['customssl'];
			$fields['forceSSL'] = $ssldata['forcessl'];
			if ($ssldata['customssl'] == 'yes') {
				$fields['cert'] = $ssldata['cert'];
				$fields['key'] = $ssldata['key'];
			}
		}

		$rs = $goapi->updateVhost($fwip, $backend, [$domain], $sslmode, $fields);
	} catch (Exception $e) {
		// Record the error in filelog module.
		setErrorLog($e);
	}

	setActivityLog("Update domain", [$fwip, $backend, $domain, $sslmode], $rs);
	return $rs;
}

function vietnix_firewall2_config_domain(array $params)
{
	$rs = null;
	try {
		$helper = new Helper();
		$service = $helper->get_service_by_id($params['serviceid']);

		// Parameter post
		$goapi = new GoAPI($service['dedicatedip']);
		$fwip = $service['dedicatedip'];
		$domain = isset($_POST['domain']) ? trim($_POST['domain']) : null;
		$backend = $_POST['backend'] ? trim($_POST['backend']) : "";
		$sslmode = $_POST['sslmode'] ? $_POST['sslmode'] : "none";
		$forcessl = $_POST['forcessl'] == 'true' ? "yes" : "no";
		$customssl = $_POST['customssl'] == 'upload' ? 'yes' : "no";
		$cert = $_POST['cert'] ? $_POST['cert'] : false;
		$key = $_POST['key'] ? $_POST['key'] : false;
		$ca = $_POST['ca'] ? $_POST['ca'] : false;

		// Validate SSL 
		if ($cert) {
			$cert = validateCertificateCode($cert);
		}
		if ($ca) {
			$ca = validateCertificateCode($ca);
		}
		if ($key) {
			$key = validateCertificateCode($key, true);
		}

		// Set SSL Data
		$sslcert =  ($cert && $ca) ? base64_encode(implode("\n", [$cert, $ca])) : ($cert ? base64_encode($cert) : 'no');
		$sslkey = $key ? base64_encode($key) : 'no';
		$ssldata = [
			'customssl' => $customssl,
			'cert' => $sslcert,
			'key' => $sslkey,
			'forcessl' => $forcessl
		];

		if ($_POST['cmd'] == 'add_domain') {
			$rs = vietnix_firewall2_add_domain($goapi, $fwip, $backend, $domain, $sslmode, $ssldata);
		} else if ($_POST['cmd'] == 'update_domain') {
			$rs = vietnix_firewall2_update_domain($goapi, $fwip, $backend, $domain, $sslmode, $ssldata);
		} else if ($_POST['cmd'] == 'delete_domain') {
			$rs = $goapi->deleteVhost($domain);
		} else if ($_POST['cmd'] == 'on_off_domain' && isset($_POST['status'])) {
			if ($_POST['status'] == 'turn_on') {
				$rs = $goapi->enableVhost($domain);
			} else if ($_POST['status'] == 'turn_off') {
				$rs = $goapi->disableVhost($domain);
			}
		} else {
			try {
				$goapi = new GoAPI($fwip);
				$getGoApi = $goapi->getVersion();

				if ($getGoApi) {
					$list_vhost = getListVhostsByFwID($service['dedicatedip']);
					$vars['listvhost'] = $list_vhost;
				}
			} catch (Exception $e) {
				$vars['listvhost'] = [];
				setErrorLog($e);
			}

			return array(
				'templatefile' => "/UI/Client/templates/config_domain",
				'vars' => $vars
			);
		}
	} catch (Exception $e) {
		// Record the error in filelog module.
		setErrorLog($e);
		$rs = $e->getMessage();
	}
	echo json_encode($rs);
	exit;
}

function vietnix_firewall2_admin_config_domain($params)
{
	$rs = null;
	try {
		$helper = new Helper();
		$service = $helper->get_service_by_id($params['serviceid']);

		// Parameter post
		$goapi = new GoAPI($service['dedicatedip']);
		$fwip = $service['dedicatedip'];
		$domain = isset($_POST['domain']) ? trim($_POST['domain']) : null;
		$backend = $_POST['backend'] ? trim($_POST['backend']) : "";
		$sslmode = $_POST['sslMode'] ? $_POST['sslMode'] : "none";
		$forcessl = $_POST['forceSSL'] == 'true' ? "yes" : "no";
		$customSSL = $_POST['customSSL'] == 'yes' ? 'yes' : "no";
		$cert = $_POST['cert'] ? $_POST['cert'] : false;
		$key = $_POST['key'] ? $_POST['key'] : false;
		$ca = $_POST['ca'] ? $_POST['ca'] : false;

		// Validate SSL 
		if ($cert) {
			$cert = validateCertificateCode($cert);
		}
		if ($ca) {
			$ca = validateCertificateCode($ca);
		}
		if ($key) {
			$key = validateCertificateCode($key, true);
		}

		// Set SSL Data
		$sslcert =  ($cert && $ca) ? base64_encode(implode("\n", [$cert, $ca])) : ($cert ? base64_encode($cert) : 'no');
		$sslkey = $key ? base64_encode($key) : 'no';
		$ssldata = [
			'customssl' => $customSSL,
			'cert' => $sslcert,
			'key' => $sslkey,
			'forcessl' => $forcessl
		];

		switch ($_POST['cmd']) {
			case 'add_domain':
				$rs = vietnix_firewall2_add_domain($goapi, $fwip, $backend, $domain, $sslmode, $ssldata);
				break;
			case 'update_domain':
				$rs = vietnix_firewall2_update_domain($goapi, $fwip, $backend, $domain, $sslmode, $ssldata);
				break;
			case 'delete_domain':
				$rs = $goapi->deleteVhost($domain);
				break;
			case 'refresh_domain':
				$rs['vhosts'] = getListVhostsByFwID($service['dedicatedip']);
				break;
			case 'on_off_domain':
				if (isset($_POST['status'])) {
					if ($_POST['status'] == 'turn_on') {
						$rs = $goapi->enableVhost($domain);
					} else if ($_POST['status'] == 'turn_off') {
						$rs = $goapi->disableVhost($domain);
					}
				}
				break;

			default:
				break;
		}
	} catch (Exception $e) {
		// Record the error in filelog module.
		setErrorLog($e);
	}

	return $rs;
}

function vietnix_firewall2_update_image($params)
{
	try {
		setActivityLog("Update image", array('name' => $params['domain']), []);

		$dedicatedip = $params['model']['dedicatedip'];

		$vm_name = $params['domain'];

		/************************
		 * Begin Include Vmware Class
		 **/

		$VnxVmwareObj = new VnxVmware();
		$VnxVmwareObj->vmware_includes_files($params);
		$vms = getVcenterServerInfo();

		/************************
		 * Begin Get VM ID
		 **/
		$info = $vms->get_vm_info($vm_name);
		$vm_id = $info->reference->_;

		$currentPassword = getFirewallPassword($params);

		if (!$currentPassword) {
			return 'Failed to get current password';
		}

		$vcenter = new FirewallApi();

		$result = $vcenter->updateImage($vm_id, $dedicatedip, $vm_name, $currentPassword);

		if (!empty($result)) {
			return 'success';
		}
	} catch (\Exception $e) {
		return $e->getMessage();
	}

	return "Error";
}

function vietnix_firewall2_get_data_graph()
{
	$datestart = $_POST['gte'];
	$dateend = $_POST['lte'];
	$domain = $_POST['domain'];
	$ipfw = $_POST['ipfw'];
	$cmd = $_POST['cmd'];
	$sid = $_POST['sid'];

	getDataLoggerInFW('graph', $cmd, $datestart, $dateend, $domain, $ipfw, $sid);
}

function vietnix_firewall2_get_data_logs()
{
	$datestart = $_POST['gte'];
	$dateend = $_POST['lte'];
	$domain = $_POST['domain'];
	$ipfw = $_POST['ipfw'];

	getDataLoggerInFW('logs', '', $datestart, $dateend, $domain, $ipfw);
}

function vietnix_firewall2_view_graph($params)
{
	try {
		if (isset($_POST['gte']) && isset($_POST['lte'])) {
			vietnix_firewall2_get_data_graph();
		} else {
			$helper = new Helper();
			$service = $helper->get_service_by_id($params['serviceid']);

			$list_vhost = getListVhostsByFwID($service['dedicatedip']);
			$vars['listvhost'] = $list_vhost;
			return array(
				'templatefile' => "UI/Client/templates/view_graph",
				'vars' => $vars
			);
		}
	} catch (Exception $e) {
		// Record the error in filelog module.
		setErrorLog($e);

		return $e->getMessage();
	}
}

function vietnix_firewall2_view_logs($params)
{
	try {
		if (isset($_POST['cmd']) && $_POST['cmd'] == 'get_logs') {
			vietnix_firewall2_get_data_logs();
		} else {
			$helper = new Helper();
			$service = $helper->get_service_by_id($params['serviceid']);

			$list_vhost = getListVhostsByFwID($service['dedicatedip']);
			$vars['listvhost'] = $list_vhost;
			return array(
				'templatefile' => "/UI/Client/templates/view_logs",
				'vars' => $vars
			);
		}
	} catch (Exception $e) {
		// Record the error in filelog module.
		setErrorLog($e);

		return $e->getMessage();
	}
}

function vietnix_firewall2_power_on($params)
{
	try {
		$vm_name = $params['domain'];
		$VnxVmwareObj = new VnxVmware();
		$VnxVmwareObj->vmware_includes_files($params);

		$vms = getVcenterServerInfo();
		if ($vms->get_vm_info($vm_name)->summary->runtime->powerState == 'poweredOn') {
			return $vm_name . " is already in powered On state";
		}

		$response_obj = $vms->vm_power_on($vm_name);

		setActivityLog("poweron vm", array('name' => $vm_name), $VnxVmwareObj->vmware_object_to_array($response_obj['obj']));

		if ($response_obj['state'] == 'success' || $response_obj['state'] == '') {
			$result = "success";
		} elseif ($response_obj['state'] == 'Vm not found') {
			$result = $response_obj['state'];
		} else {
			$result = $response_obj['state'];
		}
	} catch (Exception $e) {
		// Record the error in filelog module.
		setErrorLog($e);
		$result = $e->getMessage();
	}

	return $result;
}

function vietnix_firewall2_power_off($params)
{
	try {
		$vm_name = $params['domain'];
		$VnxVmwareObj = new VnxVmware();
		$VnxVmwareObj->vmware_includes_files($params);

		$vms = getVcenterServerInfo();

		if ($vms->get_vm_info($vm_name)->summary->runtime->powerState == 'poweredOff') {
			return $vm_name . " already in powered off state";
		}

		$response_obj = $vms->vm_power_off($vm_name);

		setActivityLog("poweroff vm", array('name' => $vm_name), $VnxVmwareObj->vmware_object_to_array($response_obj['obj']));

		if ($response_obj['state'] == 'success' || $response_obj['state'] == '') {
			$result = "success";
		} elseif ($response_obj['state'] == 'Vm not found') {
			$result = $response_obj['state'];
		} else {
			$result = $response_obj['state'];
		}
	} catch (Exception $e) {
		// Record the error in filelog module.
		setErrorLog($e);
		$result = $e->getMessage();
	}

	return $result;
}

function vietnix_getBlockIpStatus($fwip)
{
	try {
		/************************
		 * Begin Include Vmware Class
		 **/

		$netBotApi = new NetbotApi();

		$result = $netBotApi->checkIP($fwip);

		// setActivityLog("Block IP International Status", array('fwip' => $fwip), $result);

		if (!empty($result)) {
			return $result;
		}
	} catch (Exception $e) {
		setErrorLog($e);
		return $e->getMessage();
	}

	return "Error";
}

function vietnix_setBlockIpStatus($fwip)
{
	try {
		/************************
		 * Begin Include Vmware Class
		 **/

		$netBotApi = new NetbotApi();

		$result = $netBotApi->blockIP($fwip);

		setActivityLog("Set Block IP International", array('fwip' => $fwip), $result);

		if (!empty($result)) {
			return $result;
		}
	} catch (Exception $e) {
		setErrorLog($e);
		return $e->getMessage();
	}

	return "Error";
}

function vietnix_setUnblockIpStatus($fwip)
{
	try {
		/************************
		 * Begin Include Vmware Class
		 **/

		$netBotApi = new NetbotApi();

		$result = $netBotApi->unblockIP($fwip);

		setActivityLog("Set Unblock IP International", array('fwip' => $fwip), $result);

		if (!empty($result)) {
			return $result;
		}
	} catch (Exception $e) {
		setErrorLog($e);
		return $e->getMessage();
	}

	return "Error";
}

//------------------------------------------------------------------------------------------------
//-----------------
// SUPPORT FUNCTION
//-----------------
function formatBytes($bytes)
{
	if ($bytes > 0) {
		$i = floor(log($bytes) / log(1024));
		$sizes = array('B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB');
		return sprintf('%.02F', round($bytes / pow(1024, $i), 1)) * 1 . ' ' . @$sizes[$i];
	} else {
		return 0;
	}
}

function getVcenterServerInfo()
{
	try {
		$vms = new soapvmware();
		return $vms;
	} catch (Exception $e) {
		setErrorLog($e);
		return false;
	}
}

function updateFirewallPassword($cloneVmPassword, $newPassowd, $params)
{
	try {
		$serviceid = $params['serviceid'];
		$uid = $params['userid'];
		$serviceid = $params['serviceid'];
		$pid = $params['pid'];
		$ip = $params['model']['dedicatedip'];
		$vm_name = $params['domain'];

		$vnxObjToArray = new VnxObjToArray();

		$oldPw = $vnxObjToArray->VnxVmwarePwencryption($cloneVmPassword);

		$newPassword = $vnxObjToArray->VnxVmwarePwencryption($newPassowd);

		$insertData = [
			'vm_name' => $vm_name,
			'old_password' => $oldPw,
			'password' => $newPassword,
			'ip' => $ip,
			'uid' => $uid,
			'sid' => $serviceid,
			'pid' => $params['pid'],
			'status' => '0'
		];

		if (!empty($insertData)) {
			if (Capsule::table('mod_vnxfw2_pw_linux_vm')->where('sid', $serviceid)->where('uid', $uid)->where('pid', $pid)->count() == 0)
				Capsule::table('mod_vnxfw2_pw_linux_vm')->insert($insertData);
			else
				Capsule::table('mod_vnxfw2_pw_linux_vm')->where('sid', $serviceid)->where('uid', $uid)->where('pid', $pid)->update($insertData);
		}
	} catch (\Throwable $th) {
		//throw $th;
	}
}

function getFirewallPassword($params)
{
	try {
		$uid = $params['userid'];
		$serviceid = $params['serviceid'];
		$pid = $params['pid'];

		$vnxObjToArray = new VnxObjToArray();

		$query = Capsule::table('mod_vnxfw2_pw_linux_vm')->where('uid', (int) $uid)->where('sid', (int) $serviceid)->where('pid', $pid)->first();
		if ($query->password) {
			return $vnxObjToArray->VnxVmwarePwdecryption($query->password);
		}
	} catch (\Throwable $th) {
		//throw $th;
	}

	return false;
}

function getOldDataTranferETCD($key)
{
	$ipETCD = '14.225.204.41';
	$data = 0;
	$datestart = '';
	$goapi = new GoAPI($ipETCD);

	try {
		$res = $goapi->getDataTranferETCD($key);

		if ($res['success'] == true && !empty($res['result'])) {
			if (!empty($res['result']['details'])) {
				$r1 = $res['result']['details'];
				$dataETCD = base64_decode($r1[1]);
				$data = explode('|', $dataETCD)[0];
				$datestart = explode('|', $dataETCD)[1];
			}
		}
	} catch (Exception $e) {
		setErrorLog($e);
	}

	return [
		'data' =>	$data,
		'datestart' => $datestart
	];
}

function setNewDataTranferETCD($key, $newData)
{
	$date = new DateTime();
	$ipETCD = '14.225.204.41';
	$now = $date->format('Y-m-d\TH:i:s\Z');

	try {
		$goapi = new GoAPI($ipETCD);
		$value = base64_encode($newData . '|' . $now);
		$goapi->setDataTranferETCD($key, $value);
	} catch (Exception $e) {
		setErrorLog($e);
	}
}

function getDataLoggerInFW($type, $cmd, $datestart, $dateend, $domain, $ipfw, $sid = 0)
{
	try {
		if ($type == 'graph') {
			if (isset($cmd) && $cmd == 'get_data_transfer') {
				$key = base64_encode($ipfw . '-' . $sid);
				$oldData = getOldDataTranferETCD($key);
				if ($oldData['datestart'] != '') {
					$datestart = $oldData['datestart'];
				}

				$curl = curl_init();
				$postfields = [
					'track_total_hits' => false,
					'size' => 10000,
					"_source" => false,
					'fields' => [
						[
							'field' => '*',
							'include_unmapped' => 'true'
						]
					],
					'query' =>  [
						'bool' =>  [
							'must' => [],
							'filter' => [
								[
									'bool' =>  [
										'filter' => [
											[
												'bool' =>  [
													'should' => [
														[
															'match_phrase' =>  [
																'fields.type.keyword' => 'nginx-traffic'
															]
														]
													],
													'minimum_should_match' => 1
												]
											],
											[
												'bool' =>  [
													'should' => [
														[
															'match' =>  [
																'host.ip' => $ipfw
															]
														]
													],
													'minimum_should_match' => 1
												]
											]
										]
									]
								],
								[
									'range' =>  [
										'@timestamp' =>  [
											'format' => 'strict_date_optional_time',
											"gte" => $datestart,
											"lte" => $dateend
										]
									]
								]
							]
						]
					]
				];

				$graph = new GraphAPI('traffic');
				$graph_data = $graph->getData($postfields);

				$data_transfer = 0;
				$total_hits = $graph_data["hits"]["hits"];
				foreach ($total_hits as $hit) {
					$data_transfer += $hit['fields']['bytes_in'][0] + $hit['fields']['bytes_out'][0];
				}

				if ($oldData['data'] > 0) {
					$data_transfer += $oldData['data'];
				}

				setNewDataTranferETCD($key, $data_transfer); // set new data transfer to ETCD Api

				curl_close($curl);
				echo json_encode(formatBytes($data_transfer));
				exit;
			} else {
				$curl = curl_init();
				$postfields = [
					'track_total_hits' => true,
					"size" => 0,
					"aggs" => [
						"data" => [
							"date_histogram" => [
								"field" => "@timestamp",
								"fixed_interval" => "5m",
								"time_zone" => "Asia/Saigon",
								"min_doc_count" => 1
							]
						]
					],
					'query' =>  [
						'bool' =>  [
							'must' => [],
							'filter' => [
								[
									'bool' =>  [
										'filter' => [
											[
												'bool' =>  [
													'should' => [
														[
															'match_phrase' =>  [
																'fields.type.keyword' => 'nginx-logs'
															]
														]
													],
													'minimum_should_match' => 1
												]
											],
											[
												'bool' =>  [
													'should' => [
														[
															'match' =>  [
																'host.ip' => $ipfw
															]
														]
													],
													'minimum_should_match' => 1
												]
											]
										]
									]
								],
								[
									'range' =>  [
										'@timestamp' =>  [
											'format' => 'strict_date_optional_time',
											"gte" => $datestart,
											"lte" => $dateend
										]
									]
								]
							]
						]
					]
				];

				if (isset($domain) && $domain != 'all') {
					$fildomain = [
						'bool' =>  [
							'should' => [
								[
									'match_phrase' =>  [
										'domain' => $domain
									]
								]
							],
							'minimum_should_match' => 1
						]
					];
					array_push($postfields['query']['bool']['filter'][0]['bool']['filter'], $fildomain);
				}

				$graph = new GraphAPI('logs');
				$graph_data = $graph->getData($postfields);

				$buckets = $graph_data["aggregations"]["data"]["buckets"];
				$total_hits = $graph_data["hits"]["total"]["value"];
				$hits = array(
					'total' => $total_hits,
					'items' => $buckets
				);
				curl_close($curl);

				echo json_encode(is_array($hits) ? $hits : array());
				exit;
			}
		} elseif ($type == 'logs') {
			$curl = curl_init();
			$postfields = [
				'track_total_hits' => false,
				"sort" => [
					[
						"@timestamp" => [
							"order" => "desc",
							"unmapped_type" => "boolean"
						]
					]
				],
				'fields' => [
					[
						'field' => 'message',
						'include_unmapped' => 'true'
					],
					[
						'field' => '@timestamp',
						'format' => 'strict_date_optional_time'
					]
				],
				"size" => 5000,
				"_source" => false,
				'query' =>  [
					'bool' =>  [
						'must' => [],
						'filter' => [
							[
								'bool' =>  [
									'filter' => [
										[
											'bool' =>  [
												'should' => [
													[
														'match_phrase' =>  [
															'fields.type.keyword' => 'nginx-logs'
														]
													]
												],
												'minimum_should_match' => 1
											]
										],
										[
											'bool' =>  [
												'should' => [
													[
														'match' =>  [
															'host.ip' => $ipfw
														]
													]
												],
												'minimum_should_match' => 1
											]
										]
									]
								]
							],
							[
								'range' =>  [
									'@timestamp' =>  [
										'format' => 'strict_date_optional_time',
										"gte" => $datestart,
										"lte" => $dateend
									]
								]
							]
						]
					]
				]
			];

			if (isset($domain) && $domain != 'all') {
				$fildomain = [
					'bool' =>  [
						'should' => [
							[
								'match_phrase' =>  [
									'domain' => $domain
								]
							]
						],
						'minimum_should_match' => 1
					]
				];
				array_push($postfields['query']['bool']['filter'][0]['bool']['filter'], $fildomain);
			}

			$graph = new GraphAPI('logs');
			$graph_data = $graph->getData($postfields);

			$logs = $graph_data["hits"]['hits'];
			$strlogs = '';
			foreach ($logs as $log) {
				$log_message = explode('|', $log['fields']['message'][0])[0];
				$strlogs .= $log_message . "\n";
			}
			echo json_encode($strlogs);
			curl_close($curl);
			exit;
		} else {
			return false;
		}
	} catch (Exception $e) {
		// Record the error in filelog module.
		setErrorLog($e);
	}
}

function getListVhostsByFwID($fwIP)
{
	$list_vhost = [];

	try {
		$goapi = new GoAPI($fwIP);
		$res_lvhost = $goapi->getListVhost();
		if ($res_lvhost['success'] == true && !empty($res_lvhost['data'])) {
			foreach ($res_lvhost['data'] as $vhost) {
				$vhost['vhost'] = $vhost['vhost'][0];
				array_push($list_vhost, $vhost);
			}
		}
	} catch (Exception $e) {
		// Record the error in filelog module.
		setErrorLog($e);
	}

	return $list_vhost;
}

function validateCertificateCode($code, $iskey = false)
{
	if ($iskey) {
		// $regex = '/-----BEGIN PRIVATE KEY-----[^-]*-----END PRIVATE KEY-----/s';
		$regex = '/-----BEGIN\s(?:.*\s)*?PRIVATE\sKEY-----\s*(.*?)\s*-----END\s(?:.*\s)*?PRIVATE\sKEY-----/s';
	} else {
		$regex = '/-----BEGIN CERTIFICATE-----[^-]*-----END CERTIFICATE-----/s';
	}

	preg_match_all($regex, $code, $matches);

	if ($matches[0]) {
		return implode("\n", $matches[0]);
	}
	return false;
}
