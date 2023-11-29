<?php
ini_set('default_socket_timeout', 4);

class newssh2key
{
	public $connection;

	function newssh2key($host, $port)
	{
		$this->connection = ssh2_connect($host, $port, array('hostkey' => 'ssh-rsa'));
	}

	function loginkey($username, $pubkeyfile, $privkeyfile)
	{
		if (ssh2_auth_pubkey_file($this->connection, $username, $pubkeyfile, $privkeyfile)) {
			return 1;
		} else {
			return 0;
		}
	}

	function exec($command)
	{
		$stream = ssh2_exec($this->connection, $command . ' 2>&1');
		stream_set_blocking($stream, true);

		$data = "";
		while ($buf = fread($stream, 4096)) {
			$data .= $buf;
		}
		fclose($stream);

		return $data;
	}
	
	function close()
	{
		ssh2_disconnect($this->connection);
	}
}
