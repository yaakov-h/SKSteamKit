#!/bin/bash

protoc --objc_out="../../../SteamKit/Messages/GC Protobufs" --proto_path=.. --proto_path=. steammessages.proto gcsystemmsgs.proto base_gcmessages.proto gcsdk_gcmessages.proto econ_gcmessages.proto matchmaker_common.proto dota_gcmessages.proto
