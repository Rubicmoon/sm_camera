// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sm_camera/sm_image/logic/image_camera_controller/image_camera_controller_cubit.dart';
import 'package:sm_camera/sm_image/widget/capture_button_widget.dart';

class _SMImage extends StatefulWidget {
  const _SMImage();

  @override
  State<_SMImage> createState() => _SMImageState();
}

class _SMImageState extends State<_SMImage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late ImageCameraControllerCubit imageCameraControllerCubit;

  late AnimationController _flashModeControlRowAnimationController;
  late Animation<double> _flashModeControlRowAnimation;
  late AnimationController _exposureModeControlRowAnimationController;
  late Animation<double> _exposureModeControlRowAnimation;
  late AnimationController _focusModeControlRowAnimationController;
  late Animation<double> _focusModeControlRowAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    imageCameraControllerCubit = context.read<ImageCameraControllerCubit>();
    imageCameraControllerCubit.initCameraModule();

    _flashModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flashModeControlRowAnimation = CurvedAnimation(
      parent: _flashModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _exposureModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _exposureModeControlRowAnimation = CurvedAnimation(
      parent: _exposureModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _focusModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _focusModeControlRowAnimation = CurvedAnimation(
      parent: _focusModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    imageCameraControllerCubit.dispose();
    _flashModeControlRowAnimationController.dispose();
    _exposureModeControlRowAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body:
            BlocBuilder<ImageCameraControllerCubit, ImageCameraControllerState>(
          builder: (context, cameraControllerState) {
            print(
                "cameraControllerState.imageFile: ${cameraControllerState.imageFile}");

            print(
                "cameraControllerState.reTakeImage: ${cameraControllerState.reTakeImage}");
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
                            child: ImageActionButtonsWidget(
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

class ImageActionButtonsWidget extends StatelessWidget {
  final void Function() onRetry;
  final void Function() onOk;
  const ImageActionButtonsWidget({
    Key? key,
    required this.onRetry,
    required this.onOk,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OutlinedButton(
          style: ButtonStyle(
            side: MaterialStateProperty.all(
              const BorderSide(color: Colors.white),
            ),
          ),
          onPressed: onRetry,
          child: const Text(
            "RETRY",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        OutlinedButton(
          style: ButtonStyle(
            side: MaterialStateProperty.all(
              const BorderSide(color: Colors.white),
            ),
          ),
          onPressed: onOk,
          child: const Text(
            "OK",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ],
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
