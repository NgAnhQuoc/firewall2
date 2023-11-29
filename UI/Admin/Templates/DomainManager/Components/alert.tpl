<div v-if="alertMsg != ''"
  class="vf-flex vf-w-full vf-flex-row vf-mt-6 vf-px-4 vf-py-3 vf-rounded-md vf-border-l-[6px] vf-border-solid vf-border vf-text-[#EB5757] vf-border-[#EB5757] vf-bg-white vf-text-xs {if $textcenter} text-center {/if}{if $additionalClasses} {$additionalClasses}{/if}{if $hide} vf-hidden {/if}">
  <div class="vf-text-xl vf-text-center "><i class="far fa-bell"></i></div>
  <div class="vf-text-xl vf-ml-4">
    [[alertMsg]]
  </div>
</div>