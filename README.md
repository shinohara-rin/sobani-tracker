# sobani-tracker

## Introduction

Aim to set up a tracker server for sobani service and clients

## Setup

Clone to your instance

```
git clone https://github.com/nekomeowww/sobani-tracker.git
```

Install dependencies

```
cd sobani-tracker
yarn install
```

Start server

```
yarn run test
```

## API Documentation

### Methods

#### announce

Announce action relates tp the first connection from peer to server, within this action, a client send three parameters to tracker server in order to record and make the share action possible.

If sending is successful, an [announceReceived](#announceReceived)  object will be returned.

**POST** /announce

| Field     | Type    | Required | Description                                         |
| --------- | ------- | -------- | --------------------------------------------------- |
| ip        | string  | yes      | IPv4 address of the announcing instance or computer |
| port      | integer | yes      | Port opened from client                             |
| multiaddr | string  | yes      | Multiaddress generated by client                    |

Expected response from server:

```
{
	"shareId": "1AbhoECj"
}
```

#### pulse

Pulse action meant to make maintaining the connection and the sharing session valid and possible by rapidly sending a packet to server to report the `Alive` state of the client. By doing this, server will store the session and shareId while the clients are alive, if a client stopped to send a packet, server will delete the related shareId and multiaddr it announced before. (**Default expiration time will be 5 minutes**)

If sending is successful, a [pulseReceived](#pulseReceived) object is returned.

**POST** /pulse

| Field     | Type    | Required | Description                                                  |
| --------- | ------- | -------- | ------------------------------------------------------------ |
| override  | boolean | optional | If set to `true`, the following data in this body object will be  updated to server, default is `false` |
| ip        | string  | optional | Based on override param, server will update the ip address according to the given one |
| port      | string  | optional | Based on override param, server will update the port mapping according to the given one |
| multiaddr | string  | optional | Based on override param, server will update the port mapping according to the given one |
| shareId   | boolean | optional | If set to `true`, server will regenerate a shareId to client |

Expected response from server:

```
{
	"status": "0",
	"overriden": false
}
```

#### push

Push action tells the server the unique shareId of the target client the peers shared. Tracker server respond with the multiaddr back to the requesting client, so on, the client can try to establish the connection between. 

If sending is successful, a [pushReceived](#pushReceived) is returned.

**POST** /push

| Field     | Type   | Required | Description                                                  |
| --------- | ------ | -------- | ------------------------------------------------------------ |
| shareId   | string | yes      | The unique shareId from other client, this shareId can  be get through [announce](#announce) method or [pulse](#pulse) method with override set to `true` |
| multiaddr | string | yes      | The multiaddr generated by client, this multiaddr should be the source instance one, not the target instance multiaddr. |

Expected response from server:

```
{
	"multiaddr": "ip4/0.0.0.0/tcp/8080/p2p/0sCFajniCW92aP1fHm49RAhyrKC6uXVj"
}
```

### Types

#### announceReceived

| Field   | Type   | Required | Description                      |
| ------- | ------ | -------- | -------------------------------- |
| shareId | string | yes      | shareId generated by server side |

#### pulseReceived

| Field     | Type    | Required | Description                                   |
| --------- | ------- | -------- | --------------------------------------------- |
| status    | integer | yes      | 0 if pulse sent successful                    |
| overriden | boolean | yes      | `true` if overriden data was successfully set |

#### pushReceived

| Field | Type                    | Required | Description                    |
| ----- | ----------------------- | -------- | ------------------------------ |
| data  | [multiaddr](#multiaddr) | yes      | Object that contains multiaddr |
