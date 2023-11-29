<?php

namespace VnxVcenterRestApi;

require_once __DIR__ . '/Api.php';
require_once __DIR__ . '/Vcenter/VM.php';
require_once __DIR__ . '/Vcenter/Network.php';
require_once __DIR__ . '/Vcenter/Datacenter.php';
require_once __DIR__ . '/Vcenter/Cluster.php';
require_once __DIR__ . '/Vcenter/Datastore.php';
require_once __DIR__ . '/Vcenter/Deployment.php';
require_once __DIR__ . '/Vcenter/Folder.php';
require_once __DIR__ . '/Vcenter/Guest.php';
require_once __DIR__ . '/Vcenter/Host.php';
require_once __DIR__ . '/Vcenter/Tag.php';
require_once __DIR__ . '/Vcenter/Resourcepool.php';

use VnxVcenterRestApi\Api;

// Add the API traits
use VnxVcenterRestApi\Endpoints\Vcenter\VM;
use VnxVcenterRestApi\Endpoints\Vcenter\Network;
use VnxVcenterRestApi\Endpoints\Vcenter\Datacenter;
use VnxVcenterRestApi\Endpoints\Vcenter\Cluster;
use VnxVcenterRestApi\Endpoints\Vcenter\Datastore;
use VnxVcenterRestApi\Endpoints\Vcenter\Deployment;
use VnxVcenterRestApi\Endpoints\Vcenter\Folder;
use VnxVcenterRestApi\Endpoints\Vcenter\Guest;
use VnxVcenterRestApi\Endpoints\Vcenter\Host;
use VnxVcenterRestApi\Endpoints\Vcenter\Tag;
use VnxVcenterRestApi\Endpoints\Vcenter\Resourcepool;

class VcenterApi extends Api
{
    use VM, Network, Datacenter, Cluster, Datastore, Deployment, Folder, Guest, Host, Resourcepool, Tag;

    const CONNECT_MODULE = 'rest/vcenter';

    /**
     * Create an instance for the Vcenter API.
     * @param string $endpoint Your API endpoint, that should end on "/rest/".
     * @param integer $retries Number of retries for failed requests.
     * @param array $guzzleOptions Optional options to be passed to the Guzzle Client constructor.
     */
    public function __construct($endpoint = 'https://cloudvcenter.vietnix.vn/', $retries = 5, $guzzleOptions = [])
    {
        parent::__construct($endpoint, self::CONNECT_MODULE, $retries, $guzzleOptions);
    }
}
