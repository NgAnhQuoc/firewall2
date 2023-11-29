<?php

use Illuminate\Database\Capsule\Manager as Capsule;

function vnxVmwareGetCustomFiledVal($params, $hook = null)
{
    $newVmnameField = 'vm_name';

    $dataceter_nameField = 'datacenter';

    $osTypeField = 'guest_os_family';

    $guetOsVersionField = 'guest_os_version';

    $ramField = 'ram';

    $cpuField = 'cpu';

    $hardDiskField = 'harddisk';

    $bandwidthField = 'bandwidth';

    $AdditionalIpField = 'additional_ip';

    $snapShotField = 'snapshot_limit';

    $hardDiskpartitionField = 'hard_disk_partition';

    $datacenterAndHostnameField = 'hostname_dc';

    if (empty($hook)) {

        $newVmname = $params['customfields'][$newVmnameField];

        $dataceter_name = $params['customfields'][$dataceter_nameField];

        $datacenterAndHostname = $params['customfields'][$datacenterAndHostnameField];

        if (empty($params['configoption1'])) {

            $osType = $params['customfields'][$osTypeField];

            $guetOsVersion = $params['customfields'][$guetOsVersionField];

            $ram = (!empty($params['configoption20'])) ? $params['configoption4'] + ($params['configoptions'][$ramField] * 1024) : $params['configoption4'];
            $cpu = (!empty($params['configoption20'])) ? $params['configoption5'] + $params['configoptions'][$cpuField] : $params['configoption5'];

            $hardDisk = (!empty($params['configoption20'])) ? $params['configoption7'] + $params['configoption8'] + $params['configoption9'] + $params['configoption10'] + $params['configoptions'][$hardDiskField] : $params['configoption7'] + $params['configoption8'] + $params['configoption9'] + $params['configoption10'];

            $hardDiskParttition = (!empty($params['configoption20'])) ? $params['configoptions'][$hardDiskpartitionField] : 1;

            $bandwidth = (!empty($params['configoption20'])) ? $params['configoption11'] + $params['configoptions'][$bandwidthField] : $params['configoption11'];

            $additionalIp = (!empty($params['configoption20'])) ? $params['configoption6'] + $params['configoptions'][$AdditionalIpField] : $params['configoption6'];

            $snapshot_limit = (!empty($params['configoption20'])) ? $params['configoption19'] + $params['configoptions'][$snapShotField] : $params['configoption19'];
        } else {

            $osType = $params['configoptions'][$osTypeField];

            $guetOsVersion = $params['configoptions'][$guetOsVersionField];

            if (!empty($params['configoption20'])) {

                $ram = (!empty($params['configoptions'][$ramField])) ? $params['configoption4'] + ($params['configoptions'][$ramField] * 1024) : $params['configoption4'];
                $cpu = (!empty($params['configoptions'][$cpuField])) ? $params['configoption5'] + $params['configoptions'][$cpuField] : $params['configoption5'];

                $hardDisk = (!empty($params['configoptions'][$hardDiskField])) ? $params['configoption7'] + $params['configoption8'] + $params['configoption9'] + $params['configoption10'] + $params['configoptions'][$hardDiskField] : $params['configoption7'] + $params['configoption8'] + $params['configoption9'] + $params['configoption10'];

                $hardDiskParttition = (!empty($params['configoptions'][$hardDiskpartitionField])) ? $params['configoptions'][$hardDiskpartitionField] : 1;

                $bandwidth = (!empty($params['configoptions'][$bandwidthField])) ? $params['configoption11'] + $params['configoptions'][$bandwidthField] : $params['configoption11'];

                $additionalIp = (!empty($params['configoptions'][$AdditionalIpField])) ? $params['configoption6'] + $params['configoptions'][$AdditionalIpField] : $params['configoption6'];

                $snapshot_limit = (!empty($params['configoptions'][$snapShotField])) ? $params['configoption19'] + $params['configoptions'][$snapShotField] : $params['configoption19'];
            } else {
                $ram = (!empty($params['configoptions'][$ramField])) ? $params['configoptions'][$ramField] * 1024 : $params['configoption4'];
                $cpu = (!empty($params['configoptions'][$cpuField])) ? $params['configoptions'][$cpuField] : $params['configoption5'];

                $hardDisk = (!empty($params['configoptions'][$hardDiskField])) ? $params['configoptions'][$hardDiskField] : $params['configoption7'] + $params['configoption8'] + $params['configoption9'] + $params['configoption10'];

                $hardDiskParttition = (!empty($params['configoptions'][$hardDiskpartitionField])) ? $params['configoptions'][$hardDiskpartitionField] : 1;

                $bandwidth = $params['configoptions'][$bandwidthField];

                $additionalIp = $params['configoptions'][$AdditionalIpField];

                $snapshot_limit = $params['configoptions'][$snapShotField];
            }
        }

        return array(
            'vm_name' => $newVmname,
            'datacenter' => $dataceter_name,
            'os_type' => $osType,
            'os_version' => $guetOsVersion,
            'ram' => $ram,
            'cpu' => $cpu,
            'hard_disk' => $hardDisk,
            'hard_disk_partition' => $hardDiskParttition,
            'bandwidth' => $bandwidth,
            'additional_ip' => $additionalIp,
            'hostname_dc' => $datacenterAndHostname,
            'snapshot_limit' => $snapshot_limit,
        );
    } else {

        if ($params['configoption1'] == 'on') {

            return array(
                'vm_name_field' => $newVmnameField,
                'datacenter_field' => $dataceter_nameField,
                'os_type_field' => $osTypeField,
                'os_version_field' => $guetOsVersionField,
                'ram_field' => $ramField,
                'cpu_field' => $cpuField,
                'hard_disk_field' => $hardDiskField,
                'bandwith_field' => $bandwidthField,
                'additional_ip_field' => $AdditionalIpField,
                'hostname_dc_field' => $datacenterAndHostnameField,
                'snap_shot_field' => $snapShotField,
            );
        } else {

            return array(
                'vm_name_field' => $newVmnameField,
                'datacenter_field' => $dataceter_nameField,
                'os_type_field' => $osTypeField,
                'os_version_field' => $guetOsVersionField,
                'hostname_dc_field' => $datacenterAndHostnameField,
            );
        }
    }
}

function vnxVmwareCreateProductConfigurableOption($pid, $createConfigurableOption, $configoption3 = null, $productResult = null, $hideGuestOs = null)
{

    $dhcp = $productResult->configoption18;



    $oldConfigurableOptionGroupName = 'Vmware' . $pid;
    $configurableOptionGroupName = 'Vmware Resources';

    $configurableOptionName1 = 'guest_os_family|Guest OS Family';

    $configurableOptionName2 = 'guest_os_version|Guest OS Version';

    $configurableOptionName3 = 'ram|RAM (GB)';

    $configurableOptionName4 = "cpu|CPU";

    $configurableOptionName5 = 'harddisk|Hard Disk (GB)';

    $configurableOptionName7 = 'bandwidth|Bandwidth (GB)';

    $configurableOptionName8 = 'additional_ip|Additional IP';

    $configurableOptionName9 = 'snapshot_limit|No. of Snap Shots';



    $configurableOptionArr = array(
        array(
            'optionName' => $configurableOptionName1,
            'optiontype' => '1',
            'min' => '',
            'max' => '',
            'order' => '0',
            "hidden" => ''
        ),
        array(
            'optionName' => $configurableOptionName2,
            'optiontype' => '1',
            'min' => '',
            'max' => '',
            'order' => '1',
            "hidden" => ''
        ),
        array(
            'optionName' => $configurableOptionName3,
            'optiontype' => '4',
            'min' => '0',
            'max' => '4',
            'order' => '2',
            "hidden" => ''
        ),
        array(
            'optionName' => $configurableOptionName4,
            'optiontype' => '4',
            'min' => '0',
            'max' => '4',
            'order' => '3',
            "hidden" => ''
        ),
        array(
            'optionName' => $configurableOptionName5,
            'optiontype' => '4',
            'min' => '0',
            'max' => '100',
            'order' => '4',
            "hidden" => ''
        ),
        array(
            'optionName' => $configurableOptionName7,
            'optiontype' => '4',
            'min' => '0',
            'max' => '4',
            'order' => '5',
            "hidden" => ''
        ),
        array(
            'optionName' => $configurableOptionName9,
            'optiontype' => '4',
            'min' => '0',
            'max' => '4',
            'order' => '6',
            "hidden" => ''
        ),
    );

    $arr = array(
        'optionName' => $configurableOptionName8,
        'optiontype' => '4',
        'min' => '0',
        'max' => '4',
        'order' => '7',
        "hidden" => ''
    );

    if ($dhcp) {

        array_merge($arr, array("hidden" => '1'));
    }

    $configurableOptionArr = array_merge($configurableOptionArr, array($arr));
    if (!empty($createConfigurableOption)) {

        $getOldConfigId = Capsule::table('tblproductconfiggroups')->where('name', $oldConfigurableOptionGroupName)->first();
        if (count($getOldConfigId) > 0) {
            $configurableGroupId = $getOldConfigId->id;
        } else {

            $getConfigGid = Capsule::table('tblproductconfiggroups')->where('name', $configurableOptionGroupName)->first();
            $configurableGroupId = $getConfigGid->id;
        }

        if (!empty($configurableGroupId)) {
            if (Capsule::table('tblproductconfiglinks')->where('pid', $pid)->count() == 0)
                Capsule::table('tblproductconfiglinks')->insert(['gid' => $configurableGroupId, 'pid' => $pid]);

            $getOptionId = Capsule::table('tblproductconfigoptions')->select('id')->where('gid', $configurableGroupId)->where('optionname', $configurableOptionName8)->get();

            if ($dhcp) {

                $updateData = ["hidden" => "1"];

                if (!empty($getOptionId[0]->id)) {

                    Capsule::table('tblproductconfigoptions')->where('id', $getOptionId[0]->id)->update($updateData);
                }
            } elseif (empty($dhcp)) {

                $updateData = ["hidden" => "0"];

                if (!empty($getOptionId[0]->id)) {
                }
            }
        } else {

            $configurableGroupId = Capsule::table('tblproductconfiggroups')->insertGetId(
                [
                    'name' => $configurableOptionGroupName,
                    'description' => ''
                ]
            );



            Capsule::table('tblproductconfiglinks')->insertGetId(
                [
                    'gid' => $configurableGroupId,
                    'pid' => $pid,
                ]
            );



            foreach ($configurableOptionArr as $options) {

                $configId = Capsule::table('tblproductconfigoptions')->insertGetId(
                    [
                        'gid' => $configurableGroupId,
                        'optionname' => $options['optionName'],
                        'optiontype' => $options['optiontype'],
                        'qtyminimum' => $options['min'],
                        'qtymaximum' => $options['max'],
                        'order' => $options['order'],
                        'hidden' => $options['hidden'],
                    ]
                );

                if ($options['optionName'] == 'guest_os_family|Guest OS Family') {

                    $guestOsFamilyArr = array('Windows', 'Linux', 'Others');

                    foreach ($guestOsFamilyArr as $guestOsFamily) {

                        vnxVmwareAddConfigoptionsSub($configId, $guestOsFamily);
                    }
                } elseif ($options['optionName'] == 'guest_os_version|Guest OS Version') {

                    $getServerIdArr = Capsule::table('mod_vmware_server')->select('id')->where('server_name', $configoption3)->get();
                    if (count($getServerIdArr) == 0)
                        $getServerIdArr = Capsule::table('mod_vmware_server')->select('id')->where('id', $configoption3)->get();
                    $getServerId = $getServerIdArr[0]->id;

                    $dcQuery = Capsule::table('tblcustomfields')->where('type', 'product')->where('relid', $pid)->where('fieldname', 'like', '%datacenter%')->get();

                    $dcQuery = (array) $dcQuery[0];

                    $dcArr = explode(',', $dcQuery['fieldoptions']);



                    $cloneOsListQryArr = array();

                    $iso_osListQryArr = array();



                    $cloneOsListQry = Capsule::table('mod_vmware_temp_list')->select('customname')->where('status', '')->where('server_id', $getServerId)->get();

                    $i = 0;

                    foreach ($cloneOsListQry as $key => $os_list) {

                        $cloneOsListQryArr[$key] = $os_list->customname;

                        //$i++;
                    }

                    $iso_osListQry = Capsule::table('mod_vmware_os_list')->select('os_version')->where('status', '')->where('server_id', $getServerId)->get();



                    foreach ($iso_osListQry as $key => $os_list) {

                        $iso_osListQryArr[$key] = $os_list->os_version;
                    }

                    $osListQry = array_unique(array_merge($cloneOsListQryArr, $iso_osListQryArr));

                    foreach ($osListQry as $os_list) {

                        if (!empty($os_list)) {

                            $count = Capsule::table('tblproductconfigoptionssub')->where('configid', $configId)->where('optionname', $os_list)->count();

                            if ($count == 0)
                                vnxVmwareAddConfigoptionsSub($configId, $os_list);
                        }
                    }
                } else {

                    vnxVmwareAddConfigoptionsSub($configId);
                }
            }
        }

        if (!empty($configurableGroupId)) {

            $getOsFamlityConfigID = Capsule::table('tblproductconfigoptions')->select('id')->where('gid', $configurableGroupId)->where('optionname', 'like', '%guest_os_family%')->count();

            if ($getOsFamlityConfigID == '0') {

                $configId = Capsule::table('tblproductconfigoptions')->insertGetId(
                    [
                        'gid' => $configurableGroupId,
                        'optionname' => 'guest_os_family|Guest OS Family',
                        'optiontype' => '1',
                        'qtyminimum' => '',
                        'qtymaximum' => '',
                        'order' => '0',
                        'hidden' => '',
                    ]
                );

                $guestOsFamilyArr = array('Windows', 'Linux', 'Others');

                foreach ($guestOsFamilyArr as $guestOsFamily) {

                    vnxVmwareAddConfigoptionsSub($configId, $guestOsFamily);
                }
            }



            $getConfigID = Capsule::table('tblproductconfigoptions')->select('id')->where('gid', $configurableGroupId)->where('optionname', 'like', '%guest_os_version%')->first();



            $configId = $getConfigID->id;

            if (empty($getConfigID)) {

                $configId = Capsule::table('tblproductconfigoptions')->insertGetId(
                    [
                        'gid' => $configurableGroupId,
                        'optionname' => 'guest_os_version|Guest OS Version',
                        'optiontype' => '1',
                        'qtyminimum' => '',
                        'qtymaximum' => '',
                        'order' => '1',
                        'hidden' => '',
                    ]
                );
            }
            $getServerIdArr = Capsule::table('mod_vmware_server')->select('id')->where('server_name', $configoption3)->get();
            if (count($getServerIdArr) == 0)
                $getServerIdArr = Capsule::table('mod_vmware_server')->select('id')->where('id', $configoption3)->get();

            $getServerId = $getServerIdArr[0]->id;



            $dcQuery = Capsule::table('tblcustomfields')->where('type', 'product')->where('relid', $pid)->where('fieldname', 'like', '%datacenter%')->get();

            $dcQuery = (array) $dcQuery[0];

            $dcArr = explode(',', $dcQuery['fieldoptions']);



            $cloneOsListQryArr = array();

            $iso_osListQryArr = array();



            $cloneOsListQry = Capsule::table('mod_vmware_temp_list')->select('customname')->where('status', '')->where('server_id', $getServerId)->get();

            $i = 0;

            foreach ($cloneOsListQry as $key => $os_list) {

                $cloneOsListQryArr[$key] = $os_list->customname;

                //$i++;
            }

            $iso_osListQry = Capsule::table('mod_vmware_os_list')->select('os_version')->where('status', '')->where('server_id', $getServerId)->get();



            foreach ($iso_osListQry as $key => $os_list) {

                $iso_osListQryArr[$key] = $os_list->os_version;
            }

            $osListQry = array_unique(array_merge($cloneOsListQryArr, $iso_osListQryArr));



            foreach ($osListQry as $os_list) {

                if (!empty($os_list)) {

                    $count = Capsule::table('tblproductconfigoptionssub')->select('id')->where('configid', $configId)->where('optionname', $os_list)->count();

                    if ($count == 0 && !empty($configId))
                        vnxVmwareAddConfigoptionsSub($configId, $os_list);
                }
            }
        }
        if (!empty($configurableGroupId)) {
            if ($hideGuestOs) {
                Capsule::table('tblproductconfigoptions')->select('id')->where('gid', $configurableGroupId)->where('optionname', 'like', '%guest_os_family%')->update(["hidden" => '1']);
                Capsule::table('tblproductconfigoptions')->select('id')->where('gid', $configurableGroupId)->where('optionname', 'like', '%guest_os_version%')->update(["hidden" => '1']);
            } else {
                Capsule::table('tblproductconfigoptions')->select('id')->where('gid', $configurableGroupId)->where('optionname', 'like', '%guest_os_family%')->update(["hidden" => '']);
                Capsule::table('tblproductconfigoptions')->select('id')->where('gid', $configurableGroupId)->where('optionname', 'like', '%guest_os_version%')->update(["hidden" => '']);
            }
        }
    } else {

        $getOldConfigId = Capsule::table('tblproductconfiggroups')->where('name', $oldConfigurableOptionGroupName)->first();
        if (!empty($getOldConfigId)) {

            $configurableGroupId = $getOldConfigId->id;
        } else {

            $getConfigGid = Capsule::table('tblproductconfiggroups')->where('name', $configurableOptionGroupName)->first();

            $configurableGroupId = $getConfigGid->id;
        }

        if (!empty($configurableGroupId))
            Capsule::table('tblproductconfiglinks')->where('gid', $configurableGroupId)->where('pid', $pid)->delete();
    }
}

function vnxVmwareAddConfigoptionsSub($configId, $optionName = null)
{

    if (empty($optionName))
        $optionName = '';

    $tblpricing_rel_id = Capsule::table('tblproductconfigoptionssub')->insertGetId(
        [
            'configid' => $configId,
            'optionname' => $optionName,
            'sortorder' => '',
            'hidden' => ''
        ]
    );


    vnxVmwareAddConfigurablePrice($tblpricing_rel_id);
}

function vnxVmwareAddConfigurablePrice($tblpricing_rel_id)
{

    $result = Capsule::table('tblcurrencies')->get();

    foreach ($result as $data) {

        $curr_id = $data->id;

        $curr_code = $data->code;

        $currenciesarray[$curr_id] = $curr_code;
    }



    foreach ($currenciesarray as $curr_id => $currency) {

        Capsule::table('tblpricing')->insertGetId(
            [
                'type' => 'configoptions',
                'currency' => $curr_id,
                'relid' => $tblpricing_rel_id,
                'msetupfee' => '',
                'qsetupfee' => '',
                'ssetupfee' => '',
                'asetupfee' => '',
                'bsetupfee' => '',
                'tsetupfee' => '',
                'monthly' => '',
                'quarterly' => '',
                'semiannually' => '',
                'annually' => '',
                'biennially' => '',
                'triennially' => '',
            ]
        );
    }
}
