<link href="{$WEB_ROOT}/modules/servers/vietnix_firewall2/UI/Public/css/client.css" rel="stylesheet" type="text/css" />
<script src="{$WEB_ROOT}/modules/servers/vietnix_firewall2/UI/Public/js/client.js"></script>

<!-- START: header -->
{include file="modules/servers/vietnix_firewall2/UI/Client/templates/service-details/header.tpl" head_title="Xem Logs chi tiết"}
<!-- END: header -->

<!-- START: body -->
<div class="vnx-main">
  <div class="vnx-container vf-flex vf-flex-col vf-h-full" id="vnx-fwlogs-table">
    <div class="vf-flex vf-flex-col vf-bg-white vf-rounded vf-shadow-card vf-py-6 vf-mt-6">
      <div class="vf-text-base vf-mr-5 vf-ml-7 vf-mb-6 vf-text-gray-1 vf-font-medium">Tổng quan</div>
      <div class="vf-flex vf-flex-col md:vf-flex-row">
        <div class="vf-flex-1 vf-flex vf-flex-col vf-px-6 vf-mb-4 md:vf-items-start">
          <div class="vf-flex vf-flex-row">
            <div class="vf-text-lg vf-font-normal vf-mr-3"><i class="far fa-cube"></i></div>
            <div class="vf-flex vf-flex-col">
              <div class="vf-text-sm vf-text-gray-3 vf-mb-2">{$groupname}</div>
              <div class="vf-text-sm vf-font-medium vf-text-gray-1">{$product}</div>
            </div>
          </div>
        </div>
        <div class="vf-flex-1 vf-flex vf-flex-col vf-px-6 vf-mb-4 md:vf-border-x vf-border-[#EBEBF0] md:vf-items-center">
          <div class="vf-flex vf-flex-row">
            <div class="vf-text-lg vf-font-normal vf-mr-3"><i class="far fa-globe"></i></div>
            <div class="vf-flex vf-flex-col">
              <div class="vf-text-sm vf-text-gray-3 vf-mb-2">Hostname</div>
              <div class="vf-text-sm vf-text-primary">{$domain}</div>
            </div>
          </div>
        </div>
        <div class="vf-flex-1 vf-flex vf-flex-col vf-px-6 vf-mb-4 md:vf-items-end">
          <div class="vf-flex vf-flex-row">
            <div class="vf-text-lg vf-font-normal vf-mr-3"><i class="far fa-list-alt"></i></div>
            <div class="vf-flex vf-flex-col">
              <div class="vf-text-sm vf-text-gray-3 vf-mb-2">Số lượng domain</div>
              <div class="vf-text-sm vf-font-medium vf-text-gray-1">
                {if !$listvhost}
                  0
                {else}
                  {$listvhost|count}
                {/if}</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <form action="" method="POST">
      <div class="vf-flex vf-flex-col vf-bg-white vf-rounded vf-shadow-card vf-pt-6 vf-mt-6">
        <div class="vf-flex vf-flex-col md:vf-flex-row">
          <div class="vf-text-base vf-mx-3 md:vf-mr-5 md:vf-ml-7 vf-text-gray-1 vf-font-medium">Logs chi tiết</div>
          <div class="md:vf-flex-1"></div>
          <div class="vf-flex vf-flex-col md:vf-flex-row vf-mx-3 vf-my-3 md:vf-mt-0 md:vf-pr-6">
            <div id="select-range" class="vnx-select-box vf-h-10">
              <select v-model="timerange" name="timerange" id="timerange" class="form-control vf-min-w-[160px] vf-h-[38px] vf-rounded vf-shadow-card vf-leading-normal focus:vf-bg-transparent">
                <option class="vf-text-gray-2" value="3hourago">3 giờ gần đây</option>
                <option class="vf-text-gray-2" value="6hourago">6 giờ gần đây</option>
                <option class="vf-text-gray-2" value="12hourago">12 giờ gần đây</option>
                <option class="vf-text-gray-2" value="24hourago">24 giờ qua</option>
              </select>
            </div>

            <div id="select-domains" class="vnx-select-box vf-h-10 vf-mt-3 md:vf-mt-0 md:vf-ml-3">
              <select v-model="domain" name="domain" id="domain" class="form-control vf-text-gray-1 vf-min-w-[160px] vf-h-[38px] vf-rounded vf-shadow-card vf-leading-normal focus:vf-bg-transparent">
                <option class="vf-text-gray-2" value="all" selected>Tất cả domain</option>
                {foreach from=$listvhost item=vhost key=key}
                  <option class="vf-text-gray-2" value="{$vhost.vhost}">{$vhost.vhost}</option>
                {/foreach}
              </select>
            </div>
          </div>

        </div>
      </div>
    </form>

    <div class="vf-flex-1 vf-flex vf-flex-col vf-relative">
      <div id="vnx-loading-logs" class="vf-flex-1 vf-mt-6 vf-text-sm">
        <i class="fas fa-spinner fa-spin vf-mr-2 vf-center vf-text-primary"></i>
        <div class="vf-text-sm vf-text-primary vf-mt-2 vf-text-center">Đang tải dữ liệu ...</div>
      </div>
      <textarea id="fw_logs" name="fw_logs" class="vf-flex-1 vf-resize-none vf-overscroll-y-auto vf-text-white vf-w-full vf-bg-[#013A52] vf-rounded-b-[3px] vf-p-3 "></textarea>

      <div class="vf-mt-7">
        <div class="footer vf-flex-1 vf-w-full">
          <div class="vf-py-3 vf-text-sm vf-text-gray-400 vf-items-center text-footer">
            Copyright © 2022 Vietnix JSC. All Rights Reserved.
          </div>
        </div>
      </div>
    </div>
  </div>
  <!-- END: body -->

  <script>
    Helper.initLogsDetail({$id}, '{$dedicatedip}');
    window.addEventListener("DOMContentLoaded", (event) => {
      jQuery('#fw_logs').hide();
      jQuery('#timerange, #domain').change(function() {
        jQuery('#fw_logs').hide();
        jQuery('#vnx-loading-logs').show();
      });
    });
</script>