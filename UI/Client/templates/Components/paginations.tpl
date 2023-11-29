<div v-if="totalPages > 0" id="paginations" class="vf-w-full vf-flex vf-flex-row vf-bg-white vf-rounded-sm vf-border vf-mt-6 vf-p-6">
  <div class="vf-flex vf-items-center vf-font-medium">
    Trang:
    <span>[[ currentPage ]]/[[ totalPages]]</span>
  </div>
  <div class="vf-flex-1"></div>
  <div class="vf-flex vf-flex-row">

    <div id="btn_prev" v-if="totalPages > 1" v-on:click="onClickPreviousPage()" class="vf-cursor-pointer vf-w-8 vf-h-8 vf-mr-1 vf-center vf-rounded vf-border vf-border-[#EBEBF0] vf-text-[#6C798F]"><i class="fas fa-chevron-left"></i>
    </div>

    <div v-for="page in range" :key="page" class="vf-flex vf-flex-row">
      <div @click="onClickPage(page)" v-bind:style="'' + [setCurrentPagesTyle(page)]" class="vf-cursor-pointer vf-w-8 vf-h-8 vf-mr-2 vf-center vf-rounded vf-border vf-border-[#EBEBF0] vf-text-[#6C798F]">
        [[ page ]]
      </div>
    </div>

    <div id="btn_next" v-if="totalPages > 1" v-on:click="onClickNextPage()" class="vf-cursor-pointer vf-w-8 vf-h-8 vf-center vf-rounded vf-border vf-border-[#EBEBF0] vf-text-[#6C798F]"><i class="fas fa-chevron-right"></i>
    </div>
  </div>
</div>