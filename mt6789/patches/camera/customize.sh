echo "Add stock dualcam libs"
BLOBS_LIST="
system/lib64/libdualcam_portraitlighting_gallery_360.so
system/lib64/libdualcam_refocus_gallery_48.so
system/lib64/libdualcam_refocus_gallery_50.so
system/lib64/libdualcam_refocus_gallery_54.so
system/lib64/libdualcam_refocus_gallery_beyond.so
system/lib64/libdualcam_refocus_gallery_front_beyond.so
system/lib64/libdualcam_refocus_gallery_wt_beyond.so
system/lib64/libdualcam_refocus_image.so
system/lib64/libdualcam_refocus_image_lite.so
system/lib64/libDualCamBokehCapture.camera.samsung.so
"
for blob in $BLOBS_LIST
do
    DELETE_FROM_WORK_DIR "system" "$blob"
done

BLOBS_LIST="
system/lib64/libdualcam_portraitlighting_gallery_360_lite.so
system/lib64/libdualcam_refocus_gallery_48.so
system/lib64/libdualcam_refocus_gallery_50.so
system/lib64/libdualcam_refocus_gallery_54.so
system/lib64/libdualcam_refocus_gallery_beyond.so
system/lib64/libdualcam_refocus_gallery_front_beyond.so
system/lib64/libdualcam_refocus_gallery_wt_beyond.so
"
for blob in $BLOBS_LIST
do
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
done

echo "Add stock arcsoft libs"
BLOBS_LIST="
system/lib64/lib_pet_detection.arcsoft.so
system/lib64/libae_bracket_hdr.arcsoft.so
system/lib64/libai_fusion_high_resolution.arcsoft.so
system/lib64/libai_fusion_high_resolution_base_v1.arcsoft.so
system/lib64/libai_fusion_high_resolution_base_v2.arcsoft.so
system/lib64/libarcsoft_photoeditor.arcsoft.so
system/lib64/libbeautyshot.arcsoft.so
system/lib64/libface_landmark.arcsoft.so
system/lib64/libface_recognition.arcsoft.so
system/lib64/libFaceRecognition.arcsoft.so
system/lib64/libFacialAttributeDetection.arcsoft.so
system/lib64/libfacialrestoration.arcsoft.so
system/lib64/libFacialStickerEngine.arcsoft.so
system/lib64/libfrtracking_engine.arcsoft.so
system/lib64/libGalleryDistortionCorrection.arcsoft.so 
system/lib64/libGalleryDistortionDetector.arcsoft.so
system/lib64/libhumantracking.arcsoft.so 
system/lib64/libhybrid_high_dynamic_range.arcsoft.so 
system/lib64/libimage_enhancement.arcsoft.so 
system/lib64/libmf_bayer_enhance.arcsoft.so
system/lib64/libobjectcapture.arcsoft.so
system/lib64/libobjectcapture_jni.arcsoft.so
system/lib64/libpic_best.arcsoft.so
system/lib64/libPortraitDistortionCorrection.arcsoft.so
system/lib64/libPortraitDistortionCorrectionCali.arcsoft.so
system/lib64/libsf_tetra_enhance.arcsoft.so
system/lib64/libsnapshotdebanding.arcsoft.so
system/lib64/libsuper_fusion.arcsoft.so
system/lib64/libveengine.arcsoft.so
system/lib64/libarcsoft_dualcam_portraitlighting.so
system/lib64/libarcsoft_dualcam_portraitlighting_lite.so
system/lib64/libarcsoft_photoeditor.arcsoft.so
system/lib64/libarcsoft_single_cam_glasses_seg.so
"
for blob in $BLOBS_LIST
do
    DELETE_FROM_WORK_DIR "system" "$blob"
done

BLOBS_LIST="
libarcsoft_photoeditor.arcsoft.so
libbeautyshot.arcsoft.so
libface_landmark.arcsoft.so
libFacialAttributeDetection.arcsoft.so
libhigh_dynamic_range.arcsoft.so
liblow_light_hdr.arcsoft.so
libsupernight_auto_raw.arcsoft.so
libsupernight_raw.arcsoft.so
"
for blob in $BLOBS_LIST
do
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
done

echo "Add stock public librairies"
BLOBS_LIST="
system/etc/public.libraries-arcsoft.txt
system/etc/public.libraries-camera.samsung.txt
"
for blob in $BLOBS_LIST
do
    DELETE_FROM_WORK_DIR "system" "$blob"
done

BLOBS_LIST="
system/etc/public.libraries-arcsoft.txt
system/etc/public.libraries-camera.samsung.txt
"
for blob in $BLOBS_LIST
do
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
done

echo "Add stock camera libs"
BLOBS_LIST="
system/lib64/libHpr_RecFace_dl_v1.0.camera.samsung.so
system/lib64/libsupernight_wrapper_v3.camera.samsung.so
system/lib64/libsaiv_HprFace_cmh_support_jni.camera.samsung.so
system/lib64/libSceneDetector_v1.camera.samsung.so
system/lib64/libtensorflowLite.camera.samsung.so
system/lib64/libtensorflowLite.myfilter.camera.samsung.so
system/lib64/libtensorflowlite_inference_api.camera.samsung.so
system/lib64/libtensorflowlite_inference_api.myfilter.camera.samsung.so
"
for blob in $BLOBS_LIST
do
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
done