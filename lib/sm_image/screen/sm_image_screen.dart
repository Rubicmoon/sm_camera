import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
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
  late ImageCameraControllerCubit imageCameraControllerCubit =
      context.read<ImageCameraControllerCubit>();

  // late AnimationController _flashModeControlRowAnimationController;
  // late AnimationController _exposureModeControlRowAnimationController;
  // late AnimationController _focusModeControlRowAnimationController;
  // late Animation<double> _flashModeControlRowAnimation;
  // late Animation<double> _exposureModeControlRowAnimation;
  // late Animation<double> _focusModeControlRowAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

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

  //TODO:Need to check
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // _flashModeControlRowAnimationController.dispose();
    // _exposureModeControlRowAnimationController.dispose();
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.inactive) {
  //     imageCameraControllerCubit.dispose();
  //   } else if (state == AppLifecycleState.resumed) {
  //     imageCameraControllerCubit.initCameraModule();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocConsumer<ImageCameraControllerCubit,
            ImageCameraControllerState>(
          buildWhen: (previous, current) {
            return !current.cameraFailed;
          },
          listener: (_, cameraControllerState) async {
            if (cameraControllerState.cameraPermanentlyDenied) {
              await showDialog<bool>(
                context: context,
                useRootNavigator: false,
                builder: (_) => AlertDialog.adaptive(
                  content: const Text(
                      "Camera permission has been permanently denied. Please open the settings to grant the Camera permission."),
                  actions: [
                    OutlinedButton(
                      onPressed: () async {
                        await openAppSettings().whenComplete(
                          () =>
                              //close the dialog
                              Navigator.pop(context, true),
                        );
                      },
                      child: const Text(
                        "Open setting",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        //close the dialog
                        Navigator.pop(context, true);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ).then((value) {
                if (value != null) {
                  //close the screen
                  Navigator.pop(context);
                }
              });
            } else if (cameraControllerState.cameraDenied ||
                cameraControllerState.cameraFailed) {
              Navigator.pop(context);
            }
          },
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
                                Navigator.pop<XFile?>(
                                  context,
                                  cameraControllerState.imageFile,
                                );
                              },
                            ),
                          ),
                          Image.file(
                              File(cameraControllerState.imageFile!.path)),
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
                          Expanded(
                            child: CameraPreview(
                              cameraControllerState.controller!,
                            ),
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
  Future<XFile?> captureImage(BuildContext context) async {
    return Navigator.push<XFile?>(
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
