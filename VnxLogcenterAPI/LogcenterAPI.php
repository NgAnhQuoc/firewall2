<?php

namespace VnxLogcenterAPI;

use GuzzleHttp\Client;
use GuzzleHttp\Exception\RequestException;
use GuzzleHttp\Exception\ServerException;
use GuzzleHttp\HandlerStack;
use GuzzleHttp\Middleware;
use GuzzleHttp\Cookie\CookieJar;
use GuzzleHttp\Exception\ConnectException;
use Psr\Http\Message\RequestInterface;
use Psr\Http\Message\ResponseInterface;

abstract class LogcenterAPI
{
  protected $endpoint;

  protected $auth;

  protected $client;

  protected $retries;

  public function __construct($endpoint = 'https://push.elastic.webfirewall.vietnix.xyz/filebeat-webfw-*/_search', $retries = 5, $guzzleOptions = [])
  {
    $this->endpoint = $endpoint;
    $this->retries = $retries;
    $this->client = new Client(array_merge([
      'base_uri' => $this->endpoint,
      'verify' => false,
      'cookies' => false,
    ], $guzzleOptions));
  }

  protected function request($method, $uri = '', array $json = [], array $query = [], array $options = [], $decode = true)
  {
    $response = $this->client->request($method, $uri, array_merge([
      'json' => $json,
      'query' => $query
    ], $options));

    return $decode ? json_decode((string)$response->getBody(), true) : (string)$response->getBody();
  }
}
