if [[ $TARGET_SINGLE_SYSTEM_IMAGE == "qssi" || $TARGET_SINGLE_SYSTEM_IMAGE == "essi" || $TARGET_SINGLE_SYSTEM_IMAGE == "mssi" ]]; then
    echo "Target device with 32-Bit HALs detected! Patching..."

if [ $TARGET_CODENAME == "a15" ]; then
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib" 0 0 644 "u:object_r:system_lib_file:s0"

    BLOBS_LIST="
    system/apex/com.android.i18n.apex
    system/apex/com.android.runtime.apex
    system/apex/com.google.android.tzdata6.apex
    system/bin/linker
    system/bin/linker_asan
    system/bin/bootstrap/linker
    system/bin/bootstrap/linker_asan
    "
    for blob in $BLOBS_LIST
    do
        ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "$blob" 0 0 644 "u:object_r:system_file:s0"
    done

    BLOBS_LIST="
    system/bin/linker
    system/bin/bootstrap/linker
    "
    for blob in $BLOBS_LIST
    do
        ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "$blob" 0 0 644 "u:object_r:system_linker_exec:s0"
    done
else
    ADD_TO_WORK_DIR "dm3qxxx" "system" "system/lib" 0 0 644 "u:object_r:system_lib_file:s0"

    BLOBS_LIST="
    system/apex/com.android.i18n.apex
    system/apex/com.android.runtime.apex
    system/apex/com.google.android.tzdata6.apex
    system/bin/linker
    system/bin/linker_asan
    system/bin/bootstrap/linker
    system/bin/bootstrap/linker_asan
    "
    for blob in $BLOBS_LIST
    do
        ADD_TO_WORK_DIR "dm3qxxx" "system" "$blob"
    done

    BLOBS_LIST="
    system/bin/linker
    system/bin/bootstrap/linker
    "
    for blob in $BLOBS_LIST
    do
        ADD_TO_WORK_DIR "dm3qxxx" "system" "$blob"
    done
fi

    # Set props
    echo "Setting props..."
    SET_PROP "vendor" "ro.vendor.product.cpu.abilist" "arm64-v8a"
    SET_PROP "vendor" "ro.vendor.product.cpu.abilist32" ""
    SET_PROP "vendor" "ro.vendor.product.cpu.abilist64" "arm64-v8a"
    SET_PROP "vendor" "ro.zygote" "zygote64"
    SET_PROP "vendor" "dalvik.vm.dex2oat64.enabled" "true"

else
    echo "Target device does not use 32-Bit HALs. Ignoring"
fi
