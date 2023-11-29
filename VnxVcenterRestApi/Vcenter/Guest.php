<?php

namespace VnxVcenterRestApi\Endpoints\Vcenter;

trait Guest
{
    public function getListOfGuests($query = [])
    {
        return $this->request('GET', 'guest/customization-specs', [], $query);
    }
}
