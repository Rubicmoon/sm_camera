import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sm_camera/sm_image/logic/image_camera_controller/image_camera_controller_cubit.dart';

class _SMImage extends StatefulWidget {
  const _SMImage();

  @override
  State<_SMImage> createState() => _SMImageState();
}

class _SMImageState extends State<_SMImage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
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

    context.read<ImageCameraControllerCubit>().initCameraModule();

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
    _flashModeControlRowAnimationController.dispose();
    _exposureModeControlRowAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
        BlocBuilder<ImageCameraControllerCubit, ImageCameraControllerState>(
      builder: (context, cameraControllerState) {
        return Column(
          children: [
            cameraControllerState.controller == null ||
                    !cameraControllerState.controller!.value.isInitialized
                ? const Center(child: CircularProgressIndicator())
                : CameraPreview(
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
                )
          ],
        );
      },
    ));
  }
}

class SMImagePicker {
  Future<XFile?> captureImage(BuildContext context) async {
    return await Navigator.push(
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
