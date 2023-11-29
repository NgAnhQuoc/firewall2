<!-- START: head -->
{include file="./Components/head.tpl"}
<!-- END: head -->

<!-- START: header -->
{include file="modules/servers/vietnix_firewall2/UI/Client/templates/service-details/header.tpl" head_title="Cấu hình tên miền"}
<!-- END: header -->

<!-- START: body -->
<div class="vnx-main" id="vnx-fw-configdomain-table">
  <div class="vnx-container vf-flex vf-flex-col vf-h-full">

    <div class="vf-flex vf-flex-row vf-mt-2" id="alertMsg">
      <div v-if="alertMsg != '' && alertPosition == 'list'" :class="[[alertType]]" class="vf-w-full vf-flex vf-flex-row vf-mt-6 vf-px-4 vf-py-3 vf-rounded-md vf-border-l-[6px] vf-border-solid vf-border vf-bg-white vf-text-xs">
        <div class="vf-text-sm vf-text-center vf-mr-4"><i class="far fa-bell"></i></div>
        <div class="vf-text-sm"> [[alertMsg]] </div>
      </div>
    </div>

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
                [[dataTable.length]]
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="vf-flex vf-flex-col vf-bg-white vf-rounded vf-shadow-card vf-pt-6 vf-mt-6">
      <div class="vf-flex vf-flex-row">
        <div class="vf-text-base vf-ml-4 vf-mr-3 md:vf-ml-7 md:vf-mr-5 vf-mb-6 vf-text-gray-1 vf-font-medium">Danh sách tên miền</div>
        <div class="vf-flex-1"></div>
        <div class="vf-px-3 md:vf-px-6">
          <div @click="[toggleModal('modalAddDomain')]" class="vf-px-4 vf-py-2 vf-bg-primary vf-text-white vf-text-sm vf-rounded vf-cursor-pointer">
            <i class="fas fa-plus fa-sm"></i>
            <span>Thêm tên miền</span>
          </div>
        </div>
      </div>

      <div class="vnx-table-firewallweb-list-domain vnx__table vf-border-none" id="vnx-fw-configdomain-table-list">
        <div class="vnx__table--header vf-hidden md:vf-flex vf-bg-transparent vf-border-t-0 vf-border-b-[1px] vf-px-7 vf-text-[14px] vf-text-gray-3">
          <div class="vnx__table--col vf-flex-1">Domain</div>
          <div class="vnx__table--col vf-flex-1">Backend</div>
          <div class="vnx__table--col vf-flex-1">SSL</div>
          <div class="vnx__table--col vf-w-40 vf-center">Force SSL</div>
          <div class="vnx__table--col vf-w-40 vf-text-right"></div>
        </div>

        {* Desktop *}
        <div class="vnx__table--body vf-hidden md:vf-block vf-text-gray-1">
          <div v-if="!dataTable || dataTable.length == 0" class="vf-center vf-py-8 vf-text-gray-2" style="border-radius: 0 0 6px 6px;">
            Không có domain nào
          </div>

          <template v-else v-for="(item, index) in pages">
            <div :id="'foo-' + index" class="vf-px-7 vf-border-b vf-border-[#EBEBF0] vnx__table--row">
              <div class="vnx__table--col vf-flex-1">
                <div class="vf-flex vf-flex-row vf-text-sm">
                  <div class="vf-flex vf-items-center vf-justify-center">
                    <!-- toggle -->
                    <i v-if="loading==true && selectedDomain==item.vhost" class="fas fa-spinner fa-spin vf-text-primary"></i>
                    <div v-else @click="[selectedDomain = item.vhost, handleOnOffDomain()]" class="vf-relative vf-cursor-pointer">
                      <input :checked="item.enable==true" type="checkbox" class="vf-sr-only vf-border">
                      <div class="vf-block vf-bg-primary vf-w-6 vf-h-4 vf-rounded-full"></div>
                      <div class="dot vf-absolute vf-left-[2px] vf-top-[2px] vf-bg-white vf-w-3 vf-h-3 vf-rounded-full vf-transition"></div>
                    </div>
                    <!-- toggle -->
                  </div>
                  <div class="vf-flex-1 vf-ml-2">[[item.vhost]]</div>
                </div>
              </div>

              <div class="vnx__table--col vf-flex-1">
                <div class="vf-text-sm">
                  [[item.beIP]]
                </div>
              </div>

              <div class="vnx__table--col vf-flex-1 vf-text-sm">
                <div v-if="item.sslMode == 'full'">
                  <span class="sslmode sslmode-full">
                    Full
                  </span>
                </div>
                <div v-else-if="item.sslMode == 'flex'">
                  <span class="sslmode sslmode-flexible">
                    Flexible
                  </span>
                </div>
                <div v-else>
                  <span class="sslmode sslmode-none">
                    None
                  </span>
                </div>
              </div>

              <div class="vnx__table--col vf-w-40 vf-flex vf-center">
                <div v-if="item.sslMode != 'none'" class="vf-relative">
                  <input :checked="item.forceSSL=='yes'" type="checkbox" class="vf-sr-only vf-border">
                  <div class="vf-block vf-bg-primary vf-w-6 vf-h-4 vf-rounded-full"></div>
                  <div class="dot vf-absolute vf-left-[2px] vf-top-[2px] vf-bg-white vf-w-3 vf-h-3 vf-rounded-full vf-transition"></div>
                </div>
              </div>

              <div class="vnx__table--col vf-w-40 vf-text-right vf-flex vf-items-end vf-justify-end">
                <button @click="[toggleModal('modalConfirmDelete'), selectedDomain = item.vhost]" id="btnConfirmDeleteDomain"
                  class="btnVfDeleteDomain vf-w-8 vf-h-8 vf-center vf-border vf-rounded vf-text-red-500 vf-border-red-500 vf-bg-white vf-mr-2">
                  <i class="far fa-trash"></i>
                </button>
                <button :disabled="!item.enable" @click="[toggleModal('modalEditDomain'), selectedDomain = item.vhost, fillContentModalEditDomain()]"
                  class="btnVfEditDomain vf-center vf-px-[20px] vf-py-[7px] vf-border vf-rounded vf-text-gray-1 vf-border-[#EBEBF0] vf-bg-white">
                  Edit
                </button>
              </div>
            </div>
          </template>

        </div>

        {* Mobile *}
        <div class="vnx__table--body vf-block md:vf-hidden vf-text-gray-1">
          <div v-if="!dataTable || dataTable.length == 0" class="vf-center vf-py-8 vf-text-gray-2" style="border-radius: 0 0 6px 6px;">
            Không có domain nào
          </div>

          <template v-else v-for="(item, index) in pages">
            <div :id="'foo-' + index" class=" vf-flex vf-flex-col vf-items-start vf-px-2 vf-border-b vf-border-[#EBEBF0] vnx__table--row">
              <div class="vnx__table--col vf-flex vf-flex-row vf-w-full vf-px-2 vf-py-3">
                <div class="vf-flex-1 vf-flex vf-flex-row vf-items-center vf-text-sm">
                  <div class="vf-flex">
                    <!-- toggle -->
                    <i v-if="loading==true && selectedDomain==item.vhost" class="fas fa-spinner fa-spin vf-text-primary"></i>
                    <div v-else @click="[selectedDomain = item.vhost, handleOnOffDomain()]" class="vf-relative vf-cursor-pointer">
                      <input :checked="item.enable==true" type="checkbox" class="vf-sr-only vf-border">
                      <div class="vf-block vf-bg-primary vf-w-6 vf-h-4 vf-rounded-full"></div>
                      <div class="dot vf-absolute vf-left-[2px] vf-top-[2px] vf-bg-white vf-w-3 vf-h-3 vf-rounded-full vf-transition"></div>
                    </div>
                    <!-- toggle -->
                  </div>
                  <div class="vf-flex-1 vf-ml-2">[[item.vhost]]</div>
                </div>
                <div class="vf-flex-1 vf-text-right vf-flex vf-items-end vf-justify-end">
                  <button @click="[toggleModal('modalConfirmDelete'), selectedDomain = item.vhost]" id="btnConfirmDeleteDomain"
                    class="btnVfDeleteDomain vf-w-8 vf-h-8 vf-center vf-border vf-rounded vf-text-red-500 vf-border-red-500 vf-bg-white vf-mr-2">
                    <i class="far fa-trash"></i>
                  </button>
                  <button :disabled="!item.enable" @click="[toggleModal('modalEditDomain'), selectedDomain = item.vhost, fillContentModalEditDomain()]"
                    class="btnVfEditDomain vf-center vf-px-[20px] vf-py-[7px] vf-border vf-rounded vf-text-gray-1 vf-border-[#EBEBF0] vf-bg-white">
                    Edit
                  </button>
                </div>
              </div>

              <div class="vnx__table--col vf-w-full vf-flex vf-flex-row vf-px-2 vf-py-3">
                <div class="vf-flex-1 vf-text-[14px] vf-text-gray-3">Backend</div>
                <div class="vf-flex-1 vf-items-end vf-text-right vf-text-sm">[[item.beIP]]</div>
              </div>

              <div class="vnx__table--col vf-w-full vf-flex vf-flex-row vf-px-2 vf-py-3">
                <div class="vf-flex-1 vf-text-[14px] vf-text-gray-3">SSL</div>
                <div class="vf-flex-1 vf-items-end vf-text-right vf-text-sm">
                  <div v-if="item.sslMode == 'full'">
                    <span class="sslmode sslmode-full">
                      Full
                    </span>
                  </div>
                  <div v-else-if="item.sslMode == 'flex'">
                    <span class="sslmode sslmode-flexible">
                      Flexible
                    </span>
                  </div>
                  <div v-else>
                    <span class="sslmode sslmode-none">
                      None
                    </span>
                  </div>
                </div>
              </div>

              <div class="vnx__table--col vf-w-full vf-flex vf-flex-row vf-px-2 vf-py-3">
                <div class="vf-flex-1 vf-text-[14px] vf-text-gray-3">Force SSL</div>
                <div class="vf-flex-1 vf-flex vf-w-full vf-justify-end vf-text-sm">
                  <div v-if="item.sslMode != 'none'" class="vf-relative">
                    <input :checked="item.forceSSL=='yes'" type="checkbox" class="vf-sr-only vf-border">
                    <div class="vf-block vf-bg-primary vf-w-6 vf-h-4 vf-rounded-full"></div>
                    <div class="dot vf-absolute vf-left-[2px] vf-top-[2px] vf-bg-white vf-w-3 vf-h-3 vf-rounded-full vf-transition"></div>
                  </div>
                </div>
              </div>
            </div>

          </template>
        </div>

      </div>
    </div>

    {* Paginations *}
    {include file="./Components/paginations.tpl"}
    {* /Paginations *}

    <div class="vf-flex-1"></div>

    <div class="vf-mt-7">
      <div class="footer vf-flex-1 vf-w-full">
        <div class="vf-py-3 vf-text-sm vf-text-gray-400 vf-items-center text-footer">
          Copyright © 2023 Vietnix JSC. All Rights Reserved.
        </div>
      </div>
    </div>
  </div>

  {* Popup Add Domain *}
  <div id="modalAddDomain" style="display: none;"
    class="vf-z-[999] vf-px-3 md:vf-px-0 vf-opacity-0 vf-pointer-events-none vf-absolute vf-w-full vf-h-full vf-top-0 vf-left-0 vf-items-center vf-justify-center vf-delay-75 vf-duration-300 vf-ease-in-out">
    <div class="vf-absolute vf-w-full vf-h-full vf-bg-gray-900 vf-opacity-60 vf-pointer-events-auto"></div>
    <div class="vf-bg-white vf-max-w-full vf-min-w-full md:vf-min-w-[960px] vf-rounded-lg vf-shadow-lg vf-relative vf-mx-3 vf-px-3">
      <form role="form" method="post" action="">
        <div class="vf-relative vf-w-full md:vf-w-[960px] vf-py-6 vf-max-h-screen vf-overflow-y-auto vf-pointer-events-auto">
          <div class="vf-pointer-events-auto ">
            <h3 class="vf-text-xl vf-font-medium md:vf-px-8 vf-text-gray-900">Thêm tên miền</h3>
            <div class="vf-flex vf-flex-col md:vf-flex-row md:vf-px-8 vf-mt-4">
              <div class="vf-flex-1 md:vf-mr-2 vf-text-sm vf-font-normal vf-text-gray-1">
                <label for="inputDomain">
                  Domain
                  <span class="vf-text-red-500 vf-ml-[2px]">*</span>
                </label>
                <div class="vf-flex vf-flex-row vf-center vf-text-gray-3 vf-mb-5">
                  <input v-model="addDomain" data-toggle="tooltip" data-placement="bottom" title="Trường này là bắt buộc" data-trigger="manual" class="vf-flex-1 vf-h-10 vf-rounded-sm vf-text-[#6C798F] vf-font-normal vf-text-sm" id="inputDomain"
                    type="text" value="" placeholder="Nhập domain của bạn">
                </div>
              </div>

              <div class="vf-flex-1 md:vf-ml-2 vf-text-sm vf-font-normal vf-text-gray-1">
                <label for="inputBackend">
                  Backend
                  <span class="vf-text-red-500 vf-ml-[2px]">*</span>
                </label>
                <div class="vf-flex vf-flex-row vf-center vf-text-gray-3 vf-mb-5">
                  <input v-model="addBackend" data-toggle="tooltip" data-placement="bottom" title="Trường này là bắt buộc" data-trigger="manual" class="vf-flex-1 vf-h-10 vf-rounded-sm vf-text-[#6C798F] vf-font-normal vf-text-sm" id="inputBackend"
                    type="text" value="" placeholder="Nhập Backend của bạn">
                </div>
              </div>
            </div>

            <div class="vf-flex vf-flex-col md:vf-flex-row md:vf-px-8 vf-mt-2">
              <div class="vf-w-full md:vf-w-1/2 vf-mr-2 vf-text-base vf-font-normal vf-text-gray-1">
                <label class="vf-text-sm vf-mb-4">
                  SSL Mode
                </label>
                <div class="vf-flex vf-flex-col vf-center vf-mb-5">
                  <select v-model="addSSLMode" id="add-sslmode" class="vf-text-sm vf-text-gray-3 vf-rounded vf-border vf-border-[#EBEBF0] vf-px-2 vf-w-full
                      vf-h-[38px] vf-leading-normal vf-outline-none">
                    <option value="none">None</option>
                    <option value="flex">Flexible</option>
                    <option value="full">Full</option>
                  </select>
                  <div v-if="addSSLMode == 'full'" class="vf-text-xs vf-text-gray-3 vf-mt-2"><span class="vf-text-primary vf-font-semibold">Tips:</span> Để SSL Mode Full hoạt động ổn định, quý khách nên gắn SSL vào domain tương ứng đang chạy ở
                    backend!
                  </div>
                </div>
              </div>

              <div v-if="addSSLMode != 'none'" class="vf-w-full md:vf-w-1/2 md:vf-ml-2 vf-text-base vf-font-normal vf-text-gray-1">
                <label class="vf-text-sm vf-mb-4">
                  Force SSL
                </label>
                <div class="vf-flex vf-flex-row vf-items-center vf-bg-[#F4F6FD] vf-h-[38px] vf-text-gray-3 vf-mb-5 vf-px-3 vf-rounded-[4px]">
                  <div class="vf-flex-1">
                    <div class="vf-select-none vf-text-sm">Trạng thái</div>
                  </div>
                  <div class="vf-flex-1 vf-flex vf-justify-end">
                    <label for="toggle-force-ssl" class="vf-my-auto vf-cursor-pointer">
                      <!-- toggle -->
                      <div class="vf-relative">
                        <!-- input -->
                        <input v-model="addForceSSL" type="checkbox" id="toggle-force-ssl" class="vf-sr-only vf-border" value="yes">
                        <!-- line -->
                        <div class="vf-block vf-bg-primary vf-w-6 vf-h-4 vf-rounded-full"></div>
                        <!-- dot -->
                        <div class="dot vf-absolute vf-left-[2px] vf-top-[2px] vf-bg-white vf-w-3 vf-h-3 vf-rounded-full vf-transition"></div>
                      </div>
                  </div>
                  </label>
                </div>
                <!-- toggle -->
              </div>
            </div>
          </div>

          <div v-if="addSSLMode != 'none'" class="vf-flex vf-flex-col md:vf-flex-row md:vf-px-8 vf-mt-2">
            <div class="vf-flex vf-flex-col vf-w-full md:vf-w-1/2 vf-mr-2 vf-text-base vf-font-normal vf-text-gray-1">
              <label class="vf-text-sm vf-mb-4">
                SSL Type
              </label>
              <div class="vf-flex vf-flex-row  vf-mb-5">
                <select v-model="addCustomSSL" id="add-sslmode" class="vf-text-sm vf-text-gray-3 vf-rounded vf-border vf-border-[#EBEBF0] vf-px-2 vf-w-full vf-h-[38px] vf-leading-normal vf-outline-none">
                  <option value="">&#9679; Miễn phí</option>
                  <option value="upload">&#9679; Upload</option>
                </select>
              </div>
            </div>
          </div>

          <div v-if="addCustomSSL == 'upload' && addSSLMode != 'none'" class="vf-flex vf-flex-col md:vf-px-8 vf-mt-2">
            <div class="vf-flex vf-flex-col">
              <div class="vf-flex vf-flex-row vf-mt-4">
                <div class="vf-flex-1 vf-mr-2 vf-text-base vf-font-normal vf-text-gray-1">
                  CRT
                </div>
                <div class="vf-flex vf-items-end vf-text-primary vf-cursor-pointer " @click="copyToClipboard('crt-ssl')">
                  <span class="vf-mr-1"><i class="far fa-copy"></i></span>Sao chép
                </div>
              </div>

              <div class="vf-flex vf-flex-row vf-mt-2">
                <textarea v-model="addCert" id="addCert" class="vf-resize-none vf-overscroll-y-auto vf-h-32 vf-text-white vf-w-full vf-bg-[#013A52] vf-rounded-[3px] vf-p-3">[[addCert]]</textarea>
              </div>
            </div>

            <div class="vf-flex vf-flex-col">
              <div class="vf-flex vf-flex-row vf-mt-4">
                <div class="vf-flex-1 vf-mr-2 vf-text-base vf-font-normal vf-text-gray-1">
                  KEY
                </div>
                <div class="vf-flex vf-items-end vf-text-primary vf-cursor-pointer " @click="copyToClipboard('key-ssl')">
                  <span class="vf-mr-1"><i class="far fa-copy"></i></span>Sao chép
                </div>
              </div>

              <div class="vf-flex vf-flex-row vf-mt-2">
                <textarea v-model="addKey" id="addKey" class="vf-resize-none vf-overscroll-y-auto vf-h-32 vf-text-white vf-w-full vf-bg-[#013A52] vf-rounded-[3px] vf-p-3">[[addKey]]</textarea>
              </div>
            </div>

            <div class="vf-flex vf-flex-col">
              <div class="vf-flex vf-flex-row vf-mt-4">
                <div class="vf-flex-1 vf-mr-2 vf-text-base vf-font-normal vf-text-gray-1">
                  CA
                </div>
                <div class="vf-flex vf-items-end vf-text-primary vf-cursor-pointer " @click="copyToClipboard('ca-ssl')">
                  <span class="vf-mr-1"><i class="far fa-copy"></i></span>Sao chép
                </div>
              </div>

              <div class="vf-flex vf-flex-row vf-mt-2">
                <textarea v-model="addCA" id="addCA" class="vf-resize-none vf-overscroll-y-auto vf-h-32 vf-text-white vf-w-full vf-bg-[#013A52] vf-rounded-[3px] vf-p-3">[[addCA]]</textarea>
              </div>
            </div>
          </div>

          <div class="vf-flex vf-flex-row md:vf-px-8 vf-mt-2" id="alertMsg">
            <div v-if="alertMsg != '' && alertPosition == 'add_popup'" :class="[[alertType]]" class="vf-w-full vf-flex vf-flex-row vf-mt-6 vf-px-4 vf-py-3 vf-rounded-md vf-border-l-[6px] vf-border-solid vf-border vf-bg-white vf-text-xs">
              <div class="vf-text-sm vf-text-center vf-mr-4"><i class="far fa-bell"></i></div>
              <div class="vf-text-sm"> [[alertMsg]] </div>
            </div>
          </div>

          <div class="vf-flex vf-flex-col md:vf-flex-row vf-border-t md:vf-px-8 vf-pt-4 vf-mt-6">
            <div v-if="addSSLMode != 'none'" class="vf-flex-1 vf-text-xs vf-text-gray-3 vf-mt-2">
              <span class="vf-text-[#ffc107] vf-font-semibold">Tips:</span>
              Đối với các domain có SSL khi khởi tạo sẽ lâu hơn, bạn vui lòng đợi nhé !
            </div>
            <div class="v-flex-1 vf-flex vf-flex-row md:vf-items-end md:vf-justify-end vf-mt-4 md:vf-mt-0 ">
              <button @click="toggleModal('modalAddDomain')" class="vf-flex-1 md:vf-flex-initial vf-border vf-rounded vf-text-gray-2 vf-center vf-px-4 vf-py-3 vf-bg-white vf-font-medium vf-text-sm vf-mr-5 hover:vf-text-primary">
                Huỷ bỏ
              </button>
              <button @click="handleAddDomain" :disabled="loading" type="button" id="submit-add-domain" class="vf-flex-1 md:vf-flex-initial vf-rounded vf-bg-primary vf-center vf-px-6 vf-py-3 vf-text-white vf-font-medium vf-text-sm ">
                <div v-if="loading">Loading <i class="fas fa-spinner fa-spin"></i></div>
                <div v-else>Thêm mới</div>
              </button>
            </div>
          </div>
        </div>
      </form>
      <div @click="toggleModal('modalAddDomain')" class="vf-pointer-events-auto vf-absolute vf-top-0 vf-right-0 vf-cursor-pointer vf-flex vf-flex-col vf-items-center vf-rounded vf-h-10 vf-w-10 vf-justify-center vf-p-1 vf-text-sm ">
        <svg class="vf-fill-current vf-text-black " xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 18 18">
          <path d="M14.53 4.53l-1.06-1.06L9 7.94 4.53 3.47 3.47 4.53 7.94 9l-4.47 4.47 1.06 1.06L9 10.06l4.47 4.47 1.06-1.06L10.06 9z"></path>
        </svg>
      </div>
    </div>
  </div>

  {* Popup Edit Domain *}
  <div id="modalEditDomain" style="display: none;"
    class="vf-z-[999] vf-px-3 md:vf-px-0 vf-opacity-0 vf-pointer-events-none vf-absolute vf-w-full vf-h-full vf-top-0 vf-left-0 vf-items-center vf-justify-center vf-delay-75 vf-duration-300 vf-ease-in-out">
    <div class="vf-absolute vf-w-full vf-h-full vf-bg-gray-900 vf-opacity-60 vf-pointer-events-auto"></div>
    <div class="vf-bg-white vf-max-w-full vf-min-w-full md:vf-min-w-[960px] vf-rounded-lg vf-shadow-lg vf-relative vf-mx-3 vf-px-3">
      <div class="vf-relative vf-w-full md:vf-w-[960px] vf-py-6 vf-max-h-screen vf-overflow-y-auto vf-pointer-events-auto">
        <div class="vf-pointer-events-auto ">
          <h3 class="vf-text-xl vf-font-medium vf-px-4 md:vf-px-8 vf-text-gray-900">Chỉnh sửa tên miền</h3>

          <div class="vf-flex vf-flex-col md:vf-flex-row vf-px-4 md:vf-px-8">
            <div class="vf-flex-1 md:vf-mr-2 vf-text-base vf-font-normal vf-text-gray-1">
              <label for="inputUpdateDomain" class=" vf-text-sm vf-mb-4">
                Domain
                <span class="vf-text-red-500 vf-ml-[2px]">*</span>
              </label>
              <div class="vf-flex vf-flex-row vf-center vf-text-gray-3 vf-mb-5">
                <input v-model="editDomain" data-toggle="tooltip" data-placement="bottom" title="Trường này là bắt buộc" data-trigger="manual" class="vf-flex-1  vf-rounded-md vf-text-[#6C798F] vf-font-normal vf-text-base vf-border-solid vf-h-[38px]"
                  type="text" id="inputUpdateDomain" placeholder="Nhập domain của bạn" value="" disabled>
              </div>
            </div>

            <div class="vf-flex-1 md:vf-ml-2 vf-text-base vf-font-normal vf-text-gray-1">
              <label for="inputUpdateBackend" class=" vf-text-sm vf-mb-4">
                Backend
                <span class="vf-text-red-500 vf-ml-[2px]">*</span>
              </label>
              <div class="vf-flex vf-flex-row vf-center vf-text-gray-3 vf-mb-5">
                <input v-model="editBackend" data-toggle="tooltip" data-placement="bottom" title="Trường này là bắt buộc" data-trigger="manual"
                  class="vf-flex-1  vf-rounded-md vf-border-[#EBEBF0] vf-text-[#6C798F] vf-font-normal vf-text-base vf-border-solid vf-h-[38px]" type="text" id="inputUpdateBackend" placeholder="Nhập Backend của bạn" value="">
              </div>
            </div>
          </div>

          <div class="vf-flex vf-flex-col md:vf-flex-row vf-px-4 md:vf-px-8 vf-mt-2">
            <div class="vf-flex vf-flex-col vf-w-full md:vf-w-1/2 vf-mr-2 vf-text-base vf-font-normal vf-text-gray-1">
              <label for="updateSSLMode" class=" vf-text-sm vf-mb-4">
                SSL Mode
              </label>
              <div class="vf-flex vf-flex-col vf-center vf-mb-5">
                <select v-model="editSSLMode" id="updateSSLMode" class="vf-text-sm vf-text-gray-3 vf-rounded vf-border vf-border-[#EBEBF0] vf-px-2 vf-w-full
                vf-h-[38px] vf-leading-normal vf-outline-none">
                  <option value="none">&#9679; None</option>
                  <option value="flex">&#9679; Flexible</option>
                  <option value="full">&#9679; Full</option>
                </select>
                <div v-if="editSSLMode == 'full'" class="vf-text-xs vf-text-gray-3 vf-mt-2"><span class="vf-text-primary vf-font-semibold">Tips:</span> Để SSL Mode Full hoạt động ổn định, quý khách nên gắn SSL vào domain tương ứng đang chạy ở
                  backend!
                </div>
              </div>
            </div>

            <div v-if="editSSLMode != 'none'" class="vf-flex vf-flex-col vf-w-full md:vf-w-1/2 md:vf-ml-2 vf-text-base vf-font-normal vf-text-gray-1">
              <label class=" vf-text-sm vf-mb-4">
                Force SSL
              </label>
              <div class="vf-flex vf-flex-row vf-items-center vf-bg-[#F4F6FD] vf-h-[38px] vf-text-gray-3 vf-mb-5 vf-px-3 vf-rounded-[4px]">
                <div class="vf-flex-1">
                  <div class="vf-select-none vf-text-sm">Trạng thái</div>
                </div>
                <div class="vf-flex-1 vf-flex vf-justify-end">
                  <label for="editForceSSL" class="vf-my-auto vf-cursor-pointer">
                    <!-- toggle -->
                    <div class="vf-relative">
                      <!-- input -->
                      <input v-model="editForceSSL" :checked="editForceSSL" type="checkbox" id="editForceSSL" class="vf-sr-only vf-border">
                      <!-- line -->
                      <div class="vf-block vf-bg-primary vf-w-6 vf-h-4 vf-rounded-full"></div>
                      <!-- dot -->
                      <div class="dot vf-absolute vf-left-[2px] vf-top-[2px] vf-bg-white vf-w-3 vf-h-3 vf-rounded-full vf-transition"></div>
                    </div>
                </div>
                </label>
              </div>
              <!-- toggle -->
            </div>
          </div>

          <div v-if="editSSLMode != 'none' && editStartDate != 'none' && editEndDate != 'none'" class="vf-flex vf-flex-col md:vf-flex-row vf-px-4 md:vf-px-8 vf-mt-2">
            <div class="vf-flex vf-flex-col vf-w-full md:vf-w-1/2 vf-mr-2 vf-text-sm vf-font-normal vf-text-gray-1">
              <label for="editStartDate" class="vf-mb-4">
                Ngày bắt đầu
              </label>
              <div class="vf-flex vf-flex-row vf-items-center vf-bg-[#F4F6FD] vf-h-[38px] vf-text-gray-3 vf-mb-5 vf-px-3 vf-rounded-[4px]">
                [[editStartDate]]
              </div>
            </div>
            <div class="vf-flex vf-flex-col vf-w-full md:vf-w-1/2 md:vf-ml-2 vf-text-sm vf-font-normal vf-text-gray-1">
              <label for="editEndDate" class="vf-mb-4">
                Ngày kết thúc
              </label>
              <div class="vf-flex vf-flex-row vf-items-center vf-bg-[#F4F6FD] vf-h-[38px] vf-text-gray-3 vf-mb-5 vf-px-3 vf-rounded-[4px]">
                [[editEndDate]]
              </div>
            </div>
          </div>

          <!-- BEGIN UPLOAD SSL -->
          <div v-if="editSSLMode != 'none'" class="vf-flex vf-flex-col md:vf-flex-row vf-px-4 md:vf-px-8 vf-mt-2">
            <div class="vf-flex vf-w-full md:vf-w-1/2 vf-flex-col vf-mr-2 vf-text-base vf-font-normal vf-text-gray-1">
              <label class=" vf-text-sm vf-mb-4">
                SSL Type
              </label>
              <div class="vf-flex vf-flex-row  vf-mb-5">
                <select v-model="editCustomSSL" id="edit-sslmode" class="vf-text-sm vf-text-gray-3 vf-rounded vf-border vf-border-[#EBEBF0] vf-px-2 vf-w-full
                vf-h-[38px] vf-leading-normal vf-outline-none">
                  <option value="">&#9679; Miễn phí</option>
                  <option value="upload">&#9679; Upload</option>
                </select>
              </div>
            </div>
            <div v-if="editSSLStatus != 'none'" class="vf-flex vf-flex-col vf-w-full md:vf-w-1/2 md:vf-ml-2 vf-text-sm vf-font-normal vf-text-gray-1">
              <label for="editEndDate" class="vf-mb-4">
                Trạng thái SSL
              </label>
              <div class="vf-flex vf-flex-row vf-items-center vf-bg-[#F4F6FD] vf-h-[38px] vf-text-gray-3 vf-mb-5 vf-px-3 vf-rounded-[4px]">
                <div class="sslstatus vf-capitalize" :class="[[editSSLStatus]]">[[editSSLStatus]]</div>
              </div>
            </div>
          </div>

          <div v-if="editCustomSSL == 'upload' && editSSLMode != 'none'" class="vf-flex vf-flex-col vf-px-4 md:vf-px-8 vf-mt-2">
            <div class="vf-flex vf-flex-col">
              <div class="vf-flex vf-flex-row vf-mt-4">
                <div class="vf-flex-1 vf-mr-2 vf-text-sm vf-font-normal vf-text-gray-1">
                  CRT
                </div>
                <div class="vf-flex vf-items-end vf-text-primary vf-cursor-pointer " @click="copyToClipboard('editCert')">
                  <span class="vf-mr-1"><i class="far fa-copy"></i></span>Sao chép
                </div>
              </div>

              <div class="vf-flex vf-flex-row vf-mt-2">
                <textarea v-model="editCert" id="editCert" class="vf-resize-none vf-overscroll-y-auto vf-h-32 vf-text-white vf-w-full vf-bg-[#013A52] vf-rounded-[3px] vf-p-3">[[editCert]]</textarea>
              </div>
            </div>

            <div class="vf-flex vf-flex-col">
              <div class="vf-flex vf-flex-row vf-mt-4">
                <div class="vf-flex-1 vf-mr-2 vf-text-sm vf-font-normal vf-text-gray-1">
                  KEY
                </div>
                <div class="vf-flex vf-items-end vf-text-primary vf-cursor-pointer " @click="copyToClipboard('editKey')">
                  <span class="vf-mr-1"><i class="far fa-copy"></i></span>Sao chép
                </div>
              </div>

              <div class="vf-flex vf-flex-row vf-mt-2">
                <textarea v-model="editKey" id="editKey" class="vf-resize-none vf-overscroll-y-auto vf-h-32 vf-text-white vf-w-full vf-bg-[#013A52] vf-rounded-[3px] vf-p-3">[[editKey]]</textarea>
              </div>
            </div>

            <div class="vf-flex vf-flex-col">
              <div class="vf-flex vf-flex-row vf-mt-4">
                <div class="vf-flex-1 vf-mr-2 vf-text-sm vf-font-normal vf-text-gray-1">
                  CA
                </div>
                <div class="vf-flex vf-items-end vf-text-primary vf-cursor-pointer " @click="copyToClipboard('editCA')">
                  <span class="vf-mr-1"><i class="far fa-copy"></i></span>Sao chép
                </div>
              </div>

              <div class="vf-flex vf-flex-row vf-mt-2">
                <textarea v-model="editCA" id="editCA" class="vf-resize-none vf-overscroll-y-auto vf-h-32 vf-text-white vf-w-full vf-bg-[#013A52] vf-rounded-[3px] vf-p-3">[[editCA]]</textarea>
              </div>
            </div>
          </div>
          <!-- BEGIN UPLOAD SSL -->

          <div class="vf-flex vf-flex-col md:vf-flex-row md:vf-px-8 vf-mt-2" id="alertMsg">
            <div v-if="alertMsg != '' && alertPosition == 'edit_popup'" :class="[[alertType]]" class="vf-w-full vf-flex vf-flex-row vf-mt-6 vf-px-4 vf-py-3 vf-rounded-md vf-border-l-[6px] vf-border-solid vf-border vf-bg-white vf-text-xs">
              <div class="vf-text-sm vf-text-center vf-mr-4"><i class="far fa-bell"></i></div>
              <div class="vf-text-sm"> [[alertMsg]] </div>
            </div>
          </div>

          <div class="vf-flex vf-flex-col md:vf-flex-row vf-border-t md:vf-px-8 vf-px-4 vf-pt-4 vf-mt-6">
            <div v-if="editSSLMode != 'none'" class="vf-flex-1 vf-text-xs vf-text-gray-3 vf-mt-2">
              <span class="vf-text-[#ffc107] vf-font-semibold">Tips:</span>
              Đối với các domain có SSL khi khởi tạo sẽ lâu hơn, bạn vui lòng đợi nhé !
            </div>
            <div class="vf-flex-1 vf-flex vf-flex-row vf-center md:vf-items-end md:vf-justify-end vf-mt-4 md:vf-mt-0 ">
              <button @click="toggleModal('modalEditDomain')" class="vf-flex-1 md:vf-flex-initial vf-border vf-rounded vf-text-gray-2 vf-center vf-px-4 vf-py-3 vf-bg-white vf-font-medium vf-text-sm vf-mr-5 hover:vf-text-primary">
                Huỷ bỏ
              </button>
              <button @click="handleEditDomain" :disabled="loading" type="button" id="btnEditDomain" class="vf-flex-1 md:vf-flex-initial vf-rounded vf-bg-primary vf-center vf-px-6 vf-py-3 vf-text-white vf-font-medium vf-text-sm ">
                <div v-if="loading">Loading <i class="fas fa-spinner fa-spin"></i></div>
                <div v-else>Cập nhật</div>
              </button>
            </div>
          </div>
        </div>
        <div @click="toggleModal('modalEditDomain')" class="vf-pointer-events-auto vf-absolute vf-top-0 vf-right-0 vf-cursor-pointer vf-flex vf-flex-col vf-items-center vf-rounded vf-h-10 vf-w-10 vf-justify-center vf-p-1 vf-text-sm ">
          <svg class="vf-fill-current vf-text-black " xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 18 18">
            <path d="M14.53 4.53l-1.06-1.06L9 7.94 4.53 3.47 3.47 4.53 7.94 9l-4.47 4.47 1.06 1.06L9 10.06l4.47 4.47 1.06-1.06L10.06 9z">
            </path>
          </svg>
        </div>
      </div>
    </div>
  </div>

  {* Popup Confirm Delete *}
  <div id="modalConfirmDelete" style="display: none;" class="vf-z-[999] vf-opacity-0 vf-pointer-events-none vf-absolute vf-w-full vf-h-full vf-top-0 vf-left-0 vf-items-center vf-justify-center vf-delay-75 vf-duration-300 vf-ease-in-out">
    <div class="vf-absolute vf-w-full vf-h-full vf-bg-gray-900 vf-opacity-60 vf-pointer-events-auto"></div>
    <div class=" vf-bg-white md:vf-max-w-full vf-rounded-lg vf-shadow-lg vf-relative vf-mx-3">
      <div class="vf-relative vf-w-full md:vf-w-[310px] vf-center vf-px-6 vf-py-5 vf-pointer-events-auto">
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

          <div class="vf-flex vf-flex-row vf-mt-2" id="alertMsg">
            <div v-if="alertMsg != '' && alertPosition == 'delete_popup'" :class="[[alertType]]" class="vf-w-full vf-flex vf-flex-row vf-mt-6 vf-px-4 vf-py-3 vf-rounded-md vf-border-l-[6px] vf-border-solid vf-border vf-bg-white vf-text-xs">
              <div class="vf-text-sm vf-text-center vf-mr-4"><i class="far fa-bell"></i></div>
              <div class="vf-text-sm"> [[alertMsg]] </div>
            </div>
          </div>

          <div class="vf-flex vf-flex-row vf-items-center vf-justify-center vf-pt-4 ">
            <button @click="toggleModal('modalConfirmDelete')" class="vf-flex-1 vf-border vf-rounded vf-text-gray-2 vf-center vf-px-4 vf-py-3 vf-bg-white vf-font-medium vf-text-sm vf-mr-5 hover:vf-text-primary">
              Huỷ bỏ
            </button>

            <button @click="handleDeleteDomain" :disabled="loading" type="button" class="vf-flex-1 vf-rounded vf-bg-primary vf-center vf-px-6 vf-py-3 vf-text-white vf-font-medium vf-text-sm hover:vf-bg-[#0E95FF] ">
              <div v-if="loading">Loading <i class="fas fa-spinner fa-spin"></i></div>
              <div v-else>Xác nhận</div>
            </button>
          </div>
        </div>
        <div @click="toggleModal('modalConfirmDelete')" class="vf-pointer-events-auto vf-absolute vf-top-0 vf-right-0 vf-cursor-pointer vf-flex vf-flex-col vf-items-center vf-rounded vf-h-10 vf-w-10 vf-justify-center vf-p-1 vf-text-sm ">
          <svg class="vf-fill-current vf-text-black " xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 18 18">
            <path d="M14.53 4.53l-1.06-1.06L9 7.94 4.53 3.47 3.47 4.53 7.94 9l-4.47 4.47 1.06 1.06L9 10.06l4.47 4.47 1.06-1.06L10.06 9z"></path>
          </svg>
        </div>
      </div>
    </div>
  </div>
</div>
<!-- END: body -->

<script>
  Helper.init('#vnx-fw-configdomain-table', 'vnx_fw_configdomain_status', {$listvhost|@json_encode nofilter}, {$serviceid});
</script>