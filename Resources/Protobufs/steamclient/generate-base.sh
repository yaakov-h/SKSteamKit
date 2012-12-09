#!/bin/bash

protoc --objc_out="../../../SteamKit/Messages/Steam Protobufs" --proto_path=.. --proto_path=. steammessages_base.proto encrypted_app_ticket.proto steammessages_clientserver.proto content_manifest.proto iclient_objects.proto