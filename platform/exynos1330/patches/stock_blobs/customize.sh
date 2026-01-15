echo "Replacing SoundBooster"
DELETE_FROM_WORK_DIR "system" "system/lib64/lib_SoundBooster_ver2060.so"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/lib_SoundBooster_ver1100.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/libsamsungSoundbooster_plus_legacy.so" 0 0 644 "u:object_r:system_lib_file:s0"

echo "Add stock audio policy"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/stage_policy.conf" 0 0 644 "u:object_r:system_file:s0"

echo "Delete Hotword"
DELETE_FROM_WORK_DIR "product" "priv-app/HotwordEnrollmentXGoogleEx6_WIDEBAND_LARGE"
DELETE_FROM_WORK_DIR "product" "priv-app/HotwordEnrollmentYGoogleEx6_WIDEBAND_LARGE"



