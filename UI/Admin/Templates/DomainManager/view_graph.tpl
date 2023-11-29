<link href="../modules/servers/vietnix_firewall2/UI/Public/css/admin.css" rel="stylesheet" type="text/css" />
<script src="../modules/servers/vietnix_firewall2/UI/Public/js/admin.js"></script>


<!-- START: body -->
<div class="vnx-main">
  <div class="vnx-container vf-flex vf-flex-col vf-h-full" id="fw-graph-detail">
    <form action="" method="POST">
      <div class="vf-flex vf-flex-col vf-bg-white vf-rounded vf-shadow-card vf-pt-6 vf-mt-6">
        <div class="vf-flex vf-flex-row">
          <div class="vf-text-base vf-mr-5 vf-ml-7 vf-text-gray-1 vf-font-medium">Graph Overview</div>
          <div class="vf-flex-1"></div>
          <div class="vf-flex vf-flex-row vf-pr-6">
            <div id="select-range" class="vnx-select-box vf-h-10">
              <select v-model="timerange" name="timerange" id="timerange"
                class="form-control vf-min-w-[160px] vf-h-[38px] vf-rounded vf-shadow-card vf-leading-normal focus:vf-bg-transparent">
                <option class="vf-text-gray-2" value="3monthsago">3 tháng gần nhất</option>
                <option class="vf-text-gray-2" value="30daysago">30 ngày gần nhất</option>
                <option class="vf-text-gray-2" value="7daysago">7 ngày gần nhất</option>
                <option class="vf-text-gray-2" value="yesterday">Hôm qua</option>
                <option class="vf-text-gray-2" value="today">Hôm nay</option>
                <option class="vf-text-gray-2" value="custom">Tùy chỉnh</option>
              </select>
            </div>

            <div id="filter-range" class="vf-flex-1 vf-ml-3">
              <input type="date" v-model="filterdatestart" id="datestart" name="datestart"
                class="vf-rounded vf-shadow-card">
              <i class="fas fa-long-arrow-alt-right vf-mx-2"></i>
              <input type="date" v-model="filterdateend" id="dateend" name="dateend" class="vf-rounded vf-shadow-card">
            </div>

            <div id="select-domains" class="vnx-select-box vf-h-10 vf-ml-3">
              <select v-model="domain" name="domain" id="domain"
                class="form-control vf-text-gray-1 vf-min-w-[160px] vf-h-[38px] vf-rounded vf-shadow-card vf-leading-normal focus:vf-bg-transparent">
                <option class="vf-text-gray-2" value="all" selected>Tất cả domain</option>
                {foreach from=$listvhost item=vhost key=key}
                  <option class="vf-text-gray-2" value="{$vhost.vhost}">{$vhost.vhost}</option>
                {/foreach}
              </select>
            </div>
          </div>
        </div>

        <div class="vf-flex-1 vf-mr-5 vf-ml-7 vf-my-2">
          <div id="fwchart" class="vf-center vf-flex-col">
            <div><img class="vf-w-12 vf-h-12" src="..//modules/servers/vietnix_firewall2/UI/Public/img/loading.gif" />
            </div>
            <div class="vf-text-sm vf-text-gray-1 vf-mt-2">Đang tải dữ liệu ...</div>
          </div>
        </div>
      </div>
    </form>

    <div class="vf-flex-1"></div>
  </div>
</div>
<!-- END: body -->

<script>
  Helper.initGraphDetail({$prams.id}, '{$prams.dedicatedip}');
</script>