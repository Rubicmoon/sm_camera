import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sm_camera/utility/toast_message.dart';

part 'image_camera_controller_state.dart';

class ImageCameraControllerCubit extends Cubit<ImageCameraControllerState> {
  ImageCameraControllerCubit() : super(const ImageCameraControllerState());

  CameraController? controller;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  // double _currentExposureOffset = 0.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  // double _currentScale = 1.0;
  // double _baseScale = 1.0;
  Future<void> initCameraModule({CameraDescription? cameraDescription}) async {
    List<CameraDescription> cameras = [];
    if (cameraDescription == null) {
      cameras = await availableCameras();
    }

    if (cameraDescription == null && cameras.isEmpty) {
      ToastMessage.errorToast("No Camera found");
      return;
    }

    //take the 1st camera from the list as primary camera
    final primaryCamera = cameras.first;

    final CameraController cameraController = CameraController(
      cameraDescription ?? primaryCamera,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    //assign the newly created camera controller
    controller = cameraController;

    try {
      await Future.wait(<Future<Object?>>[
        // The exposure mode is currently not supported on the web.
        ...!kIsWeb
            ? <Future<Object?>>[
                cameraController.getMinExposureOffset().then(
                    (double value) => _minAvailableExposureOffset = value),
                cameraController
                    .getMaxExposureOffset()
                    .then((double value) => _maxAvailableExposureOffset = value)
              ]
            : <Future<Object?>>[],
        cameraController
            .getMaxZoomLevel()
            .then((double value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((double value) => _minAvailableZoom = value),
      ]);
      emit(state.copyWith(controller: controller));
    } on CameraException catch (e) {
      String error = "";
      switch (e.code) {
        case 'CameraAccessDenied':
          error = 'You have denied camera access.';
          break;
        case 'CameraAccessDeniedWithoutPrompt':
          // iOS only
          error = 'Please go to Settings app to enable camera access.';
          break;
        case 'CameraAccessRestricted':
          // iOS only
          error = 'Camera access is restricted.';
          break;
        case 'AudioAccessDenied':
          error = 'You have denied audio access.';
          break;
        case 'AudioAccessDeniedWithoutPrompt':
          // iOS only
          error = 'Please go to Settings app to enable audio access.';
          break;
        case 'AudioAccessRestricted':
          // iOS only
          error = 'Audio access is restricted.';
          break;
        default:
          error = e.toString();
          break;
      }
      ToastMessage.errorToast(error);
    }
  }

  Future<void> onNewCameraChanged(
      CameraDescription newCameraDescription) async {
    if (controller != null) {
      controller!.setDescription(newCameraDescription);
      emit(state.copyWith(controller: controller));
      return;
    } else {
      return initCameraModule(cameraDescription: newCameraDescription);
    }
  }
}
