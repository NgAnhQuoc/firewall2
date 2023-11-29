<?php

use WHMCS\View\Menu\Item as MenuItem;

add_hook('ClientAreaPrimarySidebar', 1, function (MenuItem $primarySidebar) {
    if (null !== $primarySidebar->getChild('Service Details Actions')) {
        $primarySidebar->getChild('Service Details Actions')
            ->removeChild('Change Password');
    }
});
