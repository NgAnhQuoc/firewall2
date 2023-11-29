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
			<th>Ports</th>
			<th>Action</th>
		</tr>
		{foreach from=$ips item=ip}
		<tr>
			<td>{$ip.ip}</td>
			<td>{','|implode:$ip.ports}</td>
			<td><button class="btn btn-default btn-xs edit-ip" type="button" ip="{$ip.ip}" ports="{','|implode:$ip.ports}"><i class="fa fa-edit"></i> Edit</button></td>
		</tr>
		{/foreach}
	</table>

	<div class="modal fade" id="edit_ip" tabindex="-1" role="dialog" aria-labelledby="" aria-hidden="true">
	    <div class="modal-dialog" style="width: 800px">
	        <div class="modal-content panel panel-primary">
	            <div class="modal-header panel-heading">
	                <button type="button" class="close" data-dismiss="modal">
	                    <span aria-hidden="true">×</span>
	                    <span class="sr-only">Close</span>
	                </button>
	                <h4 class="modal-title" >Edit Ports</h4>
	            </div>
	            <form action="" method="POST">
	           		<div class="modal-body panel-body">

					    <div class="form-horizontal">
					    	<div class="form-group">
					    	    <label for="" class="col-sm-3 control-label">Proxy IP (*)</label>
					    	    <div class="col-sm-9">
					    	    	<input type="text" class="form-control" id="proxy_ip" name="proxy_ip" readonly="">
					    	    </div>
					    	</div>
					    	<div class="form-group" style="">
					    	    <label for="" class="col-sm-3 control-label">Ports (*)</label>
					    	    <div class="col-sm-9">
					    	    	<textarea class="form-control" id="ports" name="ports" rows=10></textarea>
					    	    </div>
					    	</div>
					    </div>

		            </div>

		            <div id="" class="modal-footer panel-footer">
		                <button type="submit" class="btn btn-primary btn-edit-ip" onclick="">Save</button>
		                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
		            </div>
	            </form>
	        </div>
	    </div>
	</div>

	<script>
		$(document).ready(function(){
			$('.edit-ip').click(function() {
				$('#edit_ip #proxy_ip').val($(this).attr('ip'));
				$('#edit_ip #ports').val($(this).attr('ports'));

				$('#edit_ip').modal('show');
			});


		});
	</script>