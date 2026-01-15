# Fix MIDAS model detection
sed -i "s/$SOURCE_CODENAME/dummy/g" "$WORK_DIR/vendor/etc/midas/midas_config.json"
sed -i "s/a54x/$SOURCE_CODENAME/g" "$WORK_DIR/vendor/etc/midas/midas_config.json"

# Add A54 MIDAS libraries
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/libmidas_core.camera.samsung.so"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/libmidas_DNNInterface.camera.samsung.so"