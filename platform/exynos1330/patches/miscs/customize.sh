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
    "/ro.netflix.bsp_rev=EXYNOS1330-36497-1/i persist.audio.deepbuffer_delay=33" \
    "$WORK_DIR/system/system/build.prop"