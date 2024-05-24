-- WirePlumber
--
-- Copyright © 2021 Asymptotic
--    @author Arun Raghavan <arun@asymptotic.io>
--
-- SPDX-License-Identifier: MIT
--
-- Route streams of a given role (media.role property) to devices that are
-- intended for that role (device.intended-roles property)

-- Provide the "default" pw_metadata, which stores
-- dynamic properties of pipewire objects in RAM
load_module("metadata")

-- Default client access policy
default_access.enable()

-- Load devices
alsa_monitor.enable()
v4l2_monitor.enable()
libcamera_monitor.enable()

-- Track/store/restore user choices about devices
device_defaults.enable()

-- Track/store/restore user choices about streams
stream_defaults.enable()

load_script("intended-roles.lua")

