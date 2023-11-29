<link href="../modules/servers/vietnix_firewall2/UI/Public/css/admin.css" rel="stylesheet" type="text/css" />
<script src="../modules/servers/vietnix_firewall2/UI/Public/js/admin.js"></script>


<!-- START: body -->
<div class="vnx-main">
  <div class="vnx-container vf-flex vf-flex-col vf-h-full" id="vnx-fwlogs-table">
    <form action="" method="POST">
      <div class="vf-flex vf-flex-col vf-bg-white vf-rounded vf-shadow-card vf-py-6 vf-mt-6">
        <div class="vf-flex vf-flex-row">
          <div class="vf-text-3xl vf-mr-5 vf-ml-7 vf-mb-6 vf-text-gray-1 vf-font-medium">Logs chi tiết</div>
          <div class="vf-flex-1"></div>
          <div class="vf-flex vf-flex-row vf-pr-6">
            <div id="select-range" class="vnx-select-box vf-h-10">
              <select v-model="timerange" name="timerange" id="timerange"
                class="form-control vf-min-w-[160px] vf-h-[38px] vf-rounded vf-shadow-card vf-leading-normal focus:vf-bg-transparent">
                <option class="vf-text-gray-2" value="3hourago">3 giờ gần đây</option>
                <option class="vf-text-gray-2" value="6hourago">6 giờ gần đây</option>
                <option class="vf-text-gray-2" value="12hourago">12 giờ gần đây</option>
                <option class="vf-text-gray-2" value="24hourago">24 giờ qua</option>
              </select>
            </div>

            <div id="select-domains" class="vnx-select-box vf-h-10 vf-ml-3">
              <select v-model="domain" name="fw_domain" id="fw_domain"
                class="form-control vf-text-gray-1 vf-min-w-[160px] vf-h-[38px] vf-rounded vf-shadow-card vf-leading-normal focus:vf-bg-transparent">
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

    <div class="vf-flex-1 vf-mt-2 vf-flex vf-flex-col vf-relative" id="fw_view_logs">
      <textarea v-if="logData && logData != 'none'" :value="logData" id="fw_logs" name="fw_logs" rows="20"
        class="vf-flex-1 vf-resize-none vf-overscroll-y-auto vf-text-white vf-w-full vf-bg-[#013A52] vf-rounded-[3px] vf-p-3 ">
      </textarea>

      <div v-else-if="logData == 'none'" class="vf-center vf-py-8 vf-text-gray-2" style="border-radius: 0 0 6px 6px;">
        Không có dữ liệu
      </div>

      <div v-else class="vf-flex-1 vf-mr-5 vf-ml-7 vf-my-2 vf-center vf-flex vf-flex-col">
        <div><img class="vf-w-12 vf-h-12" src="../modules/servers/vietnix_firewall2/UI/Public/img/loading.gif" />
        </div>
        <div class="vf-text-xl vf-text-gray-1 vf-mt-2">Đang tải dữ liệu ...</div>
      </div>
    </div>
  </div>
</div>
<!-- END: body -->

<script>
  Helper.initLogsDetail({$params.serviceid}, '{$params.model.dedicatedip}');

  function copyToClipboard(element) {
    var copyText = document.getElementById(element);
    copyText.select();
    copyText.setSelectionRange(0, 99999); /* For mobile devices */
    document.execCommand("copy");
    alert("Copied the text to clipboard.");
  }
</script>