// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sm_camera/sm_image/logic/image_camera_controller/image_camera_controller_cubit.dart';
import 'package:sm_camera/sm_image/widget/camera_action_button.dart';
import 'package:sm_camera/sm_image/widget/capture_button_widget.dart';
import 'package:sm_camera/sm_image/widget/image_action_button.dart';

class _SMImage extends StatefulWidget {
  const _SMImage();

  @override
  State<_SMImage> createState() => _SMImageState();
}

class _SMImageState extends State<_SMImage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late ImageCameraControllerCubit imageCameraControllerCubit;

  late AnimationController _flashModeControlRowAnimationController;
  late AnimationController _exposureModeControlRowAnimationController;
  // late AnimationController _focusModeControlRowAnimationController;
  // late Animation<double> _flashModeControlRowAnimation;
  // late Animation<double> _exposureModeControlRowAnimation;
  // late Animation<double> _focusModeControlRowAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    imageCameraControllerCubit = context.read<ImageCameraControllerCubit>();
    imageCameraControllerCubit.initCameraModule();

    // _flashModeControlRowAnimationController = AnimationController(
    //   duration: const Duration(milliseconds: 300),
    //   vsync: this,
    // );
    // _flashModeControlRowAnimation = CurvedAnimation(
    //   parent: _flashModeControlRowAnimationController,
    //   curve: Curves.easeInCubic,
    // );
    // _exposureModeControlRowAnimationController = AnimationController(
    //   duration: const Duration(milliseconds: 300),
    //   vsync: this,
    // );
    // _exposureModeControlRowAnimation = CurvedAnimation(
    //   parent: _exposureModeControlRowAnimationController,
    //   curve: Curves.easeInCubic,
    // );
    // _focusModeControlRowAnimationController = AnimationController(
    //   duration: const Duration(milliseconds: 300),
    //   vsync: this,
    // );
    // _focusModeControlRowAnimation = CurvedAnimation(
    //   parent: _focusModeControlRowAnimationController,
    //   curve: Curves.easeInCubic,
    // );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _flashModeControlRowAnimationController.dispose();
    _exposureModeControlRowAnimationController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      imageCameraControllerCubit.dispose();
    } else if (state == AppLifecycleState.resumed) {
      imageCameraControllerCubit.initCameraModule();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body:
            BlocBuilder<ImageCameraControllerCubit, ImageCameraControllerState>(
          builder: (context, cameraControllerState) {
            return cameraControllerState.controller == null ||
                    !cameraControllerState.controller!.value.isInitialized
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : cameraControllerState.imageFile != null &&
                        !cameraControllerState.reTakeImage
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: ImageActionButton(
                              onRetry: () {
                                context
                                    .read<ImageCameraControllerCubit>()
                                    .reTakeImage();
                              },
                              onOk: () {
                                Navigator.pop<File?>(
                                  context,
                                  cameraControllerState.imageFile,
                                );
                              },
                            ),
                          ),
                          Image.file(cameraControllerState.imageFile!),
                        ],
                      )
                    : Column(
                        children: [
                          CameraActionButton(
                            onCameraChange: () {
                              context
                                  .read<ImageCameraControllerCubit>()
                                  .changeCamera();
                            },
                            onFlashLight: () {
                              context
                                  .read<ImageCameraControllerCubit>()
                                  .toggleFlash();
                            },
                            isFlashOn: cameraControllerState.isFlashOn,
                          ),
                          CameraPreview(
                            cameraControllerState.controller!,
                            // child: LayoutBuilder(
                            //   builder:
                            //       (BuildContext context, BoxConstraints constraints) {
                            //     return GestureDetector(
                            //       behavior: HitTestBehavior.opaque,
                            //       onScaleStart: _handleScaleStart,
                            //       onScaleUpdate: _handleScaleUpdate,
                            //       onTapDown: (TapDownDetails details) =>
                            //           onViewFinderTap(details, constraints),
                            //     );
                            //   },
                            // ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CaptureButtonWidget(
                                  showLoading:
                                      cameraControllerState.isTakingPicture,
                                  onTap: () {
                                    if (!cameraControllerState
                                        .controller!.value.isTakingPicture) {
                                      context
                                          .read<ImageCameraControllerCubit>()
                                          .takeImage();
                                    }
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      );
          },
        ),
      ),
    );
  }
}

class SMImagePicker {
  Future<File?> captureImage(BuildContext context) async {
    return await Navigator.push<File?>(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ImageCameraControllerCubit(),
          child: const _SMImage(),
        ),
      ),
    );
  }
}
