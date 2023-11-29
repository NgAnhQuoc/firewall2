	<style>
	.modal .modal-body {
	    max-height: 500px;
	    overflow-y: auto;
	}
	.error {
		color: red;
		font-weight: bold;
	}
	</style>

	{if $success_info}
		<div class="alert alert-block alert-success fade in">{$success_info}</div>
	{/if}
	{if $info}
		<div class="alert alert-block alert-info fade in">{$info}</div>
	{/if}
	{if $error}
		<div class="alert alert-block alert-danger fade in">{$error}</div>
	{/if}

	<table class="table table-striped table-bordered">
		<tr>
			<th>Proxy IP</th>
			<th>Blocked IPs</th>
			<th>Action</th>
		</tr>
		{foreach from=$ips item=ip}
		<tr>
			<td>{$ip.ip}</td>
			<td><textarea class="form-control" name="blocked_ips" rows=10>{"\n"|implode:$ip.blocked_ips}</textarea></td>
			<td><button class="btn btn-default btn-xs unblock-ip" type="button" ip="{$ip.ip}" ><i class="fa fa-unlock"></i>  Unblock IP</button>  <button class="btn btn-default btn-xs unblock-ips" type="button" blocked_ips='{"\n"|implode:$ip.blocked_ips}' ip="{$ip.ip}" ><i class="fa fa-unlock"></i>  Unblock All</button></td>
		</tr>
		{/foreach}
	</table>

	<div class="modal fade" id="unblock_ip" tabindex="-1" role="dialog" aria-labelledby="" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content panel panel-primary">
	            <div class="modal-header panel-heading">
	                <button type="button" class="close" data-dismiss="modal">
	                    <span aria-hidden="true">×</span>
	                    <span class="sr-only">Close</span>
	                </button>
	                <h4 class="modal-title" >Unblock IP</h4>
	            </div>
	            <form action="" method="POST">
	            	<input type="hidden" name="proxy_ip" id="proxy_ip">
	            	
	            	

	           		<div id="" class="modal-body panel-body">
	           			<div class="form-horizontal">
	           				<div class="form-group" style="">
	           				    <label for="" class="col-sm-2 control-label"> IP(*)</label>
	           				    <div class="col-sm-10">
	           				    	<input type="text" class="form-control" name="blocked_ips" id="blocked_ips">
	           				    </div>
	           				</div>
	           			</div>
		            </div>
		            <div id="" class="modal-footer panel-footer">
		                <button type="submit" class="btn btn-primary btn-danger">Yes</button>
		                <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
		            </div>
	            </form>
	        </div>
	    </div>
	</div>

	<div class="modal fade" id="unblock_ips" tabindex="-1" role="dialog" aria-labelledby="" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content panel panel-primary">
	            <div class="modal-header panel-heading">
	                <button type="button" class="close" data-dismiss="modal">
	                    <span aria-hidden="true">×</span>
	                    <span class="sr-only">Close</span>
	                </button>
	                <h4 class="modal-title" >Unblock All</h4>
	            </div>
	            <form action="" method="POST">
	            	<input type="hidden" name="proxy_ip" id="proxy_ip">
	            	<input type="hidden" name="blocked_ips" id="blocked_ips">

	           		<div id="" class="modal-body panel-body">
	           			<br>
					    Are you sure you want to unblock all blocked IPs?
					    <br><br>
		            </div>
		            <div id="" class="modal-footer panel-footer">
		                <button type="submit" class="btn btn-primary btn-danger">Yes</button>
		                <button type="button" class="btn btn-default" data-dismiss="modal">No</button>
		            </div>
	            </form>
	        </div>
	    </div>
	</div>

	<script>
		$(document).ready(function(){
			$('.unblock-ip').click(function() {
				$('#unblock_ip #proxy_ip').val($(this).attr('ip'));

				$('#unblock_ip').modal('show');
			});

			$('.unblock-ips').click(function() {
				$('#unblock_ips #proxy_ip').val($(this).attr('ip'));
				$('#unblock_ips #blocked_ips').val($(this).attr('blocked_ips'));

				$('#unblock_ips').modal('show');
			});


		});
	</script>