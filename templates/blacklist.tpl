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

	<form action="" method="POST">

	    <div class="form-horizontal">
	    	<div class="form-group" style="">
	    	    <label for="" class="col-sm-3 control-label">Blacklist IPs(*)</label>
	    	    <div class="col-sm-9">
	    	    	<textarea class="form-control" id="blacklist_ips" name="blacklist_ips" rows=10>{"\n"|implode:$service.blacklist_ips}</textarea>
	    	    </div>
	    	</div>
	    	<div class="form-group" style="">
	    	    <label for="" class="col-sm-3 control-label"></label>
	    	    <div class="col-sm-9">
	    	    	<button type="submit" class="btn btn-primary btn-edit-ip" onclick="">Save</button>
	    	    </div>
	    	</div>
	    </div>
    </form>