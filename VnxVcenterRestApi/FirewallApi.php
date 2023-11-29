<?php

namespace VnxVcenterRestApi;

require_once  __DIR__ . '/Api.php';
require_once __DIR__ . '/Firewall/Firewall.php';

use VnxVcenterRestApi\Api;

// Add the API traits
use VnxVcenterRestApi\Endpoints\Vcenter\Firewall;

use WHMCS\Database\Capsule;

class FirewallApi extends Api
{
    use Firewall;

    const CONNECT_MODULE = 'api/vcenter';

    /**
     * Create an instance for the Vcenter API.
     * @param string $endpoint Your API endpoint, that should end on "/rest/".
     * @param integer $retries Number of retries for failed requests.
     * @param array $guzzleOptions Optional options to be passed to the Guzzle Client constructor.
     */
    public function __construct($retries = 5, $guzzleOptions = [])
    {
        $endpoint = $username = $password = '';

        try {
            $vcenterInfo = Capsule::table('mod_vnxfw2_server')->first();
            $adminUser = Capsule::table('tbladmins')->first();

            $adminUserId = $adminUser->id;
            $endpoint = $vcenterInfo->vsphereip;
            $username = $vcenterInfo->vsphereusername;

            $encryp_password["password2"] = $vcenterInfo->vspherepassword;
            $password = localAPI('decryptpassword', $encryp_password, $adminUserId)['password'];
        } catch (\Throwable $th) {
        }

        parent::__construct($endpoint, self::CONNECT_MODULE, $retries, $guzzleOptions);

        parent::login($username, $password);
    }
}
