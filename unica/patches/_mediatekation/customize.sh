    ADD_JAR_TO_CLASSPATH()
{
    _CHECK_NON_EMPTY_PARAM "FILE" "$1"
    _CHECK_NON_EMPTY_PARAM "SCOPE" "$2"
    _CHECK_NON_EMPTY_PARAM "JAR_PATH" "$3"

    local FILE="$1"
    local SCOPE="$2"
    local JAR_PATH="$3"
    local MIN_API="$4"
    local MAX_API="$5"
    local PROTO="$SRC_DIR/unica/patches/_mediatekation/classpaths.proto"

    if [[ "$FILE" == "bootclasspath" ]]; then
        FILE="$WORK_DIR/system/system/etc/classpaths/bootclasspath.pb"
    elif [[ "$FILE" == "systemserverclasspath" ]]; then
        FILE="$WORK_DIR/system/system/etc/classpaths/systemserverclasspath.pb"
    fi

    if [ ! -f "$FILE" ]; then
        _ECHO_STDERR ERR "File not found: ${FILE//$WORK_DIR/}"
        return 1
    fi

    if [[ "$SCOPE" != "UNKNOWN" ]] && [[ "$SCOPE" != "BOOTCLASSPATH" ]] && [[ "$SCOPE" != "SYSTEMSERVERCLASSPATH" ]] && \
      [[ "$SCOPE" != "DEX2OATBOOTCLASSPATH" ]] && [[ "$SCOPE" != "STANDALONE_SYSTEMSERVER_JARS" ]]; then
        _ECHO_STDERR ERR "\"$SCOPE\" is not a valid scope."
        return 1
    fi

    # Decode given binary file to text
    PDR="$(pwd)"
    cd "$(dirname "$FILE")"
    protoc --decode=ExportedClasspathsJars --proto_path="$(dirname "$PROTO")" "$(basename "$PROTO")" < "$(basename "$FILE")" > "$(basename "$FILE").txt"

    # Add to the text file
    echo "jars {" >> "$(basename "$FILE").txt"
    echo "  path: \"$JAR_PATH\"" >> "$(basename "$FILE").txt"
    echo "  classpath: $SCOPE" >> "$(basename "$FILE").txt"
    if [ -n "$MIN_API" ]; then
        echo "  min_sdk_version: \"$MIN_API\"" >> "$(basename "$FILE").txt"
    fi
    if [ -n "$MAX_API" ]; then
        echo "  max_sdk_version: \"$MAX_API\"" >> "$(basename "$FILE").txt"
    fi
    echo "}" >> "$(basename "$FILE").txt"

    # Encode back text file to binary
    protoc --encode=ExportedClasspathsJars --proto_path="$(dirname "$PROTO")" "$(basename "$PROTO")" < "$(basename "$FILE").txt" > "$(basename "$FILE")"
    rm "$(basename "$FILE").txt"
    cd "$PDR"
}

if [[ $TARGET_SINGLE_SYSTEM_IMAGE == "mssi" || $TARGET_SINGLE_SYSTEM_IMAGE == "mssi_64" ]]; then
    echo "Mediatek target device detected! Patching..."

    # Delete all QCOM/QTI blobs
    ITEMS=$(find "$WORK_DIR/product" -name "*qti*")
    for item in $ITEMS
    do
        if [ -e "$item" ]; then
            item_relative=$(echo "$item" | sed "s|$WORK_DIR/product/||")
            DELETE_FROM_WORK_DIR "product" "$item_relative"
        fi
    done

    ITEMS=$(find "$WORK_DIR/system" -name "*qti*" )
    ITEMS+=$(find "$WORK_DIR/system" -name "*qcom*")
    ITEMS+=$(find "$WORK_DIR/system" -name "*qualcomm*")
    ITEMS+=$(find "$WORK_DIR/system" -name "*qcc*")
    ITEMS+=$(find "$WORK_DIR/system" -name "*com.quicinc.cne*")
    for item in $ITEMS
    do
        if [ -e "$item" ]; then
            item_relative=$(echo "$item" | sed "s|$WORK_DIR/system/||")
            DELETE_FROM_WORK_DIR "system" "$item_relative"
        fi
    done

    if $TARGET_HAS_SYSTEM_EXT; then
        ITEMS=$(find "$WORK_DIR/system_ext" -name "*qti*")
        ITEMS+=$(find "$WORK_DIR/system_ext" -name "*qcom*")
        ITEMS+=$(find "$WORK_DIR/system_ext" -name "*qualcomm*")
        ITEMS+=$(find "$WORK_DIR/system_ext" -name "*qcc*")
        ITEMS+=$(find "$WORK_DIR/system_ext" -name "*com.quicinc.cne*")
        for item in $ITEMS
        do
            if [ -e "$item" ]; then
                item_relative=$(echo "$item" | sed "s|$WORK_DIR/system_ext/||")
                DELETE_FROM_WORK_DIR "system_ext" "$item_relative"
            fi
        done
    fi

    # Delete some extra blobs
    BLOBS_LIST="
    system/bin/dhkprov
    system/bin/diagsylincom
    system/bin/sbauth
    system/bin/sec_diag_uart_log
    system/etc/init/dhkprov.rc
    system/etc/init/diagsylincom.rc
    system/etc/init/insthk_qsee.rc
    system/etc/init/sbauth.rc
    system/framework/QPerformance.jar
    system/framework/QXPerformance.jar
    system/framework/UxPerformance.jar
    system/framework/tcmclient.jar
    system/framework/tcmiface.jar
    system/framework/telephony-ext.jar
    system/lib64/blockchain_aidl_comm_client.so
    system/lib64/payment_aidl_comm_client.so
    "
    for blob in $BLOBS_LIST
    do
        DELETE_FROM_WORK_DIR "system" "$blob"
    done

    BLOBS_LIST="
    app
    bin/MemHalTest-system
    bin/diag_callback_sample_system
    bin/diag_dci_sample_RF_ACT
    bin/diag_dci_sample_system
    bin/diag_mdlog_system
    bin/perfservice
    bin/qcrosvm
    bin/test_diag_system
    bin/usbudev
    etc/dpm
    etc/init/perfservice.rc
    etc/init/qsguard.rc
    etc/init/qspa_system.rc
    etc/init/sxrauxd_ext.rc
    etc/init/tcmd.rc
    etc/init/usbudev.rc
    etc/perf
    etc/permissions/audiosphere.xml
    etc/permissions/datachannellib.xml
    etc/permissions/dpmapi.xml
    etc/permissions/privapp-permissions-aptxals.xml
    etc/qspa
    etc/seccomp_policy
    framework/ActivityExt.jar
    framework/audiosphere.jar
    framework/datachannellib.jar
    framework/dpmapi.jar
    framework/qmapbridge.jar
    lib64
    "
    for blob in $BLOBS_LIST
    do
        DELETE_FROM_WORK_DIR "system_ext" "$blob"
    done

    BLOBS_LIST="
    bin
    etc/init
    etc/permissions/UimService.xml
    etc/selinux
    etc/vintf
    framework
    "
    for blob in $BLOBS_LIST
    do
        DELETE_FROM_WORK_DIR "product" "$blob"
    done

    BLOBS_LIST="
    etc/selinux/precompiled_sepolicy.product_sepolicy_and_mapping.sha256
    etc/ueventd.rc
    "
    for blob in $BLOBS_LIST
    do
        DELETE_FROM_WORK_DIR "odm" "$blob"
    done

    #Now Mediatek stuffs, haha
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "product" "etc/permissions/product-permissions-mediatek.xml"

    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/apex/com.android.btservices.apex"

    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/privapp-permissions-mediatek.xml"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/permissions/verizon_net_sip_library.xml"
    DELETE_FROM_WORK_DIR "system" "system/etc/permissions/vexfwk_service_lib.xml"
    DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.app.vex.scanner.xml"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/ams_aal_config.xml"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/audio_effects.conf"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/msync_ctrl_table.xml"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/open_msync_app_list.xml"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/public.libraries-mtk.txt"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/public.libraries-trustonic.txt"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/resolution_tuner_app_list.xml"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/public.libraries-camera.samsung.txt"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/public.libraries-polarr.txt"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/public.libraries-arcsoft.txt"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/TelephonyLog_dynamic.ds"
    DELETE_FROM_WORK_DIR "system" "system/etc/public.libraries-vexfwk.samsung.txt"

    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/framework/verizon.net.sip.jar"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/framework/msync-lib.jar"
    DELETE_FROM_WORK_DIR "system" "system/framework/vexfwk_service_lib.jar"

    ADD_TO_WORK_DIR "gts10pxxx" "system" "system/lib64/libLttEngine.camera.samsung.so"
    ADD_TO_WORK_DIR "gts10pxxx" "system" "system/lib64/libDocShadowRemoval.arcsoft.so"
    {
        echo "libLttEngine.camera.samsung.so"
    } >> "$WORK_DIR/system/system/etc/public.libraries-camera.samsung.txt"

    DELETE_FROM_WORK_DIR "system" "system/priv-app/VexScanner"
    DELETE_FROM_WORK_DIR "system" "system/priv-app/vexfwk_service"

    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "app/MDMLSample/MDMLSample.apk"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "app/mediatek-res/mediatek-res.apk"


    DELETE_FROM_WORK_DIR "system_ext" "bin"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "bin"

    DELETE_FROM_WORK_DIR "system_ext" "lib64"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "lib64"

    DELETE_FROM_WORK_DIR "system_ext" "usp"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "usp"

    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "framework/mediatek-ims-base.jar"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "framework/mediatek-framework.jar"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "framework/mediatek-common.jar"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "framework/log-handler.jar"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "framework/duraspeed.jar"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "framework/DataChannelApi.jar"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "framework/CustomPropInterface.jar"

    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "priv-app/ApmService/ApmService.apk"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "etc/audio_policy_engine_configuration.xml"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "etc/hearing_aid_audio_policy_configuration.xml"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "etc/nr-city.xml"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "etc/custom.conf"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "etc/r_submix_audio_policy_configuration.xml"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "etc/aee-config"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "etc/audio_policy_volumes.xml"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "etc/bluetooth_audio_policy_configuration.xml"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "etc/usb_audio_policy_configuration.xml"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "etc/audio_policy_engine_product_strategies.xml"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "etc/a2dp_audio_policy_configuration.xml"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "etc/audio_policy_engine_default_stream_volumes.xml"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "etc/mtklog-config.prop"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "etc/default_volume_tables.xml"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "etc/spn-conf.xml"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "etc/aee-commit"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "etc/audio_policy_configuration_stub.xml"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "etc/audio_policy_configuration_bluetooth_legacy_hal.xml"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "etc/audio_policy_engine_stream_volumes.xml"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "etc/a2dp_in_audio_policy_configuration.xml"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "etc/audio_policy_configuration.xml"

    DELETE_FROM_WORK_DIR "system_ext" "etc/vintf"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "etc/vintf"

    DELETE_FROM_WORK_DIR "system_ext" "etc/init"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "etc/init"

    DELETE_FROM_WORK_DIR "system_ext" "etc/selinux"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "etc/selinux"

    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "etc/permissions/system-ext-permissions-mediatek.xml"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system_ext" "etc/sysconfig/com.mediatek.ims.config.xml"

    ADD_JAR_TO_CLASSPATH "bootclasspath" "BOOTCLASSPATH" "/system_ext/framework/mediatek-common.jar"
    ADD_JAR_TO_CLASSPATH "bootclasspath" "DEX2OATBOOTCLASSPATH" "/system_ext/framework/mediatek-common.jar"
    ADD_JAR_TO_CLASSPATH "bootclasspath" "BOOTCLASSPATH" "/system_ext/framework/mediatek-framework.jar"
    ADD_JAR_TO_CLASSPATH "bootclasspath" "DEX2OATBOOTCLASSPATH" "/system_ext/framework/mediatek-framework.jar"
    ADD_JAR_TO_CLASSPATH "bootclasspath" "BOOTCLASSPATH" "/system_ext/framework/mediatek-ims-base.jar"
    ADD_JAR_TO_CLASSPATH "bootclasspath" "DEX2OATBOOTCLASSPATH" "/system_ext/framework/mediatek-ims-base.jar"

    SET_METADATA "system" "system/framework/framework-res.apk" 0 0 644 "u:object_r:system_mtk_pmb_file:s0"

    # Set MSSI Props
    SET_PROP "system" "ro.build.product" "mssi"
    SET_PROP "system" "ro.product.system.device" "mssi"
    SET_PROP "system_ext" "ro.product.system_ext.device" "mssi"
    SET_PROP "product" "ro.product.product.device" "mssi"

    # Remove Qualcomm Props
    SET_PROP "system" "rild.libpath" --delete
    SET_PROP "system" "ril.subscription.types" --delete
    SET_PROP "system" "DEVICE_PROVISIONED" --delete
    SET_PROP "system" "dalvik.vm.heapsize" --delete
    SET_PROP "system" "dev.pm.dyn_samplingrate" --delete
    SET_PROP "system" "qcom.hw.aac.encoder" --delete
    SET_PROP "system" "persist.vendor.cne.feature" --delete
    SET_PROP "system" "media.stagefright.enable-player" --delete
    SET_PROP "system" "media.stagefright.enable-http" --delete
    SET_PROP "system" "media.stagefright.enable-aac" --delete
    SET_PROP "system" "media.stagefright.enable-qcp" --delete
    SET_PROP "system" "media.stagefright.enable-fma2dp" --delete
    SET_PROP "system" "media.stagefright.enable-scan" --delete
    SET_PROP "system" "media.stagefright.thumbnail.prefer_hw_codecs" --delete
    SET_PROP "system" "mmp.enable.3g2" --delete
    SET_PROP "system" "media.aac_51_output_enabled" --delete
    SET_PROP "system" "vendor.mm.enable.qcom_parser" --delete
    SET_PROP "system" "ro.bluetooth.library_name" --delete
    SET_PROP "system" "persist.vendor.btstack.aac_frm_ctl.enabled" --delete
    SET_PROP "system" "persist.rmnet.data.enable" --delete
    SET_PROP "system" "persist.data.wda.enable" --delete
    SET_PROP "system" "persist.data.df.dl_mode" --delete
    SET_PROP "system" "persist.data.df.ul_mode" --delete
    SET_PROP "system" "persist.data.df.agg.dl_pkt" --delete
    SET_PROP "system" "persist.data.df.agg.dl_size" --delete
    SET_PROP "system" "persist.data.df.mux_count" --delete
    SET_PROP "system" "persist.data.df.iwlan_mux" --delete
    SET_PROP "system" "persist.data.df.dev_name" --delete
    SET_PROP "system" "sys.qca1530" --delete
    SET_PROP "system" "persist.debug.coresight.config" --delete
    SET_PROP "system" "persist.vendor.radio.atfwd.start" --delete
    SET_PROP "system" "qemu.hw.mainkeys" --delete
    SET_PROP "system" "vendor.camera.aux.packagelist" --delete
    SET_PROP "system" "persist.vendor.camera.privapp.list" --delete
    SET_PROP "system" "debug.stagefright.ccodec" --delete
    SET_PROP "system" "ro.media.recorder-max-base-layer-fps" --delete
    SET_PROP "system" "ro.charger.enable_suspend" --delete
    SET_PROP "system" "arm64.memtag.process.system_server" --delete
    SET_PROP "system" "ro.launcher.blur.appLaunch" --delete
    SET_PROP "system" "ro.bluetooth.finder.supported" --delete
    SET_PROP "system" "ro.vendor.qti.va_aosp.support" --delete

    #Add Mediatek Props
    SET_PROP "system" "Build.BRAND" "MTK"
    SET_PROP "system" "debug.sf.enable_gl_backpressure" "0"
    SET_PROP "system" "debug.sf.enable_transaction_tracing" "false"
    SET_PROP "system" "debug.sf.predict_hwc_composition_strategy" "0"
    SET_PROP "system" "debug.sf.treat_170m_as_sRGB" "1"
    SET_PROP "system" "debug.stagefright.c2inputsurface" "-1"
    SET_PROP "system" "media.stagefright.thumbnail.prefer_hw_codecs" "true"
    SET_PROP "system" "mediatek.wlan.ctia" "0"
    SET_PROP "system" "persist.log.tag.BufferQueueDump" "I"
    SET_PROP "system" "persist.log.tag.BufferQueueProducer" "I"
    SET_PROP "system" "persist.log.tag.GraphicBuffer" "I"
    SET_PROP "system" "persist.log.tag.SurfaceControl" "I"
    SET_PROP "system" "persist.sys.fuse.passthrough.enable" "true"
    SET_PROP "system" "persist.vendor.mdlog.flush_log_ratio" "0"
    SET_PROP "system" "persist.vendor.mtk.vilte.enable" "1"
    SET_PROP "system" "persist.vendor.pco5.radio.ctrl" "0"
    SET_PROP "system" "persist.vendor.pms_removable" "1"
    SET_PROP "system" "persist.vendor.vilte_support" "1"
    SET_PROP "system" "persist.vendor.vzw_device_type" "0"
    SET_PROP "system" "persist.vendor.wfc.sys_wfc_support" "1"
    SET_PROP "system" "qemu.hw.mainkeys" "0"
    SET_PROP "system" "ro.audio.flinger_standbytime_ms" "1000"
    SET_PROP "system" "ro.audio.ihaladaptervendorextension_enabled" "true"
    SET_PROP "system" "ro.audio.silent" "0"
    SET_PROP "system" "ro.audio.usb.period_us" "16000"
    SET_PROP "system" "ro.base_build" "noah"
    SET_PROP "system" "ro.config.per_app_memcg" "false"
    SET_PROP "system" "ro.iorapd.enable" "false"
    SET_PROP "system" "ro.kernel.qemu" "0"
    SET_PROP "system" "ro.kernel.zio" "38,108,105,16"
    SET_PROP "system" "ro.llndk.api_level" "202404"
    SET_PROP "system" "ro.logd.auditd.events" "false"
    SET_PROP "system" "ro.logd.auditd.main" "false"
    SET_PROP "system" "ro.mediatek.version.branch" "alps-mp-v0.mssi1.tc10sp"
    SET_PROP "system" "ro.mediatek.version.build.branch" ""
    SET_PROP "system" "ro.mediatek.version.release" "alps-mp-v0.mp1.tc10sp-V1.61.1"
    SET_PROP "system" "ro.mediatek.wlan.p2p" "1"
    SET_PROP "system" "ro.mediatek.wlan.wsc" "1"
    SET_PROP "system" "ro.mtk_perf_fast_start_win" "1"
    SET_PROP "system" "ro.mtk_perf_response_time" "1"
    SET_PROP "system" "ro.mtk_perf_simple_start_win" "1"
    SET_PROP "system" "ro.opengles.version" "196610"
    SET_PROP "system" "ro.property_service.async_persist_writes" "true"
    SET_PROP "system" "ro.surface_flinger.game_default_frame_rate_override" "60"
    SET_PROP "system" "ro.sys.usb.bicr" "no"
    SET_PROP "system" "ro.sys.usb.charging.only" "yes"
    SET_PROP "system" "ro.sys.usb.mtp.whql.enable" "0"
    SET_PROP "system" "ro.sys.usb.storage.type" "mtp"
    SET_PROP "system" "ro.vendor.customer_logpath" "/data"
    SET_PROP "system" "ro.vendor.have_aee_feature" "1"
    SET_PROP "system" "ro.vendor.mtk_flv_playback_support" "1"
    SET_PROP "system" "ro.vendor.mtk_omacp_support" "1"
    SET_PROP "system" "ro.vendor.mtk_telephony_add_on_policy" "0"
    SET_PROP "system" "ro.vendor.system.mtk_dmc_support" "1"
    SET_PROP "system" "ro.zygote.preload.enable" "0"
    SET_PROP "system" "sys.ipo.disable" "1"
    SET_PROP "system" "sys.ipo.pwrdncap" "2"
    SET_PROP "system" "vendor.af.dynamic.sleeptime.enable" "true"
    SET_PROP "system" "vendor.af.pausewait.enable" "false"
    SET_PROP "system" "vendor.af.threshold.src_and_effect_count" "5"
    SET_PROP "system" "vendor.mtk_thumbnail_optimization" "true"
    SET_PROP "system" "vendor.rild.libargs" "-d /dev/ttyC0"
    SET_PROP "system" "wifi.direct.interface" "p2p0"
    SET_PROP "system" "wifi.interface" "wlan0"
    SET_PROP "system" "wifi.tethering.interface" "ap0"

    else
    echo "Target device is not a Mediatek. Ignoring"
fi
