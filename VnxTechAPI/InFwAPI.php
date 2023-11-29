<?php

namespace VnxTechAPI;

use GuzzleHttp\Client;
use GuzzleHttp\Exception\RequestException;
use GuzzleHttp\Exception\ServerException;
use GuzzleHttp\HandlerStack;
use GuzzleHttp\Middleware;
use GuzzleHttp\Cookie\CookieJar;
use GuzzleHttp\Exception\ConnectException;
use Psr\Http\Message\RequestInterface;
use Psr\Http\Message\ResponseInterface;

abstract class InFwAPI
{
    protected $endpoint;

    protected $auth;

    protected $client;

    protected $retries;

    protected $fwip = '';

    public function __construct($endpoint = ':8081/v1/api/waf/', $fwip, $retries = 5, $guzzleOptions = [])
    {
        $this->endpoint = 'http://' . $fwip . $endpoint;
        $this->retries = $retries;
        $this->fwip = $fwip;

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
