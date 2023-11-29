<link href="{$WEB_ROOT}/modules/servers/vietnix_firewall2/templates/css/app.css" rel="stylesheet" type="text/css" />
<script src="{$WEB_ROOT}/modules/servers/vietnix_firewall2/templates/js/app.js"></script>

<div class="vf-flex-1 vf-flex vf-flex-col">
    <!-- Service Info -->
    <div class="vf-flex vf-flex-col vf-bg-white vf-rounded vf-shadow-card vf-py-6">
        <div class="vf-flex vf-flex-col md:vf-flex-row">
            <div class="vf-flex-1 vf-flex vf-flex-col vf-border-b vf-border-solid vf-pb-4 vf-mb-4 md:vf-pb-0 md:vf-mb-0 md:vf-border-r md:vf-border-b-0">
                <div class="vf-mr-5 vf-ml-7">
                    <img class="vf-w-12 vf-h-12" src="{$WEB_ROOT}/modules/servers/vietnix_firewall2/templates/img/firewall.svg" />
                </div>

                <div class="vf-flex vf-flex-col vf-mr-5 vf-ml-7">
                    <div class="vf-text-xs vf-text-gray-3 vf-mb-2">{$groupname}</div>
                    <div class="vf-text-base vf-font-semibold">{$product}</div>
                </div>
            </div>

            <div class="vf-flex-1 vf-flex vf-flex-col vf-justify-end vf-px-6 md:vf-justify-center">
                <div class="vf-flex vf-flex-row vf-mb-4">
                    <div class="vf-text-xs vf-text-gray-1">IP Firewall:</div>
                    <div class="vf-flex-1"></div>
                    <div class="vf-text-xs vf-text-gray-1">{$dedicatedip}</div>
                </div>
                <div class="vf-flex vf-flex-row vf-mb-4">
                    <div class="vf-text-xs vf-text-gray-1">Hostname:</div>
                    <div class="vf-flex-1"></div>
                    <div class="vf-text-xs vf-text-gray-1">{$domain}</div>
                </div>
                <div class="vf-flex vf-flex-row">
                    <div class="vf-text-xs vf-text-gray-1">Data Transfer:</div>
                    <div class="vf-flex-1"></div>
                    <div class="vf-bg-primary vf-rounded-[900px] vf-text-xs vf-text-white vf-font-bold vf-py-1 vf-px-3" id="fw-data-transfer"></div>
                </div>
            </div>
        </div>
    </div>
    <!-- Graph -->
    <div class="vf-flex vf-flex-col vf-bg-white vf-rounded vf-shadow-card vf-py-6 vf-mt-6">
        <div class="vf-flex vf-flex-row">
            <div class="vf-text-xl vf-mr-5 vf-ml-7 vf-text-gray-1 vf-font-medium">Traffic Overview</div>
            <div class="vf-flex-1"></div>
            <div class="vf-text-sm vf-mr-5 vf-text-primary vf-font-medium">
                <a href="{$WEB_ROOT}/{$filename}.php?action={$action}&id={$id}&modop=custom&a=view_graph" class="vnx-list-group-item">
                    Chi tiết
                    <i class="fas "></i>
                </a>
            </div>
        </div>
        <div class="vf-flex-1 vf-mr-5 vf-ml-7 vf-mt-2">
            <div id="fwchart"></div>
        </div>
    </div>

    <!-- Payment Info -->
    <div class="vf-flex vf-flex-col vf-bg-white vf-rounded vf-shadow-card vf-py-6 vf-mt-6">
        <div class="vf-flex vf-flex-col md:vf-flex-row vf-pb-5">
            <div class="vf-flex vf-flex-col vf-justify-center vf-border-b vf-border-solid vf-pb-4 vf-mb-4 md:vf-pb-0 md:vf-mb-0 md:vf-border-none">
                <div class="vf-text-xl vf-mr-5 vf-ml-7 vf-text-gray-1 vf-font-medium">Thông tin thanh toán</div>
            </div>

            <div class="vf-flex-1"></div>

            <div class="vf-flex vf-flex-row vf-justify-center md:vf-justify-start">
                <div class="vf-flex vf-flex-col vf-px-[30px] vf-border-r vf-border-[#EBEBF0]">
                    <div class="vf-text-xs vf-text-gray-3 vf-mb-2">Ngày đăng ký</div>
                    <div class="vf-text-base vf-font-semibold vf-text-gray-1">
                        {$regdate}
                    </div>
                </div>

                <div class="vf-flex vf-flex-col vf-px-[30px]">
                    <div class="vf-text-xs vf-text-gray-3 vf-mb-2">Ngày hết hạn</div>
                    <div class="vf-text-base vf-font-semibold vf-text-gray-1">
                        {$nextduedate}
                    </div>
                </div>
            </div>
        </div>

        <div class="vf-flex vf-flex-col md:vf-flex-row vf-flex-wrap vf-pt-5 vf-px-7 vf-border-t vf-border-[#EBEBF0] vf-gap-5 md:vf-gap-0">
            {if $firstpaymentamount neq $recurringamount}
                <div class="vf-flex vf-flex-row vf-flex-1">
                    <div class="vf-mr-3"><img
                            src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTgiIGhlaWdodD0iMTkiIHZpZXdCb3g9IjAgMCAxOCAxOSIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTkuMDM1MTYgMTAuOTM3NUM5LjQyMTg4IDEwLjkzNzUgOS43MzgyOCAxMC42NTYyIDkuNzM4MjggMTAuMjM0NFY5Ljg4MjgxQzEwLjUxMTcgOS43MDcwMyAxMS4wNzQyIDkuMjUgMTEuMjE0OCA4LjUxMTcyQzExLjQ2MDkgNi45NjQ4NCAxMC4wMTk1IDYuNTc4MTIgOS4yMTA5NCA2LjMzMjAzTDkuMDM1MTYgNi4yOTY4OEM4LjE5MTQxIDYuMDUwNzggOC4yMjY1NiA1LjkxMDE2IDguMjI2NTYgNS43Njk1M0M4LjI5Njg4IDUuNDg4MjggOC44MjQyMiA1LjQxNzk3IDkuMzE2NDEgNS40ODgyOEM5LjQ5MjE5IDUuNTIzNDQgOS43MDMxMiA1LjU5Mzc1IDkuOTE0MDYgNS42NjQwNkMxMC4zMDA4IDUuODA0NjkgMTAuNjg3NSA1LjU5Mzc1IDEwLjgyODEgNS4yNDIxOUMxMC45MzM2IDQuODU1NDcgMTAuNzU3OCA0LjQ2ODc1IDEwLjM3MTEgNC4zMjgxMkMxMC4xMjUgNC4yNTc4MSA5LjkxNDA2IDQuMTg3NSA5LjczODI4IDQuMTUyMzRWMy43NjU2MkM5LjczODI4IDMuMzc4OTEgOS40MjE4OCAzLjA2MjUgOS4wMzUxNiAzLjA2MjVDOC42NDg0NCAzLjA2MjUgOC4zMzIwMyAzLjM3ODkxIDguMzMyMDMgMy43NjU2MlY0LjExNzE5QzcuNTIzNDQgNC4yOTI5NyA2Ljk5NjA5IDQuNzg1MTYgNi44NTU0NyA1LjUyMzQ0QzYuNjA5MzggNy4wMzUxNiA4LjAxNTYyIDcuNDU3MDMgOC42MTMyOCA3LjYzMjgxTDguNzg5MDYgNy43MDMxMkM5Ljg0Mzc1IDcuOTg0MzggOS44MDg1OSA4LjA4OTg0IDkuNzczNDQgOC4yNjU2MkM5Ljc3MzQ0IDguNTQ2ODggOS4yNDYwOSA4LjYxNzE5IDguNzUzOTEgOC41NDY4OEM4LjUwNzgxIDguNTExNzIgOC4xOTE0MSA4LjM3MTA5IDcuOTEwMTYgOC4zMDA3OEw3Ljc2OTUzIDguMjMwNDdDNy4zODI4MSA4LjA4OTg0IDYuOTk2MDkgOC4zMDA3OCA2Ljg1NTQ3IDguNjUyMzRDNi43NSA5LjAzOTA2IDYuOTI1NzggOS40MjU3OCA3LjI3NzM0IDkuNTY2NDFMNy40MTc5NyA5LjYwMTU2QzcuNjk5MjIgOS43MDcwMyA3Ljk4MDQ3IDkuODEyNSA4LjI5Njg4IDkuODgyODFWMTAuMjM0NEM4LjMzMjAzIDEwLjYyMTEgOC42NDg0NCAxMC45Mzc1IDkuMDM1MTYgMTAuOTM3NVpNMTYuNzM0NCA3LjgwODU5QzE2LjQ1MzEgNy44MDg1OSAxNi4xNzE5IDcuOTE0MDYgMTUuOTYwOSA4LjA4OTg0TDEwLjQ0MTQgMTIuNjk1M0M5LjYzMjgxIDEzLjM2MzMgOC4zMzIwMyAxMy4zNjMzIDcuNTIzNDQgMTIuNjk1M0wyLjAwMzkxIDguMDg5ODRDMS43OTI5NyA3LjkxNDA2IDEuNTExNzIgNy44MDg1OSAxLjIzMDQ3IDcuODA4NTlDMC41MjczNDQgNy44MDg1OSAwIDguMzM1OTQgMCA5LjAzOTA2VjE2QzAgMTcuMjY1NiAwLjk4NDM3NSAxOC4yNSAyLjI1IDE4LjI1SDE1Ljc1QzE2Ljk4MDUgMTguMjUgMTggMTcuMjY1NiAxOCAxNlY5LjAzOTA2QzE4IDguMzM1OTQgMTcuNDM3NSA3LjgwODU5IDE2LjczNDQgNy44MDg1OVpNMTYuMzEyNSAxNkMxNi4zMTI1IDE2LjMxNjQgMTYuMDMxMiAxNi41NjI1IDE1Ljc1IDE2LjU2MjVIMi4yNUMxLjkzMzU5IDE2LjU2MjUgMS42ODc1IDE2LjMxNjQgMS42ODc1IDE2VjkuOTg4MjhMNi40Njg3NSAxMy45OTYxQzcuMTcxODggMTQuNTU4NiA4LjA1MDc4IDE0LjkxMDIgOSAxNC45MTAyQzkuOTE0MDYgMTQuOTEwMiAxMC43OTMgMTQuNTU4NiAxMS40OTYxIDEzLjk5NjFMMTYuMzEyNSA5Ljk4ODI4VjE2Wk0zLjkzNzUgOC4xOTUzMVYyLjIxODc1QzMuOTM3NSAyLjA3ODEyIDQuMDQyOTcgMS45Mzc1IDQuMjE4NzUgMS45Mzc1SDEzLjc4MTJDMTMuOTIxOSAxLjkzNzUgMTQuMDYyNSAyLjA3ODEyIDE0LjA2MjUgMi4yMTg3NVY4LjE5NTMxTDE1LjIyMjcgNy4yMTA5NEMxNS4zOTg0IDcuMTA1NDcgMTUuNTM5MSA3IDE1Ljc1IDYuODk0NTNWMi4yMTg3NUMxNS43NSAxLjE2NDA2IDE0LjgzNTkgMC4yNSAxMy43ODEyIDAuMjVINC4yMTg3NUMzLjEyODkxIDAuMjUgMi4yNSAxLjE2NDA2IDIuMjUgMi4yMTg3NVY2Ljg5NDUzQzIuNDI1NzggNyAyLjU2NjQxIDcuMTA1NDcgMi43NDIxOSA3LjIxMDk0TDMuOTM3NSA4LjE5NTMxWiIgZmlsbD0iIzRGNEY0RiIvPgo8L3N2Zz4K" />
                    </div>
                    <div class="vf-flex vf-flex-row md:vf-flex-col vf-items-center vf-w-full md:vf-w-auto">
                        <div class="vf-text-xs vf-text-gray-3 vf-flex-1 vf-mb-0 md:vf-mb-2">Thanh toán lần đầu</div>
                        <div class="vf-text-base vf-font-semibold vf-text-gray-1">
                            {$firstpaymentamount}
                        </div>
                    </div>
                </div>
            {/if}

            <div class="vf-flex vf-flex-row vf-flex-1">
                <div class="vf-mr-3"><img
                        src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTgiIGhlaWdodD0iMTkiIHZpZXdCb3g9IjAgMCAxOCAxOSIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTkuMDM1MTYgMTAuOTM3NUM5LjQyMTg4IDEwLjkzNzUgOS43MzgyOCAxMC42NTYyIDkuNzM4MjggMTAuMjM0NFY5Ljg4MjgxQzEwLjUxMTcgOS43MDcwMyAxMS4wNzQyIDkuMjUgMTEuMjE0OCA4LjUxMTcyQzExLjQ2MDkgNi45NjQ4NCAxMC4wMTk1IDYuNTc4MTIgOS4yMTA5NCA2LjMzMjAzTDkuMDM1MTYgNi4yOTY4OEM4LjE5MTQxIDYuMDUwNzggOC4yMjY1NiA1LjkxMDE2IDguMjI2NTYgNS43Njk1M0M4LjI5Njg4IDUuNDg4MjggOC44MjQyMiA1LjQxNzk3IDkuMzE2NDEgNS40ODgyOEM5LjQ5MjE5IDUuNTIzNDQgOS43MDMxMiA1LjU5Mzc1IDkuOTE0MDYgNS42NjQwNkMxMC4zMDA4IDUuODA0NjkgMTAuNjg3NSA1LjU5Mzc1IDEwLjgyODEgNS4yNDIxOUMxMC45MzM2IDQuODU1NDcgMTAuNzU3OCA0LjQ2ODc1IDEwLjM3MTEgNC4zMjgxMkMxMC4xMjUgNC4yNTc4MSA5LjkxNDA2IDQuMTg3NSA5LjczODI4IDQuMTUyMzRWMy43NjU2MkM5LjczODI4IDMuMzc4OTEgOS40MjE4OCAzLjA2MjUgOS4wMzUxNiAzLjA2MjVDOC42NDg0NCAzLjA2MjUgOC4zMzIwMyAzLjM3ODkxIDguMzMyMDMgMy43NjU2MlY0LjExNzE5QzcuNTIzNDQgNC4yOTI5NyA2Ljk5NjA5IDQuNzg1MTYgNi44NTU0NyA1LjUyMzQ0QzYuNjA5MzggNy4wMzUxNiA4LjAxNTYyIDcuNDU3MDMgOC42MTMyOCA3LjYzMjgxTDguNzg5MDYgNy43MDMxMkM5Ljg0Mzc1IDcuOTg0MzggOS44MDg1OSA4LjA4OTg0IDkuNzczNDQgOC4yNjU2MkM5Ljc3MzQ0IDguNTQ2ODggOS4yNDYwOSA4LjYxNzE5IDguNzUzOTEgOC41NDY4OEM4LjUwNzgxIDguNTExNzIgOC4xOTE0MSA4LjM3MTA5IDcuOTEwMTYgOC4zMDA3OEw3Ljc2OTUzIDguMjMwNDdDNy4zODI4MSA4LjA4OTg0IDYuOTk2MDkgOC4zMDA3OCA2Ljg1NTQ3IDguNjUyMzRDNi43NSA5LjAzOTA2IDYuOTI1NzggOS40MjU3OCA3LjI3NzM0IDkuNTY2NDFMNy40MTc5NyA5LjYwMTU2QzcuNjk5MjIgOS43MDcwMyA3Ljk4MDQ3IDkuODEyNSA4LjI5Njg4IDkuODgyODFWMTAuMjM0NEM4LjMzMjAzIDEwLjYyMTEgOC42NDg0NCAxMC45Mzc1IDkuMDM1MTYgMTAuOTM3NVpNMTYuNzM0NCA3LjgwODU5QzE2LjQ1MzEgNy44MDg1OSAxNi4xNzE5IDcuOTE0MDYgMTUuOTYwOSA4LjA4OTg0TDEwLjQ0MTQgMTIuNjk1M0M5LjYzMjgxIDEzLjM2MzMgOC4zMzIwMyAxMy4zNjMzIDcuNTIzNDQgMTIuNjk1M0wyLjAwMzkxIDguMDg5ODRDMS43OTI5NyA3LjkxNDA2IDEuNTExNzIgNy44MDg1OSAxLjIzMDQ3IDcuODA4NTlDMC41MjczNDQgNy44MDg1OSAwIDguMzM1OTQgMCA5LjAzOTA2VjE2QzAgMTcuMjY1NiAwLjk4NDM3NSAxOC4yNSAyLjI1IDE4LjI1SDE1Ljc1QzE2Ljk4MDUgMTguMjUgMTggMTcuMjY1NiAxOCAxNlY5LjAzOTA2QzE4IDguMzM1OTQgMTcuNDM3NSA3LjgwODU5IDE2LjczNDQgNy44MDg1OVpNMTYuMzEyNSAxNkMxNi4zMTI1IDE2LjMxNjQgMTYuMDMxMiAxNi41NjI1IDE1Ljc1IDE2LjU2MjVIMi4yNUMxLjkzMzU5IDE2LjU2MjUgMS42ODc1IDE2LjMxNjQgMS42ODc1IDE2VjkuOTg4MjhMNi40Njg3NSAxMy45OTYxQzcuMTcxODggMTQuNTU4NiA4LjA1MDc4IDE0LjkxMDIgOSAxNC45MTAyQzkuOTE0MDYgMTQuOTEwMiAxMC43OTMgMTQuNTU4NiAxMS40OTYxIDEzLjk5NjFMMTYuMzEyNSA5Ljk4ODI4VjE2Wk0zLjkzNzUgOC4xOTUzMVYyLjIxODc1QzMuOTM3NSAyLjA3ODEyIDQuMDQyOTcgMS45Mzc1IDQuMjE4NzUgMS45Mzc1SDEzLjc4MTJDMTMuOTIxOSAxLjkzNzUgMTQuMDYyNSAyLjA3ODEyIDE0LjA2MjUgMi4yMTg3NVY4LjE5NTMxTDE1LjIyMjcgNy4yMTA5NEMxNS4zOTg0IDcuMTA1NDcgMTUuNTM5MSA3IDE1Ljc1IDYuODk0NTNWMi4yMTg3NUMxNS43NSAxLjE2NDA2IDE0LjgzNTkgMC4yNSAxMy43ODEyIDAuMjVINC4yMTg3NUMzLjEyODkxIDAuMjUgMi4yNSAxLjE2NDA2IDIuMjUgMi4yMTg3NVY2Ljg5NDUzQzIuNDI1NzggNyAyLjU2NjQxIDcuMTA1NDcgMi43NDIxOSA3LjIxMDk0TDMuOTM3NSA4LjE5NTMxWiIgZmlsbD0iIzRGNEY0RiIvPgo8L3N2Zz4K" />
                </div>
                <div class="vf-flex vf-flex-row md:vf-flex-col vf-items-center vf-w-full md:vf-w-auto">
                    <div class="vf-text-xs vf-text-gray-3 vf-flex-1 vf-mb-0 md:vf-mb-2">{lang key='orderbillingcycle'}</div>
                    <div class="vf-text-base vf-font-semibold vf-text-gray-1">
                        {$billingcycle}
                    </div>
                </div>
            </div>

            {if $billingcycle != "{lang key='orderpaymenttermonetime'}" && $billingcycle != "{lang key='orderfree'}"}
                <div class="vf-flex vf-flex-row vf-flex-1">
                    <div class="vf-mr-3"><img
                            src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTgiIGhlaWdodD0iMTciIHZpZXdCb3g9IjAgMCAxOCAxNyIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTE2LjkxMDIgMC40NDUzMTJDMTYuNTkzOCAwLjMzOTg0NCAxNi4yMDcgMC40MTAxNTYgMTUuOTk2MSAwLjY1NjI1TDE0LjIwMzEgMi40MTQwNkMxMi43OTY5IDEuMTQ4NDQgMTAuOTY4OCAwLjM3NSA5IDAuMzc1QzUuNTE5NTMgMC4zNzUgMi4zOTA2MiAyLjczMDQ3IDEuNDA2MjUgNi4wNzAzMUMxLjMwMDc4IDYuNDkyMTkgMS41NDY4OCA2Ljk4NDM4IDIuMDAzOTEgNy4wODk4NEMyLjQ2MDk0IDcuMjMwNDcgMi45MTc5NyA2Ljk4NDM4IDMuMDIzNDQgNi41MjczNEMzLjc5Njg4IDMuOTI1NzggNi4yNTc4MSAyLjA2MjUgOSAyLjA2MjVDMTAuNTExNyAyLjA2MjUgMTEuOTE4IDIuNjYwMTYgMTMuMDA3OCAzLjYwOTM4TDEwLjkzMzYgNS43MTg3NUMxMC42ODc1IDUuOTI5NjkgMTAuNjE3MiA2LjMxNjQxIDEwLjcyMjcgNi42MzI4MUMxMC44NjMzIDYuOTQ5MjIgMTEuMTc5NyA3LjEyNSAxMS41MzEyIDcuMTI1SDE2LjU1ODZDMTcuMDUwOCA3LjEyNSAxNy40Mzc1IDYuNzczNDQgMTcuNDM3NSA2LjI4MTI1VjEuMjE4NzVDMTcuNDM3NSAwLjkwMjM0NCAxNy4yMjY2IDAuNTg1OTM4IDE2LjkxMDIgMC40NDUzMTJaTTE1Ljk2MDkgOS40MTAxNkMxNS41MDM5IDkuMjY5NTMgMTUuMDQ2OSA5LjUxNTYyIDE0LjkwNjIgOS45NzI2NkMxNC4xNjggMTIuNjA5NCAxMS43MDcgMTQuNDM3NSA4Ljk2NDg0IDE0LjQzNzVDNy40MTc5NyAxNC40Mzc1IDYuMDExNzIgMTMuODc1IDQuOTIxODggMTIuOTI1OEw3LjAzMTI1IDEwLjgxNjRDNy4yNDIxOSAxMC42MDU1IDcuMzEyNSAxMC4yMTg4IDcuMjA3MDMgOS45MDIzNEM3LjEwMTU2IDkuNTg1OTQgNi43ODUxNiA5LjM3NSA2LjQzMzU5IDkuMzc1SDEuNDA2MjVDMC45MTQwNjIgOS4zNzUgMC41MjczNDQgOS43NjE3MiAwLjUyNzM0NCAxMC4yMTg4VjE1LjI4MTJDMC41MjczNDQgMTUuNjMyOCAwLjczODI4MSAxNS45NDkyIDEuMDU0NjkgMTYuMDg5OEMxLjE2MDE2IDE2LjEyNSAxLjI2NTYyIDE2LjEyNSAxLjM3MTA5IDE2LjEyNUMxLjYxNzE5IDE2LjEyNSAxLjgyODEyIDE2LjA1NDcgMS45Njg3NSAxNS44Nzg5TDMuNzYxNzIgMTQuMTIxMUM1LjE2Nzk3IDE1LjM4NjcgNi45OTYwOSAxNi4xMjUgOC45NjQ4NCAxNi4xMjVDMTIuNDQ1MyAxNi4xMjUgMTUuNTM5MSAxMy44MDQ3IDE2LjUyMzQgMTAuNDY0OEMxNi42NjQxIDEwLjAwNzggMTYuNDE4IDkuNTUwNzggMTUuOTYwOSA5LjQxMDE2WiIgZmlsbD0iIzRGNEY0RiIvPgo8L3N2Zz4K" />
                    </div>
                    <div class="vf-flex vf-flex-row md:vf-flex-col vf-w-full md:vf-w-auto">
                        <div class="vf-text-xs vf-text-gray-3 vf-flex-1 vf-mb-0 md:vf-mb-2">Phí gia hạn tiếp theo</div>
                        <div class="vf-text-base vf-font-semibold vf-text-gray-1">
                            {$recurringamount}
                        </div>
                    </div>
                </div>
            {/if}

            {if $quantitySupported && $quantity > 1}
                <div class="vf-flex vf-flex-row md:vf-flex-col vf-items-center vf-w-full md:vf-w-auto">
                    <div class="vf-text-xs vf-text-gray-3 vf-flex-1 vf-mb-0 md:vf-mb-2">{lang key='quantity'}</div>
                    <div class="vf-text-base vf-font-semibold vf-text-gray-1">
                        {$quantity}
                    </div>
                </div>
            {/if}

            <div class="vf-flex vf-flex-row">
                <div class="vf-mr-3"><img
                        src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjEiIGhlaWdodD0iMTciIHZpZXdCb3g9IjAgMCAyMSAxNyIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTUuOTA2MjUgMTEuMDYyNUM2LjM2MzI4IDExLjA2MjUgNi43NSAxMS40NDkyIDYuNzUgMTEuOTA2MkM2Ljc1IDEyLjM5ODQgNi4zNjMyOCAxMi43NSA1LjkwNjI1IDEyLjc1SDQuMjE4NzVDMy43MjY1NiAxMi43NSAzLjM3NSAxMi4zOTg0IDMuMzc1IDExLjkwNjJDMy4zNzUgMTEuNDQ5MiAzLjcyNjU2IDExLjA2MjUgNC4yMTg3NSAxMS4wNjI1SDUuOTA2MjVaTTEyLjY1NjIgMTEuMDYyNUMxMy4xMTMzIDExLjA2MjUgMTMuNSAxMS40NDkyIDEzLjUgMTEuOTA2MkMxMy41IDEyLjM5ODQgMTMuMTEzMyAxMi43NSAxMi42NTYyIDEyLjc1SDguNzE4NzVDOC4yMjY1NiAxMi43NSA3Ljg3NSAxMi4zOTg0IDcuODc1IDExLjkwNjJDNy44NzUgMTEuNDQ5MiA4LjIyNjU2IDExLjA2MjUgOC43MTg3NSAxMS4wNjI1SDEyLjY1NjJaTTE4IDAuMzc1QzE5LjIzMDUgMC4zNzUgMjAuMjUgMS4zOTQ1MyAyMC4yNSAyLjYyNVYxMy44NzVDMjAuMjUgMTUuMTQwNiAxOS4yMzA1IDE2LjEyNSAxOCAxNi4xMjVIMi4yNUMwLjk4NDM3NSAxNi4xMjUgMCAxNS4xNDA2IDAgMTMuODc1VjIuNjI1QzAgMS4zOTQ1MyAwLjk4NDM3NSAwLjM3NSAyLjI1IDAuMzc1SDE4Wk0xOCAyLjA2MjVIMi4yNUMxLjkzMzU5IDIuMDYyNSAxLjY4NzUgMi4zNDM3NSAxLjY4NzUgMi42MjVWMy43NUgxOC41NjI1VjIuNjI1QzE4LjU2MjUgMi4zNDM3NSAxOC4yODEyIDIuMDYyNSAxOCAyLjA2MjVaTTE4LjU2MjUgNy4xMjVIMS42ODc1VjEzLjg3NUMxLjY4NzUgMTQuMTkxNCAxLjkzMzU5IDE0LjQzNzUgMi4yNSAxNC40Mzc1SDE4QzE4LjI4MTIgMTQuNDM3NSAxOC41NjI1IDE0LjE5MTQgMTguNTYyNSAxMy44NzVWNy4xMjVaIiBmaWxsPSIjNEY0RjRGIi8+Cjwvc3ZnPgo=" />
                </div>
                <div class="vf-flex vf-flex-row md:vf-flex-col vf-items-center vf-w-full md:vf-w-auto">
                    <div class="vf-text-xs vf-text-gray-3 vf-flex-1 vf-mb-0 md:vf-mb-2">Phương thức thanh toán</div>
                    <div class="vf-text-base vf-font-semibold vf-text-gray-1">
                        {$paymentmethod}
                    </div>
                </div>
            </div>

            {if $suspendreason}
                <div class="vf-flex vf-flex-row md:vf-flex-col vf-items-center vf-w-full md:vf-w-auto">
                    <div class="vf-text-xs vf-text-gray-3 vf-flex-1 vf-mb-0 md:vf-mb-2">{lang key='suspendreason'}</div>
                    <div class="vf-text-base vf-font-semibold vf-text-gray-1">
                        {$suspendreason}
                    </div>
                </div>
            {/if}
        </div>
    </div>
</div>

<script>
    Helper.initGraphData({$id},'{$regdate}');

    jQuery(document).ready(function() {
        jQuery('.vnx-list-group-item').click(function(e) {
            jQuery(this).addClass('disabled');
            jQuery(this).find('i').removeClass('v-hidden').addClass('fa-spinner fa-spin');
        });
    });
</script>