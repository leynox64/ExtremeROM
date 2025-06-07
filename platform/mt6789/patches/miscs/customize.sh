echo "Disable Vulkan"
SET_PROP "vendor" "ro.hwui.use_vulkan" "false"
SET_PROP "vendor" "debug.hwui.renderer" "skiagl"
SET_PROP "vendor" "debug.renderengine.backend" "skiagl"
SET_PROP "vendor" "renderthread.skia.reduceopstasksplitting" "true"
SET_PROP "vendor" "debug.hwui.skia_atrace_enabled" "false"

echo "Disabling A/B"
SET_PROP "product" "ro.product.ab_ota_partitions" --delete