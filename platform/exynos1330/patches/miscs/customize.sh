echo "Disable Vulkan"
SET_PROP "vendor" "ro.hwui.use_vulkan" "false"
SET_PROP "vendor" "debug.hwui.renderer" "skiagl"
SET_PROP "vendor" "debug.renderengine.backend" "skiagl"
SET_PROP "vendor" "renderthread.skia.reduceopstasksplitting" "true"
SET_PROP "vendor" "debug.hwui.skia_atrace_enabled" "false"

echo "Fix up /system/build.prop"
SET_PROP "system" "ro.netflix.bsp_rev" --delete
sed -i \
    "/ro.netflix.bsp_rev=EXYNOS1330-36497-1/i persist.audio.deepbuffer_delay=33" \
    "$WORK_DIR/system/system/build.prop"

echo "Disabling encryption"
# Encryption
LINE=$(sed -n "/^\/dev\/block\/by-name\/userdata/=" "$WORK_DIR/vendor/etc/fstab.s5e8535")
sed -i "${LINE}s/,fileencryption=aes-256-xts:aes-256-cts:v2+inlinecrypt_optimized//g" "$WORK_DIR/vendor/etc/fstab.s5e8535"
