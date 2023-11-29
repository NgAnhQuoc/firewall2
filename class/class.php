<?php

use Illuminate\Database\Capsule\Manager as Capsule;

if (file_exists(__DIR__ . '/obj_to_array.php'))
    require_once __DIR__ . '/obj_to_array.php';

if (file_exists(__DIR__ . '/class/logger.php')) {
    require_once __DIR__ . '/class/logger.php';
}

class VnxVmware extends VnxObjToArray
{

    public function __construct()
    {
    }

    public function VnxVmwarePwEncryptDcrypt($passWord, $encrypt = null)
    {

        if ($encrypt)
            $command = "encryptpassword";
        else
            $command = "decryptpassword";

        $adminQuery = Capsule::table('tbladmins')->first();

        $adminuser = $adminQuery->id;
        $values["password2"] = $passWord;

        $results = localAPI($command, $values, $adminuser);
        return html_entity_decode($results['password']);
    }

    public function vnx_vmware_manageCustomFields($pid, $createConfigOption = null, $prefix = null, $hideGuestOs = null)
    {
        $this->vmware_create_custom_field($pid, 'vm_name|VmName', 'text', 'It is optional. if you leave it blank then random Vm Name will be create.', 'on', '', '', '', '1');
        $this->vmware_create_custom_field($pid, 'datacenter|Datacenter Name', 'dropdown', '', '', 'on', '', '', '2');
        if ($createConfigOption && $hideGuestOs) {
            $this->vmware_create_custom_field($pid, 'guest_os_family|Guest OS Family', 'dropdown', '', 'on', '', 'Windows,Linux,Others', 'on', '3');
            $this->vmware_create_custom_field($pid, 'guest_os_version|Guest OS Version', 'dropdown', '', 'on', '', '', '', '4');
        } elseif ($createConfigOption && empty($hideGuestOs)) {
            $this->vmware_create_custom_field($pid, 'guest_os_family|Guest OS Family', 'dropdown', '', '', 'on', 'Windows,Linux,Others', 'on', '3');
            $this->vmware_create_custom_field($pid, 'guest_os_version|Guest OS Version', 'dropdown', '', '', 'on', '', '', '4');
        } else {
            //$this->vmwareDeleteCf($pid, 'guest_os_family');
            // $this->vmwareDeleteCf($pid, 'guest_os_version');
            $this->vmware_create_custom_field($pid, 'guest_os_family|Guest OS Family', 'dropdown', '', '', 'on', 'Windows,Linux,Others', '', '3');
            $this->vmware_create_custom_field($pid, 'guest_os_version|Guest OS Version', 'dropdown', '', '', 'on', '', '', '4');
        }
        $this->vmware_create_custom_field($pid, 'overusage|Overusage', 'text', "Only for admin.", 'on', '', '', '', '5');
        $this->vmware_create_custom_field($pid, 'mail_status|Mail status', 'text', "Only for admin.", 'on', '', '', '', '6');
        $this->vmware_create_custom_field($pid, 'vnc_detail|VNC Detail', 'text', "Only for admin.", 'on', '', '', '', '7');
        $this->vmware_create_custom_field($pid, 'hostname_dc|Hostname', 'text', "Only for admin.", 'on', '', '', '', '8');
        $this->vmware_create_custom_field($pid, 'reinstall|Reinstall Vm', 'text', "Only for admin.", 'on', '', '', '', '9');
        $this->vmware_create_custom_field($pid, 'vm_password|VM Password', 'text', "Only for admin.", 'on', '', '', '', '10');
        $this->vmware_create_custom_field($pid, 'mac_address|Mac Address', 'text', "Only for admin.", 'on', '', '', '', '11');
        $this->vmware_create_custom_field($pid, 'vcenter_server_name|vCenter Server', 'dropdown', "Only for admin. Don't change it", 'on', '', '', '', '12');
    }

    public function vmware_manageCustomFields($pid, $createConfigOption = null, $prefix = null, $hideGuestOs = null)
    {
        $this->vmware_create_custom_field($pid, 'vm_name|VmName', 'text', 'It is optional. if you leave it blank then random Vm Name will be create.', 'on', '', '', '', '1');
        $this->vmware_create_custom_field($pid, 'datacenter|Datacenter Name', 'dropdown', '', '', 'on', '', '', '2');
        if ($createConfigOption && $hideGuestOs) {
            $this->vmware_create_custom_field($pid, 'guest_os_family|Guest OS Family', 'dropdown', '', 'on', '', 'Windows,Linux,Others', 'on', '3');
            $this->vmware_create_custom_field($pid, 'guest_os_version|Guest OS Version', 'dropdown', '', 'on', '', '', '', '4');
        } elseif ($createConfigOption && empty($hideGuestOs)) {
            $this->vmware_create_custom_field($pid, 'guest_os_family|Guest OS Family', 'dropdown', '', '', 'on', 'Windows,Linux,Others', 'on', '3');
            $this->vmware_create_custom_field($pid, 'guest_os_version|Guest OS Version', 'dropdown', '', '', 'on', '', '', '4');
        } else {
            //$this->vmwareDeleteCf($pid, 'guest_os_family');
            // $this->vmwareDeleteCf($pid, 'guest_os_version');
            $this->vmware_create_custom_field($pid, 'guest_os_family|Guest OS Family', 'dropdown', '', '', 'on', 'Windows,Linux,Others', '', '3');
            $this->vmware_create_custom_field($pid, 'guest_os_version|Guest OS Version', 'dropdown', '', '', 'on', '', '', '4');
        }
        $this->vmware_create_custom_field($pid, 'overusage|Overusage', 'text', "Only for admin.", 'on', '', '', '', '5');
        $this->vmware_create_custom_field($pid, 'mail_status|Mail status', 'text', "Only for admin.", 'on', '', '', '', '6');
        $this->vmware_create_custom_field($pid, 'vnc_detail|VNC Detail', 'text', "Only for admin.", 'on', '', '', '', '7');
        $this->vmware_create_custom_field($pid, 'hostname_dc|Hostname', 'text', "Only for admin.", 'on', '', '', '', '8');
        $this->vmware_create_custom_field($pid, 'reinstall|Reinstall Vm', 'text', "Only for admin.", 'on', '', '', '', '9');
        $this->vmware_create_custom_field($pid, 'vm_password|VM Password', 'text', "Only for admin.", 'on', '', '', '', '10');
        $this->vmware_create_custom_field($pid, 'mac_address|Mac Address', 'text', "Only for admin.", 'on', '', '', '', '11');
        $this->vmware_create_custom_field($pid, 'vcenter_server_name|vCenter Server', 'dropdown', "Only for admin. Don't change it", 'on', '', '', '', '12');
    }

    public function vmware_create_custom_field($pid, $fieldname, $fieldtype, $desc, $adminonly, $showorder, $optionsValue, $required, $sortorder)
    {

        $value = [
            'type' => 'product',
            'relid' => $pid,
            'fieldname' => $fieldname,
            'fieldtype' => $fieldtype,
            'description' => $desc,
            'adminonly' => $adminonly,
            'showorder' => $showorder,
            'required' => $required,
            'fieldoptions' => $optionsValue,
            'sortorder' => $sortorder,
        ];

        try {
            $fieldArr = explode('|', $fieldname);
            $select = Capsule::select("SELECT * FROM tblcustomfields WHERE relid = '" . $pid . "' AND type = 'product' AND (fieldname LIKE '%" . $fieldArr[0] . "%' OR fieldname LIKE '%" . $fieldArr[1] . "%')");

            if (count($select) == 0) {
                try {
                    Capsule::table('tblcustomfields')->insert(
                        $value
                    );
                } catch (\Exception $e) {
                }
            } else {
                if ($fieldArr[0] == "guest_os_family" || $fieldArr[0] == "guest_os_version") {
                    Capsule::table('tblcustomfields')->where("id", $select[0]->id)->update(
                        ['adminonly' => $adminonly, "showorder" => $showorder]
                    );
                }
            }
        } catch (\Exception $e) {
        }
    }

    public function vmware_update_custom_field($pid, $fieldname, $fieldtype, $desc, $adminonly, $showorder, $optionsValue, $required, $sortorder)
    {

        $value = [
            'type' => 'product',
            'relid' => $pid,
            'fieldname' => $fieldname,
            'fieldtype' => $fieldtype,
            'description' => $desc,
            'adminonly' => $adminonly,
            'showorder' => $showorder,
            'required' => $required,
            'fieldoptions' => $optionsValue,
            'sortorder' => $sortorder,
        ];

        try {
            $fieldArr = explode('|', $fieldname);
            $select = Capsule::select("SELECT * FROM tblcustomfields WHERE relid = '" . $pid . "' AND type = 'product' AND (fieldname LIKE '%" . $fieldArr[0] . "%' OR fieldname LIKE '%" . $fieldArr[1] . "%')");
            if (count($select) == 0) {
                try {
                    Capsule::table('tblcustomfields')->where("id", $select[0]->id)->update(
                        ['adminonly' => $adminonly, "showorder" => $showorder]
                    );
                } catch (\Exception $e) {
                }
            } else {
            }
        } catch (\Exception $e) {
        }
    }

    public function vmwareDeleteCf($pid, $fieldname)
    {
        Capsule::table('tblcustomfields')->where('relid', $pid)->where('type', 'product')->where('fieldname', 'like', '%' . $fieldname . '%')->delete();
    }

    public function vmware_formatSizeUnits($bytes, $unit = null)
    {
        if ($unit) {
            if ($bytes >= 1024)
                $bytes = ($bytes / 1024) . ' GB';
            elseif ($bytes < 1024)
                $bytes = 1 . ' MB';
        } else {
            if ($bytes >= 1099511627776) {
                $bytes = number_format($bytes / 1099511627776, 2) . ' TB';
            } else if ($bytes >= 1073741824) {
                $bytes = number_format($bytes / 1073741824, 2) . ' GB';
            } elseif ($bytes >= 1048576) {
                $bytes = number_format($bytes / 1048576, 2) . ' MB';
            } elseif ($bytes >= 1024) {
                $bytes = number_format($bytes / 1024, 2) . ' KB';
            } elseif ($bytes > 1) {
                $bytes = $bytes . ' bytes';
            } elseif ($bytes == 1) {
                $bytes = $bytes . ' byte';
            } else {
                $bytes = '0 bytes';
            }
        }

        return $bytes;
    }

    public function get_time($time)
    {
        $duration = $time;
        $hours = floor($duration / 3600);
        $minutes = floor(($duration / 60) % 60);
        $seconds = $duration % 60;
        if ($hours != 0)
            return $hours . 'H ' . $minutes . 'Min ' . $seconds . 'Sec';
        else
            return $minutes . 'Min ' . $seconds . 'Sec';
    }

    public function vmware_includes_files($params = null)
    {
        require_once dirname(__DIR__) . '/vmwarephp/Bootstrap.php';
        require_once dirname(__DIR__) . '/vmclass.php';
        // require_once dirname(__DIR__) . '/vmware.php';
        // require_once dirname(__DIR__) . '/manage_cfields.php';
    }

    public function vmware_generateRandomString($length = 10)
    {
        $characters = 'abcdefghijklmnopqrstuvwxyz';
        $charactersLength = strlen($characters);
        $randomString = '';
        for ($i = 0; $i < $length; $i++) {
            $randomString .= $characters[rand(0, $charactersLength - 1)];
        }
        return $randomString;
    }

    public function vmware_randomuser($len = 8)
    {
        $user = '';
        $lchar = 0;
        $char = 0;
        for ($i = 0; $i < $len; $i++) {
            while ($char == $lchar) {
                $char = rand(48, 109);
                if ($char > 57)
                    $char += 7;
                if ($char > 90)
                    $char += 6;
            }
            $user .= chr($char);
            $lchar = $char;
        }
        return $user;
    }

    public function updateConfiguration($pid, $field, $data)
    {
        try {
            $updatedDatacenterName = Capsule::table('tblproducts')
                ->where('id', $pid)
                ->update(
                    [
                        $field => $data,
                    ]
                );
        } catch (Exception $e) {
            setErrorLog($e);
        }
    }

    public function vmwareClean($string)
    {
        $string = str_replace(' ', '-', $string); // Replaces all spaces with hyphens.
        $string = preg_replace('/[^A-Za-z0-9\-]/', '', $string); // Removes special chars.

        return preg_replace('/-+/', '', $string); // Replaces multiple hyphens with single one.
    }

    public function VnxVmwareGetDomain($url)
    {
        $pieces = parse_url($url);
        $domain = isset($pieces['host']) ? $pieces['host'] : $pieces['path'];
        if (preg_match('/(?P<domain>[a-z0-9][a-z0-9\-]{1,63}\.[a-z\.]{2,6})$/i', $domain, $regs)) {
            return $regs['domain'];
        }
        return false;
    }
}
