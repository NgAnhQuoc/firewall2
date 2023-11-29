<link href="{$WEB_ROOT}/modules/servers/vietnix_firewall2/templates/css/app.css" rel="stylesheet" type="text/css" />
<script src="{$WEB_ROOT}/modules/servers/vietnix_firewall2/templates/js/app.js"></script>

<!-- START: header -->
{include file="modules/servers/vietnix_firewall2/templates/service-details/header.tpl" head_title="Cấu hình tên miền"}
<!-- END: header -->
{debug}
<!-- START: body -->
<div class="vnx-main">
  <div class="vnx-container vf-flex vf-flex-col vf-h-full" id="vnx-fw-configdomain-table">

    {if $rs_add_domain['success'] == 'true'}
      {include file="modules/servers/vietnix_firewall2/templates/service-details/alert.tpl" type='success' title="Thêm domain thành công"}
    {elseif $rs_add_domain['result']['messages']}
      {include file="modules/servers/vietnix_firewall2/templates/service-details/alert.tpl" type='success' title=$rs_del_domain['result']['messages'][0]}
    {/if}
    {if $rs_update_domain['success'] == 'true'}
      {include file="modules/servers/vietnix_firewall2/templates/service-details/alert.tpl" type='success' title="Cập nhật domain thành công"}
    {elseif $rs_update_domain['result']['messages']}
      {include file="modules/servers/vietnix_firewall2/templates/service-details/alert.tpl" type='success' title=$rs_del_domain['result']['messages'][0]}
    {/if}
    {if $rs_del_domain['success'] == 'true'}
      {include file="modules/servers/vietnix_firewall2/templates/service-details/alert.tpl" type='success' title="Xoá domain thành công"}
    {elseif $rs_del_domain['result']['messages']}
      {include file="modules/servers/vietnix_firewall2/templates/service-details/alert.tpl" type='success' title=$rs_del_domain['result']['messages'][0]}
    {/if}

    <div class="vf-flex vf-flex-col vf-bg-white vf-rounded vf-shadow-card vf-py-6 vf-mt-6">
      <div class="vf-text-base vf-mr-5 vf-ml-7 vf-mb-6 vf-text-gray-1 vf-font-medium">Tổng quan</div>
      <div class="vf-flex vf-flex-col md:vf-flex-row">
        <div class="vf-flex-1 vf-flex vf-flex-col vf-px-6 md:vf-items-start">
          <div class="vf-flex vf-flex-row">
            <div class="vf-text-lg vf-font-normal vf-mr-3"><i class="far fa-cube"></i></div>
            <div class="vf-flex vf-flex-col">
              <div class="vf-text-sm vf-text-gray-3 vf-mb-2">{$groupname}</div>
              <div class="vf-text-sm vf-font-medium vf-text-gray-1">{$product}</div>
            </div>
          </div>
        </div>
        <div class="vf-flex-1 vf-flex vf-flex-col vf-px-6 vf-border-x vf-border-[#EBEBF0] md:vf-items-center">
          <div class="vf-flex vf-flex-row">
            <div class="vf-text-lg vf-font-normal vf-mr-3"><i class="far fa-globe"></i></div>
            <div class="vf-flex vf-flex-col">
              <div class="vf-text-sm vf-text-gray-3 vf-mb-2">Hostname</div>
              <div class="vf-text-sm vf-text-primary">{$domain}</div>
            </div>
          </div>
        </div>
        <div class="vf-flex-1 vf-flex vf-flex-col vf-px-6 md:vf-items-end">
          <div class="vf-flex vf-flex-row">
            <div class="vf-text-lg vf-font-normal vf-mr-3"><i class="far fa-list-alt"></i></div>
            <div class="vf-flex vf-flex-col">
              <div class="vf-text-sm vf-text-gray-3 vf-mb-2">Số lượng domain</div>
              <div class="vf-text-sm vf-font-medium vf-text-gray-1">
                {if !$listvhost}
                  0
                {else}
                  {$listvhost|count}
                {/if}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="vf-flex vf-flex-col vf-bg-white vf-rounded vf-shadow-card vf-pt-6 vf-mt-6">
      <div class="vf-flex vf-flex-row">
        <div class="vf-text-base vf-mr-5 vf-ml-7 vf-mb-6 vf-text-gray-1 vf-font-medium">Danh sách tên miền</div>
        <div class="vf-flex-1"></div>
        <div class="vf-px-6">
          <div class="btnVfAddDomain vf-px-4 vf-py-2 vf-bg-primary vf-text-white vf-text-sm vf-rounded vf-cursor-pointer">
            <i class="fas fa-plus fa-sm"></i>
            <span>Thêm tên miền</span>
          </div>
        </div>
      </div>

      <div class="vnx-table-firewallweb-list-domain vnx__table vf-border-none" id="vnx-fw-configdomain-table">
        <div class="vnx__table--header vf-hidden md:vf-flex vf-bg-transparent vf-border-t-0 vf-border-b-[1px] vf-px-7 vf-text-[14px] vf-text-gray-3">
          <div class="vnx__table--col vf-flex-1">Domain</div>
          <div class="vnx__table--col vf-flex-1">Backend</div>
          <div class="vnx__table--col vf-flex-1">SSL</div>
          <div class="vnx__table--col vf-w-40 vf-center">Force SSL</div>
          <div class="vnx__table--col vf-w-40 vf-text-right"></div>
        </div>

        <div class="vnx__table--body vf-hidden md:vf-block vf-text-gray-1">
          {if !$listvhost}
            <div class="vf-center vf-py-8 vf-text-gray-2" style="border-radius: 0 0 6px 6px;">
              Không có domain nào
            </div>
          {else}
            {foreach from=$listvhost item=vhost key=key}
              <div id="foo-{$key}" class="vf-px-7 vf-border-b vf-border-[#EBEBF0] vf-cursor-pointer vnx__table--row">
                <div class="vnx__table--col vf-flex-1">
                  <div class="vf-flex vf-flex-row vf-text-sm">
                    <div class="vf-flex vf-items-center vf-justify-center">
                      <!-- toggle -->
                      <div class="vf-relative">
                        <!-- line -->
                        <div class="vf-block vf-bg-primary vf-w-6 vf-h-4 vf-rounded-full"></div>
                        <!-- dot -->
                        <div class="dot vf-absolute vf-right-[2px] vf-top-[2px] vf-bg-white vf-w-3 vf-h-3 vf-rounded-full vf-transition"></div>
                      </div>
                      <!-- toggle -->
                    </div>
                    <div class="vf-flex-1 vf-ml-2">{$vhost.vhost}</div>
                  </div>
                </div>

                <div class="vnx__table--col vf-flex-1">
                  <div class="vf-text-sm">
                    {$vhost.origin}
                  </div>
                </div>

                <div class="vnx__table--col vf-flex-1">
                  <select class="slVfAddDmain vf-rounded vf-border vf-border-[#EBEBF0] vf-px-2" style="min-width: 160px; height: 38px; line-height: normal;">
                    <option {if 'no data' == $vhost.sslmode}selected{/if}>&#9679; None</option>
                    <option>&#9679; Flexible</option>
                    <option>&#9679; Full</option>
                  </select>
                </div>

                <div class="vnx__table--col vf-w-40 vf-flex vf-center">
                  <div class="vf-relative">
                    <input type="checkbox" class="vf-sr-only vf-border" {if true == $vhost.sslredirect}checked{/if}>
                    <div class="vf-block vf-bg-primary vf-w-6 vf-h-4 vf-rounded-full"></div>
                    <div class="dot vf-absolute vf-left-[2px] vf-top-[2px] vf-bg-white vf-w-3 vf-h-3 vf-rounded-full vf-transition"></div>
                  </div>
                </div>

                <div class="vnx__table--col vf-w-40 vf-text-right vf-flex vf-items-end vf-justify-end">
                  <button class="btnVfDeleteDomain vf-w-8 vf-h-8 vf-center vf-border vf-rounded vf-text-red-500 vf-border-red-500 vf-bg-white vf-mr-2" data-value="{$vhost.vhost}">
                    <i class="far fa-trash"></i>
                  </button>
                  <button class="btnVfEditDomain vf-center vf-px-[20px] vf-py-[7px] vf-border vf-rounded vf-text-gray-1 vf-border-[#EBEBF0] vf-bg-white" domain-value="{$vhost.vhost}" backend-value="{$vhost.origin}">
                    Edit
                  </button>
                </div>
              </div>
            {/foreach}
          {/if}

        </div>
      </div>
    </div>

    {* Paginations *}
    {include file="modules/servers/vietnix_firewall2/templates/service-details/paginations.tpl"}
    {* /Paginations *}

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

{* Popup Add Domain *}
<div id="modalVfAddDomain" style="display: none;" class="vf-z-[999] vf-opacity-0 vf-pointer-events-none vf-absolute vf-w-full vf-h-full vf-top-0 vf-left-0 vf-items-center vf-justify-center vf-delay-75 vf-duration-300 vf-ease-in-out">
  <div class="vf-absolute vf-w-full vf-h-full vf-bg-gray-900 vf-opacity-60 vf-pointer-events-auto"></div>
  <div class=" vf-bg-white vf-max-w-full vf-rounded-lg vf-shadow-lg vf-relative vf-mx-3">
    <div class="vf-relative vf-w-full md:vf-w-[640px] vf-py-6 vf-max-h-screen vf-overflow-y-auto vf-pointer-events-auto">
      <div class="vf-pointer-events-auto ">
        <h3 class="vf-text-xl vf-font-medium vf-px-8 ">Thêm tên miền</h3>

        <form action="" method="POST">
          <input type="hidden" name="cmd" value="add_domain" />
          <div class="vf-flex vf-flex-row vf-px-8 vf-mt-4">
            <div class="vf-flex-1 vf-mr-2 vf-text-sm vf-font-normal vf-text-gray-1">
              <label for="inputDomain">
                Domain
                <span class="vf-text-red-500 vf-ml-[2px]">*</span>
              </label>
              <div class="vf-flex vf-flex-row vf-center vf-text-gray-3 vf-mb-5">
                <input class="vf-flex-1 vf-h-10 vf-rounded-sm vf-text-[#6C798F] vf-font-normal vf-text-sm" id="inputDomain" type="text" name="domain" value="" placeholder="Nhập domain của bạn" required>
              </div>
            </div>

            <div class="vf-flex-1 vf-ml-2 vf-text-sm vf-font-normal vf-text-gray-1">
              <label for="inputBackend">
                Backend
                <span class="vf-text-red-500 vf-ml-[2px]">*</span>
              </label>
              <div class="vf-flex vf-flex-row vf-center vf-text-gray-3 vf-mb-5">
                <input class="vf-flex-1 vf-h-10 vf-rounded-sm vf-text-[#6C798F] vf-font-normal vf-text-sm" id="inputBackend" type="text" name="backend" value="" placeholder="Nhập Backend của bạn" required>
              </div>
            </div>
          </div>

          <div class="vf-flex vf-flex-row vf-px-8 vf-mt-2">
            <div class="vf-flex-1 vf-mr-2 vf-text-sm vf-font-normal vf-text-gray-1">
              <label>
                SSL
              </label>
              <div class="vf-flex vf-flex-row vf-center vf-mb-5">
                <select name="sslmode" class="vf-text-gray-3 vf-rounded vf-border vf-border-[#EBEBF0] vf-px-2 vf-w-full vf-h-[38px] vf-leading-normal">
                  <option value="" selected>&#9679; None</option>
                  <option value="flexible">&#9679; Flexible</option>
                  <option value="full">&#9679; Full</option>
                </select>
              </div>
            </div>

            <div class="vf-flex-1 vf-ml-2 vf-text-sm vf-font-normal vf-text-gray-1">
              <label>
                Force SSL
              </label>
              <div class="vf-flex vf-flex-row vf-items-center vf-bg-[#F4F6FD] vf-h-[38px] vf-text-gray-3 vf-mb-5 vf-px-3 vf-rounded-[4px]">
                <div class="vf-flex-1">
                  <div class="vf-select-none">Trạng thái</div>
                </div>
                <div class="vf-flex-1 vf-flex vf-justify-end">
                  <label for="toggle-force-ssl" class="vf-my-auto vf-cursor-pointer">
                    <!-- toggle -->
                    <div class="vf-relative">
                      <!-- input -->
                      <input type="checkbox" id="toggle-force-ssl" class="vf-sr-only vf-border" name="forcessl" value="1">
                      <!-- line -->
                      <div class="vf-block vf-bg-primary vf-w-6 vf-h-4 vf-rounded-full"></div>
                      <!-- dot -->
                      <div class="dot vf-absolute vf-left-[2px] vf-top-[2px] vf-bg-white vf-w-3 vf-h-3 vf-rounded-full vf-transition"></div>
                    </div>
                  </label>
                </div>
                <!-- toggle -->
              </div>
            </div>

          </div>

          <div class="vf-flex vf-flex-row vf-items-end vf-justify-end vf-border-t vf-px-8 vf-pt-4 vf-mt-6">
            <button class="btn-close-adddomain-modal vf-border vf-rounded vf-text-gray-2 vf-center vf-px-4 vf-py-3 vf-bg-white vf-font-medium vf-text-sm vf-mr-5 hover:vf-text-primary">
              Huỷ bỏ
            </button>

            <button type="submit" class="vf-rounded vf-bg-primary vf-center vf-px-6 vf-py-3 vf-text-white vf-font-medium vf-text-sm ">
              Thêm mới
            </button>
          </div>
        </form>
      </div>

      <div class="btn-close-adddomain-modal vf-pointer-events-auto vf-absolute vf-top-0 vf-right-0 vf-cursor-pointer vf-flex vf-flex-col vf-items-center vf-rounded vf-h-10 vf-w-10 vf-justify-center vf-p-1 vf-text-sm ">
        <svg class="vf-fill-current vf-text-black " xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 18 18">
          <path d="M14.53 4.53l-1.06-1.06L9 7.94 4.53 3.47 3.47 4.53 7.94 9l-4.47 4.47 1.06 1.06L9 10.06l4.47 4.47 1.06-1.06L10.06 9z"></path>
        </svg>
      </div>

    </div>
  </div>
</div>

{* Popup Edit Domain *}
<div id="modalVfEditDomain" style="display: none;" class="vf-z-[999] vf-opacity-0 vf-pointer-events-none vf-absolute vf-w-full vf-h-full vf-top-0 vf-left-0 vf-items-center vf-justify-center vf-delay-75 vf-duration-300 vf-ease-in-out">
  <div class="vf-absolute vf-w-full vf-h-full vf-bg-gray-900 vf-opacity-60 vf-pointer-events-auto"></div>
  <div class=" vf-bg-white vf-max-w-full vf-rounded-lg vf-shadow-lg vf-relative vf-mx-3">
    <div class="vf-relative vf-w-full md:vf-w-[640px] vf-py-6 vf-max-h-screen vf-overflow-y-auto vf-pointer-events-auto">
      <form action="" method="POST">
        <input type="hidden" name="cmd" value="update_domain" />
        <input type="hidden" name="domain" value="" id="updateDomain" />
        <div class="vf-pointer-events-auto ">
          <h3 class="vf-text-xl vf-font-medium vf-px-8 ">Chỉnh sửa tên miền</h3>

          <div class="vf-flex vf-flex-row vf-px-8 vf-mt-4">
            <div class="vf-flex-1 vf-mr-2 vf-text-sm vf-font-normal vf-text-gray-1">
              <label for="inputDomain">
                Domain
              </label>
              <div class="vf-flex vf-flex-row vf-center vf-text-gray-3 vf-mb-5">
                <input class="vf-flex-1 vf-h-10 vf-rounded-sm vf-text-[#6C798F] vf-font-normal vf-text-sm" type="email" name="domain" id="inputUpdateDomain" placeholder="Nhập domain của bạn" value="" disabled>
              </div>
            </div>

            <div class="vf-flex-1 vf-ml-2 vf-text-sm vf-font-normal vf-text-gray-1">
              <label for="inputBackend">
                Backend
              </label>
              <div class="vf-flex vf-flex-row vf-center vf-text-gray-3 vf-mb-5">
                <input class="vf-flex-1 vf-h-10 vf-rounded-sm vf-text-[#6C798F] vf-font-normal vf-text-sm" type="text" name="backend" id="inputUpdateBackend" placeholder="Nhập Backend của bạn" value="">
              </div>
            </div>
          </div>

          <div class="vf-flex vf-flex-row vf-px-8 vf-mt-2">
            <div class="vf-flex-1 vf-mr-2 vf-text-sm vf-font-normal vf-text-gray-1">
              <label for="inputEmail">
                SSL
              </label>
              <div class="vf-flex vf-flex-row vf-center vf-mb-5">
                <select class="vf-text-gray-3 vf-rounded vf-border vf-border-[#EBEBF0] vf-px-2 vf-w-full vf-h-[38px] vf-leading-normal">
                  <option>&#9679; None</option>
                  <option selected>&#9679; Flexible</option>
                  <option>&#9679; Full</option>
                </select>
              </div>
            </div>

            <div class="vf-flex-1 vf-ml-2 vf-text-sm vf-font-normal vf-text-gray-1">
              <label for="inputEmail">
                Force SSL
              </label>
              <div class="vf-flex vf-flex-row vf-items-center vf-bg-[#F4F6FD] vf-h-[38px] vf-text-gray-3 vf-mb-5 vf-px-3 vf-rounded-[4px]">
                <div class="vf-flex-1">
                  <div class="vf-select-none">Trạng thái</div>
                </div>
                <div class="vf-flex-1 vf-flex vf-justify-end">
                  <label for="toggle-edit-force-ssl" class="vf-my-auto vf-cursor-pointer">
                    <!-- toggle -->
                    <div class="vf-relative">
                      <!-- input -->
                      <input type="checkbox" id="toggle-edit-force-ssl" class="vf-sr-only vf-border" name="edit_force_ssl" value="1">
                      <!-- line -->
                      <div class="vf-block vf-bg-primary vf-w-6 vf-h-4 vf-rounded-full"></div>
                      <!-- dot -->
                      <div class="dot vf-absolute vf-left-[2px] vf-top-[2px] vf-bg-white vf-w-3 vf-h-3 vf-rounded-full vf-transition"></div>
                    </div>
                  </label>
                </div>
                <!-- toggle -->
              </div>
            </div>

          </div>

          <div class="vf-flex vf-flex-row vf-items-end vf-justify-end vf-border-t vf-px-8 vf-pt-4 vf-mt-6">
            <button class="btn-close-editdomain-modal vf-border vf-rounded vf-text-gray-2 vf-center vf-px-4 vf-py-3 vf-bg-white vf-font-medium vf-text-sm vf-mr-5 hover:vf-text-primary">
              Huỷ bỏ
            </button>

            <button type="submit" class="vf-rounded vf-bg-primary vf-center vf-px-6 vf-py-3 vf-text-white vf-font-medium vf-text-sm ">
              Cập nhật
            </button>
          </div>
        </div>
      </form>
      <div class="btn-close-editdomain-modal vf-pointer-events-auto vf-absolute vf-top-0 vf-right-0 vf-cursor-pointer vf-flex vf-flex-col vf-items-center vf-rounded vf-h-10 vf-w-10 vf-justify-center vf-p-1 vf-text-sm ">
        <svg class="vf-fill-current vf-text-black " xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 18 18">
          <path d="M14.53 4.53l-1.06-1.06L9 7.94 4.53 3.47 3.47 4.53 7.94 9l-4.47 4.47 1.06 1.06L9 10.06l4.47 4.47 1.06-1.06L10.06 9z"></path>
        </svg>
      </div>

    </div>
  </div>
</div>

{* Popup Update SSL *}
<div id="modalVfUpdateSSL" style="display: none;" class="vf-z-[999] vf-opacity-0 vf-pointer-events-none vf-absolute vf-w-full vf-h-full vf-top-0 vf-left-0 vf-items-center vf-justify-center vf-delay-75 vf-duration-300 vf-ease-in-out">
  <div class="vf-absolute vf-w-full vf-h-full vf-bg-gray-900 vf-opacity-60 vf-pointer-events-auto"></div>
  <div class=" vf-bg-white vf-max-w-full vf-rounded-lg vf-shadow-lg vf-relative vf-mx-3">
    <div class="vf-relative vf-w-full md:vf-w-[640px] vf-py-6 vf-pointer-events-auto">
      <div class="vf-pointer-events-auto ">
        <h3 class="vf-text-xl vf-font-medium vf-px-8 ">SSL/TLS</h3>

        <ul class="nav vnx-tab__4 vf-flex vf-flex-row vf-px-8 vf-flex-wrap vf-font-medium vf-border-b vf-border-[#EBEBF0]">
          <li class="nav-item vf-w-fit vf-mr-[30px]">
            <a href="#free-ssl-tab" data-toggle="tab" class="nav-link vf-bg-transparent active ">SSL miễn phí</a>
          </li>
          <li class="nav-item vf-w-fit vf-mr-[30px]">
            <a href="#upload-ssl-tab" data-toggle="tab" class="nav-link vf-bg-transparent ">Upload</a>
          </li>
        </ul>

        <div class="tab-content vf-overflow-y-auto vf-max-h-[50vh]  " id="myTabContent">
          <div id="free-ssl-tab" class="tab-pane fade show active " role="tabpanel">
            <div class="vf-flex vf-flex-row vf-px-8 vf-mt-4">
              <div class="vf-flex-1 vf-mr-2 vf-text-sm vf-font-normal vf-text-gray-1">
                <label for="inputEmail">
                  Domain
                </label>
                <div class="vf-flex vf-flex-row vf-center vf-text-gray-3 vf-mb-5">
                  <input class="vf-flex-1 vf-h-10 vf-rounded-sm vf-text-[#6C798F] vf-font-normal vf-text-sm" type="email" name="inviteemail" placeholder="Nhập domain của bạn" value="">
                </div>
              </div>

              <div class="vf-flex-1 vf-ml-2 vf-text-sm vf-font-normal vf-text-gray-1">
                <label for="inputEmail">
                  Trạng thái
                </label>
                <div class="vf-flex vf-flex-row vf-center vf-text-gray-3 vf-mb-5">
                  <select class="vf-text-gray-3 vf-rounded vf-border vf-border-[#EBEBF0] vf-px-2 vf-w-full vf-h-[38px] vf-leading-normal">
                    <option>&#9679; None</option>
                    <option selected>&#9679; Flexible</option>
                    <option>&#9679; Full</option>
                  </select>
                </div>
              </div>
            </div>

            <div class="vf-flex vf-flex-row vf-px-8 vf-mt-2">
              <div class="vf-flex-1 vf-mr-2 vf-text-sm vf-font-normal vf-text-gray-1">
                <label for="inputEmail">
                  Ngày bắt đầu
                </label>
                <div class="vf-center vf-mb-5">
                  <input type="date" id="datestart" name="datestart" class="vf-w-full">
                </div>
              </div>

              <div class="vf-flex-1 vf-ml-2 vf-text-sm vf-font-normal vf-text-gray-1">
                <label for="inputEmail">
                  Ngày kết thúc
                </label>
                <div class="vf-center vf-mb-5">
                  <input type="date" id="dateend" name="dateend" class="vf-w-full">
                </div>
              </div>

            </div>

            <div class="vf-flex vf-flex-row vf-items-end vf-justify-end vf-border-t vf-px-8 vf-pt-4 vf-mt-6">
              <button class="btn-close-updatessl-modal vf-border vf-rounded vf-text-gray-2 vf-center vf-px-4 vf-py-3 vf-bg-white vf-font-medium vf-text-sm vf-mr-5 hover:vf-text-primary">
                Huỷ bỏ
              </button>

              <button type="submit" class="vf-rounded vf-bg-primary vf-center vf-px-6 vf-py-3 vf-text-white vf-font-medium vf-text-sm ">
                Xác thực
              </button>
            </div>
          </div>

          <div id="upload-ssl-tab" class="tab-pane fade show " role="tabpanel">

            <div class="vf-flex vf-flex-col">
              <div class="vf-flex vf-flex-row vf-px-8 vf-mt-4">
                <div class="vf-flex-1 vf-mr-2 vf-text-sm vf-font-normal vf-text-gray-1">
                  CRT
                </div>
                <div class="vf-flex vf-items-end vf-text-primary vf-cursor-pointer " onclick="copyToClipboard('crt-ssl')">
                  <span class="vf-mr-1"><i class="far fa-copy"></i></span>Copy
                </div>
              </div>

              <div class="vf-flex vf-flex-row vf-px-8 vf-mt-2">
                <textarea id="crt-ssl" name="crt-ssl" class="vf-resize-none vf-overscroll-y-auto vf-h-32 vf-text-white vf-w-full vf-bg-[#013A52] vf-rounded-[3px] vf-p-3"></textarea>
              </div>
            </div>

            <div class="vf-flex vf-flex-col">
              <div class="vf-flex vf-flex-row vf-px-8 vf-mt-4">
                <div class="vf-flex-1 vf-mr-2 vf-text-sm vf-font-normal vf-text-gray-1">
                  KEY
                </div>
                <div class="vf-flex vf-items-end vf-text-primary vf-cursor-pointer " onclick="copyToClipboard('key-ssl')">
                  <span class="vf-mr-1"><i class="far fa-copy"></i></span>Copy
                </div>
              </div>

              <div class="vf-flex vf-flex-row vf-px-8 vf-mt-2">
                <textarea id="key-ssl" name="key-ssl" class="vf-resize-none vf-overscroll-y-auto vf-h-32 vf-text-white vf-w-full vf-bg-[#013A52] vf-rounded-[3px] vf-p-3"></textarea>
              </div>
            </div>

            <div class="vf-flex vf-flex-col">
              <div class="vf-flex vf-flex-row vf-px-8 vf-mt-4">
                <div class="vf-flex-1 vf-mr-2 vf-text-sm vf-font-normal vf-text-gray-1">
                  CA
                </div>
                <div class="vf-flex vf-items-end vf-text-primary vf-cursor-pointer " onclick="copyToClipboard('ca-ssl')">
                  <span class="vf-mr-1"><i class="far fa-copy"></i></span>Copy
                </div>
              </div>

              <div class="vf-flex vf-flex-row vf-px-8 vf-mt-2">
                <textarea id="ca-ssl" name="ca-ssl" class="vf-resize-none vf-overscroll-y-auto vf-h-32 vf-text-white vf-w-full vf-bg-[#013A52] vf-rounded-[3px] vf-p-3"></textarea>
              </div>
            </div>

            <div class="vf-flex vf-flex-row vf-items-end vf-justify-end vf-border-t vf-px-8 vf-pt-4 vf-mt-6">
              <button class="btn-close-updatessl-modal vf-border vf-rounded vf-text-gray-2 vf-center vf-px-4 vf-py-3 vf-bg-white vf-font-medium vf-text-sm vf-mr-5 hover:vf-text-primary">
                Huỷ bỏ
              </button>

              <button type="submit" class="vf-rounded vf-bg-primary vf-center vf-px-6 vf-py-3 vf-text-white vf-font-medium vf-text-sm ">
                Upload
              </button>
            </div>
          </div>
        </div>
      </div>

      <div class="btn-close-updatessl-modal vf-pointer-events-auto vf-absolute vf-top-0 vf-right-0 vf-cursor-pointer vf-flex vf-flex-col vf-items-center vf-rounded vf-h-10 vf-w-10 vf-justify-center vf-p-1 vf-text-sm ">
        <svg class="vf-fill-current vf-text-black " xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 18 18">
          <path d="M14.53 4.53l-1.06-1.06L9 7.94 4.53 3.47 3.47 4.53 7.94 9l-4.47 4.47 1.06 1.06L9 10.06l4.47 4.47 1.06-1.06L10.06 9z"></path>
        </svg>
      </div>

    </div>
  </div>
</div>

{* Popup Confirm Delete *}
<div id="modalConfirmDelete" style="display: none;" class="vf-z-[999] vf-opacity-0 vf-pointer-events-none vf-absolute vf-w-full vf-h-full vf-top-0 vf-left-0 vf-items-center vf-justify-center vf-delay-75 vf-duration-300 vf-ease-in-out">
  <div class="vf-absolute vf-w-full vf-h-full vf-bg-gray-900 vf-opacity-60 vf-pointer-events-auto"></div>
  <div class=" vf-bg-white vf-max-w-full vf-rounded-lg vf-shadow-lg vf-relative vf-mx-3">
    <div class="vf-relative vf-w-full md:vf-w-[310px] vf-center vf-py-5 vf-pointer-events-auto">
      <form action="" method="POST">
        <input type="hidden" name="cmd" value="delete_domain" />
        <input type="hidden" name="domain" value="" id="inputDomainRemoveItem" />
        <div class="vf-pointer-events-auto ">
          <div class="vf-text-[#F2994A] vf-text-6xl vf-text-center vf-font-medium">
            <i class="far fa-exclamation-circle"></i>
          </div>
          <div class="vf-text-[#25282B] vf-text-lg vf-text-center vf-font-medium vf-mt-2">
            BẠN CHẮC CHẮN MUỐN XÓA?
          </div>
          <div class="vf-text-[#52575C] vf-text-sm vf-text-center vf-mt-2">
            Dữ liệu sẽ bị xóa và không thể khôi phục
          </div>
          <div class="vf-flex vf-flex-row vf-items-center vf-justify-center vf-px-8 vf-pt-4 ">
            <button class="btn-close-delete-modal vf-border vf-rounded vf-text-gray-2 vf-center vf-px-4 vf-py-3 vf-bg-white vf-font-medium vf-text-sm vf-mr-5 hover:vf-text-primary">
              Huỷ bỏ
            </button>

            <button type="submit" class="vf-rounded vf-bg-primary vf-center vf-px-6 vf-py-3 vf-text-white vf-font-medium vf-text-sm hover:vf-bg-[#0E95FF] ">
              Xác nhận
            </button>
          </div>
        </div>
      </form>

      <div class="btn-close-delete-modal vf-pointer-events-auto vf-absolute vf-top-0 vf-right-0 vf-cursor-pointer vf-flex vf-flex-col vf-items-center vf-rounded vf-h-10 vf-w-10 vf-justify-center vf-p-1 vf-text-sm ">
        <svg class="vf-fill-current vf-text-black " xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 18 18">
          <path d="M14.53 4.53l-1.06-1.06L9 7.94 4.53 3.47 3.47 4.53 7.94 9l-4.47 4.47 1.06 1.06L9 10.06l4.47 4.47 1.06-1.06L10.06 9z"></path>
        </svg>
      </div>

    </div>
  </div>
</div>

<style>
  input[type="radio"]:checked+span {
    color: #38A7FF;
  }

  /* Toggle Checkbox */
  input:checked~.dot {
    transform: translateX(70%);
    background-color: #48bb78;
  }

  input[type=checkbox]:not(:checked)+div {
    transition-duration: 150ms !important;
    background: white !important;
    border: 1px solid #C7C9D9 !important;
  }

  input[type=checkbox]:not(:checked)~.dot {
    box-shadow: 0px 1px 2px rgba(40, 41, 61, 0.2), 0px 2px 4px rgba(96, 97, 112, 0.2) !important;
  }
</style>

<script>
  Helper.initTableData('#vnx-fw-configdomain-table', 'vnx_fw_configdomain_status', true, false, 'vnx-fw-configdomain-table');

  jQuery(document).ready(function() {
    var modalVfAddDomain = document.getElementById("modalVfAddDomain");
    var modalVfEditDomain = document.getElementById("modalVfEditDomain");
    var modalVfUpdateSSL = document.getElementById("modalVfUpdateSSL");
    var modalConfirmDelete = document.getElementById("modalConfirmDelete");

    if (modalVfAddDomain) {
      const closeBtns = document.querySelectorAll(".btn-close-adddomain-modal");

      for (var closeBtn of closeBtns) {
        closeBtn.addEventListener("click", (event) => {
          event.preventDefault();
          toggleModal('modalVfAddDomain');
        });
      }

      const btnVfAddDomain = document.querySelector(".btnVfAddDomain");
      btnVfAddDomain.addEventListener("click", (event) => {
        event.preventDefault();
        toggleModal('modalVfAddDomain');
      });
    }
    if (modalVfEditDomain) {
      const closeBtns = document.querySelectorAll(".btn-close-editdomain-modal");

      for (var closeBtn of closeBtns) {
        closeBtn.addEventListener("click", (event) => {
          event.preventDefault();
          toggleModal('modalVfEditDomain');
        });
      }

      const btnVfEditDomains = document.querySelectorAll(".btnVfEditDomain");
      for (var btnVfEditDomain of btnVfEditDomains) {
        btnVfEditDomain.addEventListener("click", (event) => {
          event.preventDefault();
          var domain = btnVfEditDomain.getAttribute('domain-value');
          console.log(domain);
          var backend = btnVfEditDomain.getAttribute('backend-value');
          jQuery('#updateDomain').val(domain);
          jQuery('#inputUpdateDomain').val(domain);
          jQuery('#inputUpdateBackend').val(backend);

          toggleModal('modalVfEditDomain');
        });
      }
    }
    if (modalVfUpdateSSL) {
      const closeBtns = document.querySelectorAll(".btn-close-updatessl-modal");

      for (var closeBtn of closeBtns) {
        closeBtn.addEventListener("click", (event) => {
          event.preventDefault();
          toggleModal('modalVfUpdateSSL');
        });
      }

      const btnVfAddDomains = document.querySelectorAll(".slVfAddDmain");
      for (var btnVfAddDomain of btnVfAddDomains) {
        btnVfAddDomain.addEventListener("change", (event) => {
          event.preventDefault();
          toggleModal('modalVfUpdateSSL');
        });
      }
    }
    if (modalConfirmDelete) {
      const closeBtns = document.querySelectorAll(".btn-close-delete-modal");

      for (var closeBtn of closeBtns) {
        closeBtn.addEventListener("click", (event) => {
          event.preventDefault();
          toggleModal('modalConfirmDelete');
        });
      }

      const btnVfDeleteDomains = document.querySelectorAll(".btnVfDeleteDomain");

      for (var btnVfDeleteDomain of btnVfDeleteDomains) {
        btnVfDeleteDomain.addEventListener("click", (event) => {
          event.preventDefault();
          var domain = btnVfDeleteDomain.getAttribute('data-value');
          jQuery('#inputDomainRemoveItem').val(domain);
          toggleModal('modalConfirmDelete');
        });
      }
    }

    document.onkeydown = function(evt) {
      evt = evt || window.event;
      var isEscape = false;
      if ("key" in evt) {
        isEscape = evt.key === "Escape" || evt.key === "Esc";
      } else {
        isEscape = evt.isEscape;
      }

      let modalAddDomain = document.querySelector("#modalVfAddDomain");
      if (isEscape && !modalAddDomain.classList.contains("vf-opacity-0")) {
        toggleModal('modalVfAddDomain');
      }
      let modalEditDomain = document.querySelector("#modalVfEditDomain");
      if (isEscape && !modalEditDomain.classList.contains("vf-opacity-0")) {
        toggleModal('modalVfEditDomain');
      }
      let modalUpdateSSL = document.querySelector("#modalVfUpdateSSL");
      if (isEscape && !modalUpdateSSL.classList.contains("vf-opacity-0")) {
        toggleModal('modalVfUpdateSSL');
      }
    };

    function toggleModal(modalID) {
      const modal = document.querySelector("#" + modalID);
      modal.classList.toggle("opacity-0");
      modal.classList.toggle("pointer-events-none");
      modal.classList.toggle("vf-opacity-0");

      if (!modal.classList.contains("vf-opacity-0")) {
        modal.style.display = "flex";
      } else {
        modal.style.display = "none";
      }

      const body = document.querySelector(".vnx-main");

      if (!modal.classList.contains("vf-opacity-0")) {
        // Disable scroll
        body.style.overflow = "hidden";
      } else {
        // Enable scroll
        body.style.overflow = "auto";
      }
    }
  });

  function copyToClipboard(element) {
    var copyText = document.getElementById(element);
    copyText.select();
    copyText.setSelectionRange(0, 99999); /* For mobile devices */
    document.execCommand("copy");
    alert("Copied the text to clipboard.");
  }
</script>