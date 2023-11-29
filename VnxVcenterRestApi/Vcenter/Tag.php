<?php

namespace VnxVcenterRestApi\Endpoints\Vcenter;

trait Tag
{
    public function getListOfTags($query)
    {
        return $this->request('GET', 'tagging/associations', [], $query);
    }
}
