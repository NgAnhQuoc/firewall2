<link href="../modules/servers/vietnix_firewall2/UI/Public/css/admin.css" rel="stylesheet" type="text/css" />
<script src="../modules/servers/vietnix_firewall2/UI/Public/js/admin.js"></script>
<!-- START: body -->
<div class="vnx-main">
  <div class="vnx-container vf-flex vf-flex-col vf-h-full" id="vnx-fw-configdomain">
    <div class="vf-flex vf-flex-col vf-bg-white vf-rounded vf-shadow-card vf-pt-6 vf-mt-6">
      <div class="vf-flex vf-flex-row">
        <div class="vf-text-3xl vf-mr-5 vf-ml-7 vf-mb-6 vf-text-gray-1 vf-font-medium ">
          Danh sách tên miền
        </div>

        <div class="vf-flex-1"></div>

        <div class="vf-flex vf-flex-row vf-px-6">
          <button type="button" @click="handleRefreshDomain"
            class="vf-border vf-border-solid vf-border-transparent vf-rounded vf-bg-[#17a2b8] hover:vf-bg-[#148091] vf-center vf-px-6 vf-py-3 vf-text-white vf-font-bold vf-text-xl vf-mr-5">
            <i class="fas fa-sync-alt" :class="loading ? 'fa-spin' :''"></i>
            <span class=" vf-ml-2">Refresh</span>
          </button>

          <button type="button" @click="modalTarget = 'addDomain'" data-target="#configDomainModal" data-toggle="modal"
            class="vf-border vf-border-solid vf-border-transparent vf-rounded vf-bg-primary vf-center vf-px-6 vf-py-3 vf-text-white vf-font-bold vf-text-xl hover:vf-bg-[#0E95FF]">
            <i class="fas fa-plus fa-sm vf-mr-2"></i>
            <span>Thêm tên miền</span>
          </button>
        </div>
      </div>

      <div class="vnx-table-firewallweb-list-domain vnx__table vf-border-none" id="vnx-fw-configdomain-table">
        <div
          class="vnx__table--header vf-hidden md:vf-flex vf-bg-transparent vf-border-t-0 vf-border-b-[1px] vf-px-7 vf-text-[14px] vf-text-gray-3">
          <div class="vnx__table--col vf-flex-1">Domain</div>
          <div class="vnx__table--col vf-flex-1">Backend</div>
          <div class="vnx__table--col vf-flex-1">SSL</div>
          <div class="vnx__table--col vf-w-40 vf-center">Force SSL</div>
          <div class="vnx__table--col vf-w-40 vf-text-right"></div>
        </div>

        <div class="vnx__table--body vf-hidden md:vf-block vf-text-gray-1">
          <div v-if="!dataTable || dataTable.length == 0" class="vf-center vf-py-8 vf-text-gray-2"
            style="border-radius: 0 0 6px 6px;">
            Không có domain nào
          </div>

          <template v-for="(item, index) in pages">
            <div :id="'foo-' + index" class="vf-px-7 vf-border-b vf-border-[#EBEBF0]  vnx__table--row vf-items-center">
              <div class="vnx__table--col vf-flex-1">
                <div class="vf-flex-1 vf-flex vf-flex-row vf-text-xl">
                  <div class="vf-flex vf-items-center vf-justify-center">
                    <!-- toggle -->
                    <i v-if="loading==true && selectedDomain==item.vhost"
                      class="fas fa-spinner fa-spin vf-text-primary"></i>
                    <div v-else @click="[selectedDomain = item.vhost, handleOnOffDomain()]"
                      class="vf-relative vf-cursor-pointer">
                      <input :checked="item.enable==true" type="checkbox" class="vf-sr-only vf-border">
                      <div class="vf-block vf-bg-primary vf-w-8 vf-h-[14px] vf-rounded-full"></div>
                      <div
                        class="dot vf-absolute vf-right-[8px] vf-top-[3px] vf-bg-white vf-w-3 vf-h-3 vf-rounded-full vf-transition">
                      </div>
                    </div>
                    <!-- toggle -->
                  </div>
                  <div class="vf-flex-1 vf-ml-2">[[item.vhost]]</div>
                </div>

              </div>

              <div class="vnx__table--col vf-flex-1">
                <div class="vf-text-xl origin">
                  [[item.beIP]]
                </div>
              </div>

              <div class="vnx__table--col vf-flex-1">
                <div
                  :class="item.sslMode == 'none' ? 'sslmode sslmode-none' : (item.sslMode == 'flex' ? 'sslmode sslmode-flexible' : 'sslmode sslmode-full')">
                  [[item.sslMode == 'none' ? 'None' : (item.sslMode == 'flex' ? 'Flexible' : 'Full')]]
                </div>
              </div>

              <div class="vnx__table--col vf-w-40 vf-flex vf-center">
                <div class="vf-relative">
                  <input type="checkbox" class="sslredirect vf-sr-only vf-border" :checked="item.forceSSL != 'no'">
                  <div class="vf-block vf-bg-primary vf-w-8 vf-h-[14px] vf-rounded-full"></div>
                  <div
                    class="dot vf-absolute vf-left-[3px] vf-top-[3px] vf-bg-white vf-w-3 vf-h-3 vf-rounded-full vf-transition">
                  </div>
                </div>
              </div>

              <div class="vnx__table--col vf-w-40 vf-text-right vf-flex  vf-justify-end vf-items-center">
                <button type="button" @click="[modalTarget = 'confirmDelete', selectedDomain = item.vhost]"
                  data-target="#configDomainModal" data-toggle="modal"
                  class="vf-w-8 vf-h-8 vf-center vf-border vf-rounded vf-text-red-500 vf-border-solid vf-border-red-500 vf-p-[18px] vf-bg-white vf-mr-2"
                  :data-value="item.vhost">
                  <i class="far fa-trash"></i>
                </button>
                <button type="button" :disabled="!item.enable"
                  @click="[modalTarget = 'edit_vhost', selectedDomain = item.vhost, fillContentModalEditDomain()]"
                  data-target="#configDomainModal" data-toggle="modal" class="btnVfEditDomain vf-center vf-px-[20px] vf-py-[7px] vf-border vf-border-solid vf-rounded vf-text-gray-1
            vf-border-[#EBEBF0] vf-bg-white" :domain-value="item.vhost" :backend-value="item.origin">
                  Edit
                </button>
              </div>
            </div>
          </template>
        </div>
      </div>
    </div>

    {* Paginations *}
    {include file="./Components/paginations.tpl"}
    {* /Paginations *}

    <div class="vf-flex-1 vf-mb-7"></div>

    <div class="modal fade" id="configDomainModal" tabindex="-1">
      <div class="vf-h-full vf-center">
        <div class="vf-bg-white vf-rounded-lg vf-shadow-lg vf-relative vf-p-4">
          {* Add domain *}
          <div v-if="modalTarget == 'addDomain'"
            class="vf-relative vf-w-full md:vf-w-[640px] vf-py-6 vf-max-h-screen vf-overflow-y-auto vf-pointer-events-auto">
            <div class="vf-pointer-events-auto">
              <div class="vf-text-3xl vf-font-bold vf-px-8 vf-pb-10 vf-text-gray-900">Thêm tên miền</div>

              <div>
                <input type="hidden" name="cmd" value="add_domain" />
                <div class="vf-flex vf-flex-row vf-px-8 vf-mt-4">
                  <div class="vf-flex-1 vf-mr-2 vf-text-gray-1">
                    <label for="addInputDomain" class="vf-text-2xl vf-mb-4">
                      Domain
                      <span class="vf-text-red-500 vf-ml-[2px]">*</span>
                    </label>
                    <div class="vf-flex vf-flex-row vf-center vf-text-gray-3 vf-mb-5">
                      <input data-toggle="tooltip" data-placement="bottom" title="This field required"
                        data-trigger="manual" style="border-top: 1px solid #EBEBF0; border-left: 1px solid #EBEBF0"
                        class="vf-flex-1 vf-h-[38px] vf-rounded-md vf-text-[#6C798F] vf-font-normal vf-text-base vf-outline-none vf-border vf-border-[#EBEBF0]"
                        id="addInputDomain" type="text" name="fw_domain" v-model="addDomain" value=""
                        placeholder="Nhập domain của bạn">
                    </div>
                  </div>

                  <div class="vf-flex-1 vf-ml-2 vf-text-base vf-font-normal vf-text-gray-1">
                    <label for="addInputBackend" class="vf-text-2xl vf-mb-4">
                      Backend
                      <span class="vf-text-red-500 vf-ml-[2px]">*</span>
                    </label>
                    <div class="vf-flex vf-flex-row vf-center vf-text-gray-3 vf-mb-5">
                      <input data-toggle="tooltip" data-placement="bottom" title="This field required"
                        data-trigger="manual" style="border-top: 1px solid #EBEBF0; border-left: 1px solid #EBEBF0"
                        class="vf-flex-1 vf-h-[38px] vf-rounded-md vf-text-[#6C798F] vf-font-normal vf-text-base vf-outline-none vf-border vf-border-[#EBEBF0]"
                        id="addInputBackend" type="text" name="fw_backend" v-model="addBackend" value=""
                        placeholder="Nhập Backend của bạn">
                    </div>
                  </div>
                </div>

                <div class="vf-flex vf-flex-row vf-px-8 vf-mt-2">
                  <div class="vf-flex vf-flex-col vf-w-1/2 vf-mr-2 vf-text-base vf-font-normal vf-text-gray-1">
                    <label class="vf-text-2xl vf-mb-4">
                      SSL Mode
                    </label>
                    <div class="vf-flex vf-flex-row vf-center vf-mb-5">
                      <select v-model="addSSLMode" name="sslmode" id="add-sslmode" class=" vf-text-xl vf-text-gray-3 vf-rounded vf-border vf-border-[#EBEBF0] vf-px-2 vf-w-full
              vf-h-[38px] vf-leading-normal vf-outline-none">
                        <option value="">&#9679; None</option>
                        <option value="flex">&#9679; Flexible</option>
                        <option value="full">&#9679; Full</option>
                      </select>
                    </div>
                  </div>

                  <div v-if="addSSLMode != ''"
                    class="vf-flex vf-flex-col vf-w-1/2 vf-ml-2 vf-text-base vf-font-normal vf-text-gray-1">
                    <label class="vf-text-2xl vf-mb-4">
                      Force SSL
                    </label>
                    <div
                      class="vf-flex vf-flex-row vf-items-center vf-bg-[#F4F6FD] vf-h-[38px] vf-text-gray-3 vf-mb-5 vf-px-3 vf-rounded-[4px]">
                      <div class="vf-flex-1">
                        <div class="vf-select-none vf-text-xl">Trạng thái</div>
                      </div>
                      <div class="vf-flex-1 vf-flex vf-justify-end">
                        <label for="toggle-force-ssl" class="vf-my-auto vf-cursor-pointer">
                          <!-- toggle -->
                          <div class="vf-relative">
                            <!-- input -->
                            <input type="checkbox" id="toggle-force-ssl" class="vf-sr-only vf-border" name="fw_forcessl"
                              v-model="addForceSSL">
                            <!-- line -->
                            <div class="vf-block vf-bg-primary vf-w-8 vf-h-[14px] vf-rounded-full"></div>
                            <!-- dot -->
                            <div
                              class="dot vf-absolute vf-left-[3px] vf-top-[3px] vf-bg-white vf-w-3 vf-h-3 vf-rounded-full vf-transition">
                            </div>
                          </div>
                        </label>
                      </div>
                      <!-- toggle -->
                    </div>
                  </div>
                </div>

                <!-- BEGIN UPLOAD SSL -->
                <div v-if="addSSLMode != ''" class="vf-flex vf-flex-row vf-px-8 vf-mt-2">
                  <div class="vf-flex vf-w-1/2 vf-flex-col vf-mr-2 vf-text-base vf-font-normal vf-text-gray-1">
                    <label class="vf-text-2xl vf-mb-4">
                      SSL Type
                    </label>
                    <div class="vf-flex vf-flex-row  vf-mb-5">
                      <select v-model="addCustomSSL" name="sslmode" id="add-sslmode"
                        class="vf-text-xl vf-text-gray-3 vf-rounded vf-border vf-border-[#EBEBF0] vf-px-2 vf-w-full vf-h-[38px] vf-leading-normal vf-outline-none">
                        <option value="">&#9679; Miễn phí</option>
                        <option value="yes">&#9679; Upload</option>
                      </select>
                    </div>
                  </div>
                </div>

                <div v-if="addCustomSSL == 'yes' && addSSLMode != ''" class="vf-flex vf-flex-col vf-px-8 vf-mt-2">
                  <div class="vf-flex vf-flex-col">
                    <div class="vf-flex vf-flex-row vf-mt-4">
                      <div class="vf-flex-1 vf-mr-2 vf-text-base vf-font-normal vf-text-gray-1">
                        CRT
                      </div>
                      <div class="vf-flex vf-items-end vf-text-primary vf-cursor-pointer "
                        onclick="copyToClipboard('crt-ssl')">
                        <span class="vf-mr-1"><i class="far fa-copy"></i></span>Copy
                      </div>
                    </div>

                    <div class="vf-flex vf-flex-row vf-mt-2">
                      <textarea id="crt-ssl" name="crt-ssl" v-model="addCRT"
                        class="vf-resize-none vf-overscroll-y-auto vf-h-32 vf-text-white vf-w-full vf-bg-[#013A52] vf-rounded-[3px] vf-p-3"></textarea>
                    </div>
                  </div>

                  <div class="vf-flex vf-flex-col">
                    <div class="vf-flex vf-flex-row vf-mt-4">
                      <div class="vf-flex-1 vf-mr-2 vf-text-base vf-font-normal vf-text-gray-1">
                        KEY
                      </div>
                      <div class="vf-flex vf-items-end vf-text-primary vf-cursor-pointer "
                        onclick="copyToClipboard('key-ssl')">
                        <span class="vf-mr-1"><i class="far fa-copy"></i></span>Copy
                      </div>
                    </div>

                    <div class="vf-flex vf-flex-row vf-mt-2">
                      <textarea id="key-ssl" name="key-ssl" v-model="addKEY"
                        class="vf-resize-none vf-overscroll-y-auto vf-h-32 vf-text-white vf-w-full vf-bg-[#013A52] vf-rounded-[3px] vf-p-3"></textarea>
                    </div>
                  </div>

                  <div class="vf-flex vf-flex-col">
                    <div class="vf-flex vf-flex-row vf-mt-4">
                      <div class="vf-flex-1 vf-mr-2 vf-text-base vf-font-normal vf-text-gray-1">
                        CA
                      </div>
                      <div class="vf-flex vf-items-end vf-text-primary vf-cursor-pointer "
                        onclick="copyToClipboard('ca-ssl')">
                        <span class="vf-mr-1"><i class="far fa-copy"></i></span>Copy
                      </div>
                    </div>

                    <div class="vf-flex vf-flex-row vf-mt-2">
                      <textarea id="ca-ssl" name="ca-ssl" v-model="addCA"
                        class="vf-resize-none vf-overscroll-y-auto vf-h-32 vf-text-white vf-w-full vf-bg-[#013A52] vf-rounded-[3px] vf-p-3"></textarea>
                    </div>
                  </div>
                </div>
                <!-- BEGIN UPLOAD SSL -->


                <div class="vf-flex vf-flex-row vf-px-8 vf-mt-2">
                  {include file="./Components/alert.tpl"}
                </div>

                <div class="vf-flex vf-flex-row vf-items-end vf-justify-end vf-border-t vf-px-8 vf-pt-4 vf-mt-6">
                  <button data-dismiss="modal" class="btn btn-default vf-mr-3">
                    Huỷ bỏ
                  </button>

                  <button @click="handleAddDomain" type="button" :disabled="loading"
                    class="vf-border vf-border-solid vf-border-transparent vf-rounded vf-bg-primary vf-center vf-px-6 vf-py-3 vf-text-white vf-font-bold vf-text-xl hover:vf-bg-[#0E95FF]"
                    id="submit-add-domain" data-loading-text="<i class='fa fa-spinner fa-spin '></i>">
                    <div v-if="loading">
                      Loading <i class="fas fa-spinner fa-spin"></i>
                    </div>
                    <div v-else>
                      Thêm mới
                    </div>
                  </button>
                </div>
              </div>
            </div>

            <div
              class="btn-close-adddomain-modal vf-pointer-events-auto vf-absolute vf-top-2 vf-right-3 vf-cursor-pointer vf-flex vf-flex-col vf-items-center vf-rounded vf-h-10 vf-w-10 vf-justify-center vf-p-1 vf-text-base "
              data-dismiss="modal">
              <svg class="vf-fill-current vf-text-black " xmlns="http://www.w3.org/2000/svg" width="18" height="18"
                viewBox="0 0 18 18">
                <path
                  d="M14.53 4.53l-1.06-1.06L9 7.94 4.53 3.47 3.47 4.53 7.94 9l-4.47 4.47 1.06 1.06L9 10.06l4.47 4.47 1.06-1.06L10.06 9z">
                </path>
              </svg>
            </div>

          </div>
          {* Edit Domain *}
          <div v-else-if="modalTarget == 'edit_vhost'"
            class="vf-relative vf-w-full md:vf-w-[640px] vf-py-6 vf-max-h-screen vf-overflow-y-auto vf-pointer-events-auto">
            {* Form Edit Domain *}
            <div>
              <input type="hidden" name="cmd" value="update_domain" />
              <input type="hidden" name="fw_domain" value="" id="updateDomain" />
              <div class="vf-pointer-events-auto ">
                <h3 class="vf-text-3xl vf-font-bold vf-px-8 vf-pb-10 vf-text-gray-900">Chỉnh sửa tên miền</h3>

                <div class="vf-flex vf-flex-row vf-px-8 vf-mt-4">
                  <div class="vf-flex-1 vf-mr-2 vf-text-base vf-font-normal vf-text-gray-1">
                    <label for="inputDomain" class="vf-text-2xl vf-mb-4">
                      Domain
                    </label>
                    <div class="vf-flex vf-flex-row vf-center vf-text-gray-3 vf-mb-5">
                      <input
                        class="vf-flex-1  vf-rounded-md vf-text-[#6C798F] vf-font-normal vf-text-base vf-border-solid vf-h-[38px]"
                        type="text" v-model="edit_vhost" name="fw_domain" id="inputUpdateDomain"
                        placeholder="Nhập domain của bạn" value="" disabled>
                    </div>
                  </div>

                  <div class="vf-flex-1 vf-ml-2 vf-text-base vf-font-normal vf-text-gray-1">
                    <label for="inputBackend" class="vf-text-2xl vf-mb-4">
                      Backend
                    </label>
                    <div class="vf-flex vf-flex-row vf-center vf-text-gray-3 vf-mb-5">
                      <input
                        class="vf-flex-1  vf-rounded-md vf-border-[#EBEBF0] vf-text-[#6C798F] vf-font-normal vf-text-base vf-border-solid vf-h-[38px]"
                        type="text" v-model="edit_beIP" id="inputUpdateBackend" placeholder="Nhập Backend của bạn"
                        value="">
                    </div>
                  </div>
                </div>

                <div class="vf-flex vf-flex-row vf-px-8 vf-mt-2">
                  <div class="vf-flex vf-flex-col vf-w-1/2 vf-mr-2 vf-text-base vf-font-normal vf-text-gray-1">
                    <label for="inputEmail" class="vf-text-2xl vf-mb-4">
                      SSL Mode
                    </label>
                    <div class="vf-flex vf-flex-row vf-center vf-mb-5">
                      <select id="updateSSLMode" v-model="edit_sslMode"
                        class="vf-text-xl vf-text-gray-3 vf-rounded vf-border vf-border-[#EBEBF0] vf-px-2 vf-w-full vf-h-[38px] vf-leading-normal vf-outline-none">
                        <option value="none">&#9679; None</option>
                        <option value="flex">&#9679; Flexible</option>
                        <option value="full">&#9679; Full</option>
                      </select>
                    </div>
                  </div>

                  <div v-if="edit_sslMode != 'none'"
                    class="vf-flex vf-flex-col vf-w-1/2 vf-ml-2 vf-text-base vf-font-normal vf-text-gray-1">
                    <label for="inputEmail" class="vf-text-2xl vf-mb-4">
                      Force SSL
                    </label>
                    <div
                      class="vf-flex vf-flex-row vf-items-center vf-bg-[#F4F6FD] vf-h-[38px] vf-text-gray-3 vf-mb-5 vf-px-3 vf-rounded-[4px]">
                      <div class="vf-flex-1">
                        <div class="vf-select-none vf-text-xl">Trạng thái</div>
                      </div>
                      <div class="vf-flex-1 vf-flex vf-justify-end">
                        <label for="toggle-edit-force-ssl" class="vf-my-auto vf-cursor-pointer">
                          <!-- toggle -->
                          <div class="vf-relative">
                            <!-- input -->
                            <input type="checkbox" id="toggle-edit-force-ssl" class="vf-sr-only vf-border"
                              v-model="edit_forceSSL">
                            <!-- line -->
                            <div class="vf-block vf-bg-primary vf-w-8 vf-h-[14px] vf-rounded-full"></div>
                            <!-- dot -->
                            <div
                              class="dot vf-absolute vf-left-[3px] vf-top-[3px] vf-bg-white vf-w-3 vf-h-3 vf-rounded-full vf-transition">
                            </div>
                          </div>
                        </label>
                      </div>
                      <!-- toggle -->
                    </div>
                  </div>
                </div>

                <div v-if="edit_sslMode != 'none' && edit_sslStartDate != 'none' && edit_sslEndDate != 'none'"
                  class="vf-flex vf-flex-col md:vf-flex-row vf-px-4 md:vf-px-8 vf-mt-2">
                  <div
                    class="vf-flex vf-flex-col vf-w-full md:vf-w-1/2 vf-mr-2 vf-text-xl vf-font-normal vf-text-gray-1">
                    <label for="editStartDate" class="vf-mb-4 vf-text-xl">
                      Ngày bắt đầu
                    </label>
                    <div
                      class="vf-flex vf-flex-row vf-items-center vf-bg-[#F4F6FD] vf-h-[38px] vf-text-gray-3 vf-mb-5 vf-px-3 vf-rounded-[4px]">
                      [[edit_sslStartDate]]
                    </div>
                  </div>
                  <div
                    class="vf-flex vf-flex-col vf-w-full md:vf-w-1/2 md:vf-ml-2 vf-text-xl vf-font-normal vf-text-gray-1">
                    <label for="editEndDate" class="vf-mb-4 vf-text-xl">
                      Ngày kết thúc
                    </label>
                    <div
                      class="vf-flex vf-flex-row vf-items-center vf-bg-[#F4F6FD] vf-h-[38px] vf-text-gray-3 vf-mb-5 vf-px-3 vf-rounded-[4px]">
                      [[edit_sslEndDate]]
                    </div>
                  </div>
                </div>

                <!-- BEGIN UPLOAD SSL -->
                <div v-if="edit_sslMode != 'none'" class="vf-flex vf-flex-row vf-px-8 vf-mt-2">
                  <div class="vf-flex vf-w-1/2 vf-flex-col vf-mr-2 vf-text-base vf-font-normal vf-text-gray-1">
                    <label class="vf-text-2xl vf-mb-4">
                      SSL Type
                    </label>
                    <div class="vf-flex vf-flex-row  vf-mb-5">
                      <select v-model="edit_customSSL" name="sslmode" id="add-sslmode"
                        class="vf-text-xl vf-text-gray-3 vf-rounded vf-border vf-border-[#EBEBF0] vf-px-2 vf-w-full vf-h-[38px] vf-leading-normal vf-outline-none">
                        <option value="no">&#9679; Miễn phí</option>
                        <option value="yes">&#9679; Upload</option>
                      </select>
                    </div>
                  </div>

                  <div v-if="edit_sslStatus != 'none'"
                    class="vf-flex vf-flex-col vf-w-full md:vf-w-1/2 md:vf-ml-2 vf-text-2xl vf-font-normal vf-text-gray-1">
                    <label for="editEndDate" class="vf-mb-4">
                      Trạng thái SSL
                    </label>
                    <div
                      class="vf-flex vf-flex-row vf-items-center vf-bg-[#F4F6FD] vf-h-[38px] vf-text-gray-3 vf-mb-5 vf-px-3 vf-rounded-[4px]">
                      <div class="sslmode sslstatus vf-capitalize" :class="[[edit_sslStatus]]">[[edit_sslStatus]]</div>
                    </div>
                  </div>
                </div>

                <div v-if="edit_customSSL == 'yes' && edit_sslMode != 'none'"
                  class="vf-flex vf-flex-col vf-px-8 vf-mt-2">
                  <div class="vf-flex vf-flex-col">
                    <div class="vf-flex vf-flex-row vf-mt-4">
                      <div class="vf-flex-1 vf-mr-2 vf-text-base vf-font-normal vf-text-gray-1">
                        CRT
                      </div>
                      <div class="vf-flex vf-items-end vf-text-primary vf-cursor-pointer "
                        onclick="copyToClipboard('crt-ssl')">
                        <span class="vf-mr-1"><i class="far fa-copy"></i></span>Copy
                      </div>
                    </div>

                    <div class="vf-flex vf-flex-row vf-mt-2">
                      <textarea id="crt-ssl" name="crt-ssl" v-model="edit_cert"
                        class="vf-resize-none vf-overscroll-y-auto vf-h-32 vf-text-white vf-w-full vf-bg-[#013A52] vf-rounded-[3px] vf-p-3"></textarea>
                    </div>
                  </div>

                  <div class="vf-flex vf-flex-col">
                    <div class="vf-flex vf-flex-row vf-mt-4">
                      <div class="vf-flex-1 vf-mr-2 vf-text-base vf-font-normal vf-text-gray-1">
                        KEY
                      </div>
                      <div class="vf-flex vf-items-end vf-text-primary vf-cursor-pointer "
                        onclick="copyToClipboard('key-ssl')">
                        <span class="vf-mr-1"><i class="far fa-copy"></i></span>Copy
                      </div>
                    </div>

                    <div class="vf-flex vf-flex-row vf-mt-2">
                      <textarea id="key-ssl" name="key-ssl" v-model="edit_key"
                        class="vf-resize-none vf-overscroll-y-auto vf-h-32 vf-text-white vf-w-full vf-bg-[#013A52] vf-rounded-[3px] vf-p-3"></textarea>
                    </div>
                  </div>

                  <div class="vf-flex vf-flex-col">
                    <div class="vf-flex vf-flex-row vf-mt-4">
                      <div class="vf-flex-1 vf-mr-2 vf-text-base vf-font-normal vf-text-gray-1">
                        CA
                      </div>
                      <div class="vf-flex vf-items-end vf-text-primary vf-cursor-pointer "
                        onclick="copyToClipboard('ca-ssl')">
                        <span class="vf-mr-1"><i class="far fa-copy"></i></span>Copy
                      </div>
                    </div>

                    <div class="vf-flex vf-flex-row vf-mt-2">
                      <textarea id="ca-ssl" name="ca-ssl" v-model="edit_ca" class=" vf-resize-none vf-overscroll-y-auto vf-h-32 vf-text-white vf-w-full vf-bg-[#013A52]
                        vf-rounded-[3px] vf-p-3"></textarea>
                    </div>
                  </div>
                </div>
                <!-- BEGIN UPLOAD SSL -->

                <div class="vf-flex vf-flex-row vf-px-8 vf-mt-2">
                  {include file="./Components/alert.tpl"}
                </div>

                <div class="vf-flex vf-flex-row vf-items-end vf-justify-end vf-border-t vf-px-8 vf-pt-4 vf-mt-6">
                  <button data-dismiss="modal"
                    class="btn-close-delete-modal vf-border vf-border-solid vf-border-[#ebebf0] vf-rounded vf-text-gray-2 vf-center vf-px-4 vf-py-3 vf-bg-white vf-font-bold vf-text-xl vf-mr-5 hover:vf-text-primary">
                    Huỷ bỏ
                  </button>

                  <button @click="handleEditDomain" type="button" id="adminBtnEditDomain" :disabled="loading"
                    class="vf-border vf-border-solid vf-border-transparent vf-rounded vf-bg-primary vf-center vf-px-6 vf-py-3 vf-text-white vf-font-bold vf-text-xl hover:vf-bg-[#0E95FF]">
                    <div v-if="loading">
                      Loading <i class="fas fa-spinner fa-spin"></i>
                    </div>
                    <div v-else>
                      Cập nhật
                    </div>
                  </button>
                </div>
              </div>
            </div>
            <div data-dismiss="modal"
              class="btn-close-editdomain-modal vf-pointer-events-auto vf-absolute vf-top-0 vf-right-0 vf-cursor-pointer vf-flex vf-flex-col vf-items-center vf-rounded vf-h-10 vf-w-10 vf-justify-center vf-p-1 vf-text-base ">
              <svg class="vf-fill-current vf-text-black " xmlns="http://www.w3.org/2000/svg" width="18" height="18"
                viewBox="0 0 18 18">
                <path
                  d="M14.53 4.53l-1.06-1.06L9 7.94 4.53 3.47 3.47 4.53 7.94 9l-4.47 4.47 1.06 1.06L9 10.06l4.47 4.47 1.06-1.06L10.06 9z">
                </path>
              </svg>
            </div>
          </div>

          {* Confirm Delete *}
          <div v-else="modalTarget == 'confirmDelete'"
            class="vf-relative vf-w-full md:vf-w-[310px] vf-center vf-py-5 vf-pointer-events-auto">
            {* Form Confirm Delete  *}
            <div>
              <input type="hidden" name="cmd" value="delete_domain" />
              <input type="hidden" name="fw_domain" value="" id="inputDomainRemoveItem" />
              <div class="vf-pointer-events-auto ">
                <div class="vf-text-[#F2994A] vf-text-8xl vf-text-center vf-font-medium vf-my-6">
                  <i class="far fa-exclamation-circle"></i>
                </div>
                <div class="vf-text-[#25282B] vf-text-3xl vf-text-center vf-font-bold vf-mt-2">
                  BẠN CHẮC CHẮN MUỐN XÓA?
                </div>
                <div class="vf-text-[#52575C] vf-text-xl vf-font-semibold vf-text-center vf-mt-2">
                  Dữ liệu sẽ bị xóa và không thể khôi phục
                </div>
                <div class="vf-flex vf-flex-row vf-items-center vf-justify-center vf-px-8 vf-pt-4 ">
                  <button data-dismiss="modal"
                    class="btn-close-delete-modal vf-border vf-border-solid vf-border-[#ebebf0] vf-rounded vf-text-gray-2 vf-center vf-px-4 vf-py-3 vf-bg-white vf-font-bold vf-text-xl vf-mr-5 hover:vf-text-primary">
                    Huỷ bỏ
                  </button>

                  <button @click="handleDeleteDomain" type="button" id="btnConfirmDeleteDomain" :disabled="loading"
                    class="vf-border vf-border-solid vf-border-transparent vf-rounded vf-bg-primary vf-center vf-px-6 vf-py-3 vf-text-white vf-font-bold vf-text-xl hover:vf-bg-[#0E95FF]">
                    <div v-if="loading">
                      Loading <i class="fas fa-spinner fa-spin"></i>
                    </div>
                    <div v-else>
                      Xác nhận
                    </div>
                  </button>
                </div>
              </div>
            </div>

            <div data-dismiss="modal"
              class="btn-close-delete-modal vf-pointer-events-auto vf-absolute vf-top-0 vf-right-0 vf-cursor-pointer vf-flex vf-flex-col vf-items-center vf-rounded vf-h-10 vf-w-10 vf-justify-center vf-p-1 vf-text-base ">
              <svg class="vf-fill-current vf-text-black " xmlns="http://www.w3.org/2000/svg" width="18" height="18"
                viewBox="0 0 18 18">
                <path
                  d="M14.53 4.53l-1.06-1.06L9 7.94 4.53 3.47 3.47 4.53 7.94 9l-4.47 4.47 1.06 1.06L9 10.06l4.47 4.47 1.06-1.06L10.06 9z">
                </path>
              </svg>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<!-- END: body -->

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

  .sslmode {
    position: relative;
    border-radius: 999px;
    padding: 4px 12px 4px 16px;
    line-height: 14px;
    background: transparent;
  }

  .sslmode::before {
    top: 7px;
    left: 0px;
    position: absolute;
    content: " ";
    height: 9px;
    width: 9px;
    background: #8c9cb5;
    border-radius: 50%;
  }

  .sslmode.sslmode-none {
    color: #6C798F;
  }

  .sslmode.sslmode-none::before {
    background: #6C798F;
  }

  .sslmode.sslmode-flexible {
    color: #38A7FF;
  }

  .sslmode.sslmode-flexible::before {
    background: #38A7FF;
  }

  .sslmode.sslmode-full {
    color: #27AE60;
  }

  .sslmode.sslmode-full::before {
    background: #27AE60;
  }
</style>

<script>
  var vm = Helper.initTableData('#vnx-fw-configdomain', 'vnx_fw_configdomain_status', {$listvhost|@json_encode nofilter}, {$params.serviceid});

  jQuery(document).ready(function() {
    $('.modal').on('hidden.bs.modal', function() {
      vm.resetModalContent();
    })
  });

  function copyToClipboard(element) {
    var copyText = document.getElementById(element);
    copyText.select();
    copyText.setSelectionRange(0, 99999); /* For mobile devices */
    document.execCommand("copy");
    alert("Copied the text to clipboard.");
  }
</script>