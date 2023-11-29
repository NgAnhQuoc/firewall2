<link href="{$WEB_ROOT}/modules/servers/vietnix_firewall2/templates/css/app.css" rel="stylesheet" type="text/css" />
<script src="{$WEB_ROOT}/modules/servers/vietnix_firewall2/templates/js/app.js"></script>

<!-- START: header -->
{include file="modules/servers/vietnix_firewall2/templates/service-details/header.tpl" head_title="Xem Graph chi tiết"}
<!-- END: header -->

<!-- START: body -->
<div class="vnx-main">
  <div class="vnx-container vf-flex vf-flex-col vf-h-full" id="fw-graph-detail">
    <div class="vf-flex vf-flex-col vf-bg-white vf-rounded vf-shadow-card vf-py-6 vf-mt-6">
      <div class="vf-text-base vf-mr-5 vf-ml-7 vf-mb-6 vf-text-gray-1 vf-font-medium">Tổng quan</div>
      <div class="vf-flex vf-flex-col md:vf-flex-row">
        <div class="vf-flex-1 vf-flex vf-flex-col vf-px-6 md:vf-items-start">
          <div class="vf-flex vf-flex-row">
            <div class="vf-text-lg vf-font-normal vf-mr-3"><i class="far fa-cube"></i></div>
            <div class="vf-flex vf-flex-col">
              <div class="vf-text-sm vf-text-gray-3 vf-mb-2">Gói dịch vụ</div>
              <div class="vf-text-sm vf-font-medium vf-text-gray-1">Firewal 2</div>
            </div>
          </div>
        </div>
        <div class="vf-flex-1 vf-flex vf-flex-col vf-px-6 vf-border-x vf-border-[#EBEBF0] md:vf-items-center">
          <div class="vf-flex vf-flex-row">
            <div class="vf-text-lg vf-font-normal vf-mr-3"><i class="far fa-globe"></i></div>
            <div class="vf-flex vf-flex-col">
              <div class="vf-text-sm vf-text-gray-3 vf-mb-2">Hostname</div>
              <div class="vf-text-sm vf-text-primary">Firewall.web.example.vn</div>
            </div>
          </div>
        </div>
        <div class="vf-flex-1 vf-flex vf-flex-col vf-px-6 md:vf-items-end">
          <div class="vf-flex vf-flex-row">
            <div class="vf-text-lg vf-font-normal vf-mr-3"><i class="far fa-list-alt"></i></div>
            <div class="vf-flex vf-flex-col">
              <div class="vf-text-sm vf-text-gray-3 vf-mb-2">Số lượng domain</div>
              <div class="vf-text-sm vf-font-medium vf-text-gray-1">35</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <form action="" method="POST">
      <div class="vf-flex vf-flex-col vf-bg-white vf-rounded vf-shadow-card vf-pt-6 vf-mt-6">
        <div class="vf-flex vf-flex-row">
          <div class="vf-text-base vf-mr-5 vf-ml-7 vf-text-gray-1 vf-font-medium">Graph Overview</div>
          <div class="vf-flex-1"></div>
          <div class="vf-flex vf-flex-row vf-pr-6">
            <div id="select-range" class="vnx-select-box vf-h-10">
              <select v-model="timerange" name="timerange" id="timerange" class="form-control vf-min-w-[160px] vf-h-[38px] vf-rounded vf-shadow-card vf-leading-normal focus:vf-bg-transparent">
                <option class="vf-text-gray-2" value="3monthsago">3 tháng gần nhất</option>
                <option class="vf-text-gray-2" value="30daysago">30 ngày gần nhất</option>
                <option class="vf-text-gray-2" value="7daysago">7 ngày gần nhất</option>
                <option class="vf-text-gray-2" value="yesterday">Hôm qua</option>
                <option class="vf-text-gray-2" value="today">Hôm nay</option>
                <option class="vf-text-gray-2" value="custom">Tùy chỉnh</option>
              </select>
            </div>

            <div id="filter-range" class="vf-flex-1 vf-ml-3">
              <input type="date" v-model="filterdatestart" id="datestart" name="datestart" class="vf-rounded vf-shadow-card">
              <i class="fas fa-long-arrow-alt-right vf-mx-2"></i>
              <input type="date" v-model="filterdateend" id="dateend" name="dateend" class="vf-rounded vf-shadow-card">
            </div>

            <div id="select-domains" class="vnx-select-box vf-h-10 vf-ml-3">
              <select v-model="domain" name="domain" id="domain" class="form-control vf-text-gray-1 vf-min-w-[160px] vf-h-[38px] vf-rounded vf-shadow-card vf-leading-normal focus:vf-bg-transparent">
                <option class="vf-text-gray-2" value="all" selected>Tất cả domain</option>
                {foreach from=$listvhost item=vhost key=key}
                  <option class="vf-text-gray-2" value="{$vhost.vhost}">{$vhost.vhost}</option>
                {/foreach}
              </select>
            </div>
          </div>

        </div>

        <div class="vf-flex-1 vf-mr-5 vf-ml-7 vf-my-2">
          <div id="fwchart"></div>
        </div>
      </div>
    </form>

    <div class="vf-flex-1"></div>
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

{* {debug} *}

<script>
  Helper.initGraphDetail({$id}, {$chart_data});
</script>