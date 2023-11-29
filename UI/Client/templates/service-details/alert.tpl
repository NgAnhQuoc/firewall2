{assign var="alertColor" value=''}

{if $type eq "error"}
  {$alertColor = 'vf-text-[#EB5757] vf-border-[#EB5757]'}
{elseif $type eq "success"}
  {$alertColor = 'vf-text-[#28a745] vf-border-[#28a745]'}
{elseif $type eq "info"}
  {$alertColor = 'vf-text-[#17a2b8] vf-border-[#17a2b8]'}
{elseif $type eq "warning"}
  {$alertColor = 'vf-text-[#ffc107] vf-border-[#ffc107]'}
{else}
  {$alertColor = 'vf-text-primary vf-border-primary'}
{/if}

<div class="vf-flex vf-flex-row vf-mt-6 vf-px-4 vf-py-3 vf-rounded-md vf-border-l-[6px] vf-border {$alertColor} vf-bg-white vf-text-xs {if $textcenter} text-center {/if}{if $additionalClasses} {$additionalClasses}{/if}{if $hide} vf-hidden {/if}"
  {if $idname} id="{$idname}" {/if}>
  <div class="vf-text-sm vf-text-center vf-mr-4"><i class="far fa-bell"></i></div>
  <div class="vf-text-sm">
    {if $errorshtml}
      <strong>{lang key='clientareaerrors'}</strong>
      <ul>
        {$errorshtml}
      </ul>
    {else}
      {if $title}
        <div>{$title}</div>
      {/if}
      {$msg}
    {/if}
  </div>
</div>