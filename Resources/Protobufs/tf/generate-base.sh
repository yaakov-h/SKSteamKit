#!/bin/bash

protoc --objc_out="../../../SteamKit/Messages/GC Protobufs" --proto_path=.. --proto_path=. tf_gcmessages.proto
