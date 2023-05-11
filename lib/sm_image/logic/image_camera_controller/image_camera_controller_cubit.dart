import 'dart:io';

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sm_camera/utility/toast_message.dart';

part 'image_camera_controller_state.dart';

class ImageCameraControllerCubit extends Cubit<ImageCameraControllerState> {
  ImageCameraControllerCubit() : super(ImageCameraControllerState());

  CameraController? _cameraController;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  // double _currentExposureOffset = 0.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  // double _currentScale = 1.0;
  // double _baseScale = 1.0;

  void dispose() {
    if (_cameraController != null) {
      _cameraController!.dispose();
    }
  }

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

    final CameraController newCameraController = CameraController(
      cameraDescription ?? primaryCamera,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    //assign the newly created camera controller
    _cameraController = newCameraController;

    try {
      await _cameraController!.initialize();
      await Future.wait(<Future<Object?>>[
        // The exposure mode is currently not supported on the web.
        ...!kIsWeb
            ? <Future<Object?>>[
                _cameraController!.getMinExposureOffset().then(
                    (double value) => _minAvailableExposureOffset = value),
                _cameraController!
                    .getMaxExposureOffset()
                    .then((double value) => _maxAvailableExposureOffset = value)
              ]
            : <Future<Object?>>[],
        _cameraController!
            .getMaxZoomLevel()
            .then((double value) => _maxAvailableZoom = value),
        _cameraController!
            .getMinZoomLevel()
            .then((double value) => _minAvailableZoom = value),
      ]);
      emit(state.copyWith(controller: _cameraController));
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
    if (_cameraController != null) {
      _cameraController!.setDescription(newCameraDescription);
      emit(state.copyWith(controller: _cameraController));
      return;
    } else {
      return initCameraModule(cameraDescription: newCameraDescription);
    }
  }

  Future<void> takeImage() async {
    if (_cameraController != null) {
      try {
        emit(state.copyWith(
          isTakingPicture: true,
          imageFile: (state.imageFile = null),
        ));

        final XFile file = await _cameraController!.takePicture();
        emit(state.copyWith(imageFile: File(file.path)));
        return;
      } on CameraException catch (e) {
        ToastMessage.errorToast(e.toString());
        return;
      }
    } else {
      ToastMessage.errorToast("Unable to take image");
    }
  }

  Future<void> reTakeImage() async {
    if (_cameraController != null) {
      emit(state.copyWith(
        imageFile: (state.imageFile = null),
        reTakeImage: true,
      ));
    } else {
      ToastMessage.errorToast("Unable to take image");
    }
  }
}
