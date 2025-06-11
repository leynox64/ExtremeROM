echo "Disable Vulkan"
SET_PROP "vendor" "ro.hwui.use_vulkan" "false"
SET_PROP "vendor" "debug.hwui.renderer" "skiagl"
SET_PROP "vendor" "debug.renderengine.backend" "skiagl"
SET_PROP "vendor" "renderthread.skia.reduceopstasksplitting" "true"
SET_PROP "vendor" "debug.hwui.skia_atrace_enabled" "false"

echo "Disabling A/B"
SET_PROP "product" "ro.product.ab_ota_partitions" --delete

echo "Fix up /system/build.prop"
SET_PROP "system" "ro.netflix.bsp_rev" --delete
sed -i \
    "/ro.netflix.bsp_rev=EXYNOS1380-36589-1/i persist.audio.deepbuffer_delay=33" \
    "$WORK_DIR/system/system/build.prop"

echo "Setting FUSE passthough"
SET_PROP "vendor" "persist.sys.fuse.passthrough.enable" "true"

echo "Improve WiFi/Mobile Data speeds"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "product" "app/ConnectivityUxOverlay" 0 0 755 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "product" "app/NetworkStackOverlay" 0 0 755 "u:object_r:system_file:s0"